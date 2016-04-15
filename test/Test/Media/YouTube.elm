module Test.Media.YouTube (..) where

import ElmTest exposing (..)
import Media exposing (Media, Kind(..), Site)
import Media.Site.YouTube as YouTube


sampleText : String
sampleText =
  """
  http://www.youtube.com/watch?v=iwGFalTRHDA
  http://www.youtube.com/watch?v=iwGFalTRHDA&feature=related
  http://youtu.be/iwGFalTRHDA
  http://youtu.be/n17B_uFF4cA
  http://www.youtube.com/embed/watch?feature=player_embedded&v=r5nB9u4jjy4
  http://www.youtube.com/watch?v=t-ZRX8984sc
  http://youtu.be/t-ZRX8984sc
  """


results : List ( Site, Media )
results =
  Media.find [ YouTube.site ] sampleText


expected : List ( Site, Media )
expected =
  [ { siteId = YouTube.id
    , kind = Video
    , id = "t-ZRX8984sc"
    }
  , { siteId = YouTube.id
    , kind = Video
    , id = "t-ZRX8984sc"
    }
  , { siteId = YouTube.id
    , kind = Video
    , id = "r5nB9u4jjy4"
    }
  , { siteId = YouTube.id
    , kind = Video
    , id = "n17B_uFF4cA"
    }
  , { siteId = YouTube.id
    , kind = Video
    , id = "iwGFalTRHDA"
    }
  , { siteId = YouTube.id
    , kind = Video
    , id = "iwGFalTRHDA"
    }
  , { siteId = YouTube.id
    , kind = Video
    , id = "iwGFalTRHDA"
    }
  ]
    |> List.map (\m -> ( YouTube.site, m ))


tests : Test
tests =
  suite
    "YouTube"
    [ test "results are as expected" (assertEqual expected results)
    ]
