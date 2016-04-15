module Test.Media.Gfycat (tests) where

import ElmTest exposing (..)
import Media exposing (Media, Kind(..), Site)
import Media.Site.Gfycat as Gfycat


sampleText : String
sampleText =
  """
  https://gfycat.com/UnsungAncientBigmouthbass.gifv
  asdf
  https://oddshot.tv/shot/testing/123
  """


results : List ( Site, Media )
results =
  Media.find [ Gfycat.site ] sampleText


expected : List ( Site, Media )
expected =
  [ { siteId = Gfycat.id
    , kind = Image
    , id = "UnsungAncientBigmouthbass"
    }
  ]
    |> List.map (\m -> ( Gfycat.site, m ))


tests : Test
tests =
  suite
    "Gfycat"
    [ test "results are as expected" (assertEqual expected results)
    ]
