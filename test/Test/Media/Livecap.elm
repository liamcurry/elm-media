module Test.Media.Livecap (tests) where

import ElmTest exposing (..)
import Media exposing (Media, Kind(..), Site)
import Media.Site.Livecap as Livecap


sampleText : String
sampleText =
  """
  https://www.livecap.tv/t/parmaviolet/uLKRSQoAaEQ
  https://www.livecap.tv/t/domingo/ufdc9LXoezd
  livecap.tv/t/riotgames/uuOKs01Vsee
  livecap.tv/t/riotgames/
  """


results : List ( Site, Media )
results =
  Media.find [ Livecap.site ] sampleText


expected : List ( Site, Media )
expected =
  [ { siteId = Livecap.id
    , kind = Video
    , id = "parmaviolet/uLKRSQoAaEQ"
    }
  , { siteId = Livecap.id
    , kind = Video
    , id = "domingo/ufdc9LXoezd"
    }
  , { siteId = Livecap.id
    , kind = Video
    , id = "riotgames/uuOKs01Vsee"
    }
  ]
    |> List.map (\m -> ( Livecap.site, m ))


tests : Test
tests =
  suite
    "Livecap"
    [ test "results are as expected" (assertEqual expected results)
    ]
