module Media.Site (image, video, all) where

import Media exposing (Site)
import Media.Site.Gfycat as Gfycat
import Media.Site.Imgur as Imgur
import Media.Site.Livecap as Livecap
import Media.Site.Oddshot as Oddshot
import Media.Site.Twitch as Twitch
import Media.Site.YouTube as YouTube


image : List Site
image =
  [ Gfycat.site
  , Imgur.site
  ]


video : List Site
video =
  [ Livecap.site
  , Oddshot.site
  , Twitch.site
  , YouTube.site
  ]


all : List Site
all =
  List.concat
    [ image
    , video
    ]
