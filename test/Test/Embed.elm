module Test.Embed (tests) where

import ElmTest exposing (..)
import Test.Embed.Gfycat as Gfycat
import Test.Embed.Twitch as Twitch
import Test.Embed.Imgur as Imgur
import Test.Embed.Livecap as Livecap
import Test.Embed.YouTube as YouTube


tests : Test
tests =
  suite
    "Media"
    [ Gfycat.tests
    , Twitch.tests
    , Imgur.tests
    , Livecap.tests
    , YouTube.tests
    ]
