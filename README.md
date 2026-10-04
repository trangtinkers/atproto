# atproto

Notes and small programs from learning the AT Protocol (the protocol behind
Bluesky), and whatever else turns up along the way.

## Files

- [`at_uri.rkt`](at_uri.rkt): turns a `bsky.app` post link into an `at://` URI.
  It's the first step of a bash script I use to download whole Bluesky threads,
  pulled out on its own so I could understand it. It's written in
  [Rash](https://docs.racket-lang.org/rash/), a shell language built on Racket,
  which I learned while writing it.

  ```
  raco pkg install rash
  racket at_uri.rkt https://bsky.app/profile/bsky.app/post/3l6oveex3ii2l
  # at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3l6oveex3ii2l
  ```
