module Test.Media.Twitch (tests) where

import ElmTest exposing (..)
import Media exposing (Media, Kind(..), Url, Site)
import Media.Site.Twitch as Twitch exposing (site)


sampleText : String
sampleText =
  """
  twitch.tv/dirtybomb
  https://www.twitch.tv/lightningzor/v/24318352
  """


results : List ( Site, Media )
results =
  Media.find [ Twitch.site ] sampleText


expected : List ( Site, Media )
expected =
  [ { siteId = Twitch.id
    , kind = Stream
    , id = "dirtybomb"
    }
  , { siteId = Twitch.id
    , kind = Stream
    , id = "lightningzor"
    }
  , { siteId = Twitch.id
    , kind = Video
    , id = "24318352"
    }
  ]
    |> List.map (\m -> ( Twitch.site, m ))


urlTestCases : List ( Media, Maybe (Media -> Maybe Url), Maybe Url )
urlTestCases =
  let
    ref : Media
    ref =
      { siteId = site.id
      , kind = Stream
      , id = "test"
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


generateUrlTest : ( Media, Maybe (Media -> Maybe Url), Maybe Url ) -> Test
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
