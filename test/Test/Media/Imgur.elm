module Test.Media.Imgur (tests) where

import ElmTest exposing (..)
import Media exposing (Media, Kind(..), Url, Site)
import Media.Site.Imgur as Imgur exposing (site)


sampleText : String
sampleText =
  """
  https://imgur.com/EU9H6vF
  https://i.imgur.com/aU9H6vF.png
  https://imgur.com/gallery/nrBo1
  https://imgur.com/a/nrBo2.jpg
  """


results : List ( Site, Media )
results =
  Media.find [ Imgur.site ] sampleText


expected : List ( Site, Media )
expected =
  [ { siteId = Imgur.id
    , kind = Image
    , id = "EU9H6vF"
    }
  , { siteId = Imgur.id
    , kind = Image
    , id = "aU9H6vF"
    }
  , { siteId = Imgur.id
    , kind = Album
    , id = "nrBo1"
    }
  , { siteId = Imgur.id
    , kind = Album
    , id = "nrBo2"
    }
  ]
    |> List.map (\m -> ( Imgur.site, m ))


urlTestCases : List ( Media, Maybe (Media -> Maybe Url), Maybe Url )
urlTestCases =
  let
    ref : Media
    ref =
      { siteId = site.id
      , kind = Image
      , id = "test"
      }
  in
    [ ( ref
      , site.imgSmUrl
      , Just "https://i.imgur.com/testt.jpg"
      )
    , ( ref
      , site.imgMdUrl
      , Just "https://i.imgur.com/testm.jpg"
      )
    , ( ref
      , site.imgLgUrl
      , Just "https://i.imgur.com/testl.jpg"
      )
    , ( { ref | kind = Album }
      , site.imgSmUrl
      , Nothing
      )
    , ( ref
      , site.iframeUrl
      , Nothing
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
    "Imgur"
    [ test "results are as expected" (assertEqual expected results)
    , urlTests
    ]
