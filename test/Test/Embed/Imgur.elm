module Test.Embed.Imgur (tests) where

import ElmTest exposing (..)
import Embed exposing (MediaRef, Kind(..), Url)
import Embed.Imgur as Imgur exposing (site)


sampleText : String
sampleText =
  """
  https://imgur.com/EU9H6vF
  https://i.imgur.com/aU9H6vF.png
  https://imgur.com/gallery/nrBo1
  https://imgur.com/a/nrBo2.jpg
  """


results : List MediaRef
results =
  Embed.find sampleText Imgur.siteId Imgur.matchers


expected : List MediaRef
expected =
  [ { siteId = Imgur.siteId
    , kind = Image
    , mediaId = "aU9H6vF"
    }
  , { siteId = Imgur.siteId
    , kind = Image
    , mediaId = "EU9H6vF"
    }
  , { siteId = Imgur.siteId
    , kind = Album
    , mediaId = "nrBo2"
    }
  , { siteId = Imgur.siteId
    , kind = Album
    , mediaId = "nrBo1"
    }
  ]


urlTestCases : List ( MediaRef, Maybe (MediaRef -> Maybe Url), Maybe Url )
urlTestCases =
  let
    ref : MediaRef
    ref =
      { siteId = site.id
      , kind = Image
      , mediaId = "test"
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
    , ( { ref | siteId = "testing" }
      , site.imgSmUrl
      , Nothing
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
    "Imgur"
    [ test "results are as expected" (assertEqual expected results)
    , urlTests
    ]
