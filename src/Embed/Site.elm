module Embed.Site (image, video, all) where

import Regex exposing (Regex)
import Embed.Model exposing (..)
import Embed.Site.Gfycat as Gfycat
import Embed.Site.Imgur as Imgur
import Embed.Site.Livecap as Livecap
import Embed.Site.Oddshot as Oddshot
import Embed.Site.Twitch as Twitch
import Embed.Site.YouTube as YouTube


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
