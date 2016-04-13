module Test.Embed.Gfycat (tests) where

import ElmTest exposing (..)
import Embed exposing (MediaRef, Kind(..))
import Embed.Gfycat as Gfycat


sampleText : String
sampleText =
  """
  https://gfycat.com/UnsungAncientBigmouthbass.gifv
  asdf
  https://oddshot.tv/shot/testing/123
  """


results : List MediaRef
results =
  Embed.find sampleText Gfycat.siteId Gfycat.matchers


expected : List MediaRef
expected =
  [ { siteId = Gfycat.siteId
    , kind = Image
    , mediaId = "UnsungAncientBigmouthbass"
    }
  ]


tests : Test
tests =
  suite
    "Gfycat"
    [ test "results are as expected" (assertEqual expected results)
    ]
