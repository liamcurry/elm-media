module Test.Media (tests) where

import ElmTest exposing (..)
import Test.Media.Gfycat as Gfycat
import Test.Media.Twitch as Twitch
import Test.Media.Imgur as Imgur
import Test.Media.Livecap as Livecap
import Test.Media.YouTube as YouTube


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
