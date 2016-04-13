module Test.Media.Livecap (tests) where

import ElmTest exposing (..)
import Media exposing (MediaRef, Kind(..))
import Media.Livecap as Livecap


sampleText : String
sampleText =
  """
  https://www.livecap.tv/t/parmaviolet/uLKRSQoAaEQ
  https://www.livecap.tv/t/domingo/ufdc9LXoezd
  livecap.tv/t/riotgames/uuOKs01Vsee
  livecap.tv/t/riotgames/
  """


results : List MediaRef
results =
  Media.find sampleText Livecap.siteId Livecap.matchers


expected : List MediaRef
expected =
  [ { siteId = Livecap.siteId
    , kind = Video
    , mediaId = "riotgames/uuOKs01Vsee"
    }
  , { siteId = Livecap.siteId
    , kind = Video
    , mediaId = "domingo/ufdc9LXoezd"
    }
  , { siteId = Livecap.siteId
    , kind = Video
    , mediaId = "parmaviolet/uLKRSQoAaEQ"
    }
  ]


tests : Test
tests =
  suite
    "Livecap"
    [ test "results are as expected" (assertEqual expected results)
    ]
