elm-media
---------

`elm-media` is a small Elm library for extracting social media URLs from text.
The typical use-case for this library is to embed videos and images from around
the web into webpages.

[Documentation](http://package.elm-lang.org/packages/liamcurry/elm-media/) | [Demo](http://liamcurry.com/elm-media/)

## Example

```elm
import Media
import Media.Site as Site

text = """https://imgur.com/cjCGCNH
https://youtu.be/oYk8CKH7OhE
https://www.youtube.com/watch?v=DfLvDFxcAIA
"""

{- This will extract media references in "text" for all supported sites, and
   generate URLs for each reference.
-}
results =
  text
    |> Media.find Site.all
    |> Media.urls
```

## Supported sites

- [Gfycat](https://gfycat.com)
- [Imgur](https://imgur.com)
- [Livecap](https://livecap.tv)
- [Oddshot](https://oddshot.tv)
- [Twitch](https://twitch.tv)
- [YouTube](https://youtube.com)
