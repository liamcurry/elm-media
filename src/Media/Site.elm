module Media.Site (image, video, all) where

{-| This package includes representations of various social media sites.

@docs all, image, video
-}

import Media exposing (Site)
import Media.Site.Gfycat as Gfycat
import Media.Site.Imgur as Imgur
import Media.Site.Livecap as Livecap
import Media.Site.Oddshot as Oddshot
import Media.Site.Twitch as Twitch
import Media.Site.YouTube as YouTube


{-| Sites that are for image sharing. Includes:

- [Gfycat](//gfycat.com)
- [Imgur](//imgur.com)
-}
image : List Site
image =
  [ Gfycat.site
  , Imgur.site
  ]


{-| Sites that are for watching videos/streams. Includes:

- [LiveCap](//livecap.tv)
- [Oddshot](//oddshot.tv)
- [Twitch](//twitch.tv)
- [YouTube](//youtube.com)
-}
video : List Site
video =
  [ Livecap.site
  , Oddshot.site
  , Twitch.site
  , YouTube.site
  ]


{-| All available sites.
-}
all : List Site
all =
  List.concat
    [ image
    , video
    ]
