#lang rash

;; Step 1 of download_bluesky_thread.sh, on its own: turn a bsky.app link into
;; an at:// URI.
;;
;;   racket at_uri.rkt https://bsky.app/profile/bsky.app/post/3l6oveex3ii2l
;;
;; An at:// URI names exactly one record in one person's repo:
;;
;;   at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3l6oveex3ii2l
;;        └─ repo (whose data) ─────────┘ └─ collection ───┘ └─ record key ┘
;;
;; The web URL carries the same three parts, except it usually has a *handle*
;; (bsky.app) where the DID goes. Handles can change; DIDs cannot. So the only
;; network call here is handle -> DID.

(require racket/match racket/string json)

(define api "https://public.api.bsky.app/xrpc")

;; In Rash, a line starting with "(" is Racket; anything else is a shell
;; pipeline. #{...} runs a pipeline from inside Racket and returns its output
;; as a string, and $name passes a Racket variable as an argument.

(define (resolve-handle handle)
  (define url (format "~a/com.atproto.identity.resolveHandle?handle=~a" api handle))
  (hash-ref (string->jsexpr #{curl -sf $url}) 'did))

(define (at-uri input)
  (match input
    [(regexp #rx"^at://") input]
    [(regexp #rx"bsky.app/profile/([^/]+)/post/([^/?#]+)" (list _ who rkey))
     (define did (if (string-prefix? who "did:") who (resolve-handle who)))
     (format "at://~a/app.bsky.feed.post/~a" did rkey)]
    [_ (error 'at-uri "unrecognized input: ~a" input)]))

(define args (current-command-line-arguments))
(if (zero? (vector-length args))
    (eprintf "usage: racket at_uri.rkt <bsky.app URL | at:// URI>\n")
    (displayln (at-uri (vector-ref args 0))))
