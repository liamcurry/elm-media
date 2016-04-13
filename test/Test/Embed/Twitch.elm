module Test.Media.Twitch (tests) where

import ElmTest exposing (..)
import Media exposing (MediaRef, Kind(..), Url)
import Media.Twitch as Twitch exposing (site)


sampleText : String
sampleText =
  """
  twitch.tv/dirtybomb
  https://www.livecap.tv/t/parmaviolet/uLKRSQoAaEQ
  http://oddshot.tv/shot/counterpit-2016031710238933
  https://www.twitch.tv/lightningzor/v/24318352
  """


results : List MediaRef
results =
  Media.find sampleText Twitch.siteId Twitch.matchers


expected : List MediaRef
expected =
  [ { siteId = Twitch.siteId
    , kind = Stream
    , mediaId = "lightningzor"
    }
  , { siteId = Twitch.siteId
    , kind = Stream
    , mediaId = "dirtybomb"
    }
  , { siteId = Twitch.siteId
    , kind = Stream
    , mediaId = "parmaviolet"
    }
  , { siteId = Twitch.siteId
    , kind = Stream
    , mediaId = "counterpit"
    }
  , { siteId = Twitch.siteId
    , kind = Video
    , mediaId = "24318352"
    }
  ]


urlTestCases : List ( MediaRef, Maybe (MediaRef -> Maybe Url), Maybe Url )
urlTestCases =
  let
    ref : MediaRef
    ref =
      { siteId = site.id
      , kind = Stream
      , mediaId = "test"
      }
  in
    [ ( ref
      , site.imgSmUrl
      , Just "https://static-cdn.jtvnw.net/previews-ttv/live_user_test_-80x45.jpg"
      )
    , ( ref
      , site.imgMdUrl
      , Just "https://static-cdn.jtvnw.net/previews-ttv/live_user_test_-320x180.jpg"
      )
    , ( ref
      , site.imgLgUrl
      , Just "https://static-cdn.jtvnw.net/previews-ttv/live_user_test_-640x360.jpg"
      )
    , ( { ref | siteId = "testing" }
      , site.imgSmUrl
      , Nothing
      )
    , ( { ref | kind = Video }
      , site.imgSmUrl
      , Nothing
      )
    , ( ref
      , site.iframeUrl
      , Just "https://player.twitch.tv/?channel=test"
      )
    , ( { ref | kind = Video }
      , site.iframeUrl
      , Just "https://player.twitch.tv/?video=test"
      )
    ]


generateUrlTest : ( MediaRef, Maybe (MediaRef -> Maybe Url), Maybe Url ) -> Test
generateUrlTest ( ref, maybeFn, expected ) =
  let
    result =
      case maybeFn of
        Just fn ->
          fn ref

        Nothing ->
          Nothing
  in
    test "url" (assertEqual expected result)


urlTests : Test
urlTests =
  urlTestCases
    |> List.map generateUrlTest
    |> suite "urls"


tests : Test
tests =
  suite
    "Twitch"
    [ test "results are as expected" (assertEqual expected results)
    , urlTests
    ]
