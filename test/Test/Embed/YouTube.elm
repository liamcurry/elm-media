module Test.Media.YouTube (..) where

import ElmTest exposing (..)
import Media exposing (MediaRef, Kind(..))
import Media.YouTube as YouTube


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


results : List MediaRef
results =
  Media.find sampleText YouTube.siteId YouTube.matchers


expected : List MediaRef
expected =
  [ { siteId = YouTube.siteId
    , kind = Video
    , mediaId = "t-ZRX8984sc"
    }
  , { siteId = YouTube.siteId
    , kind = Video
    , mediaId = "t-ZRX8984sc"
    }
  , { siteId = YouTube.siteId
    , kind = Video
    , mediaId = "r5nB9u4jjy4"
    }
  , { siteId = YouTube.siteId
    , kind = Video
    , mediaId = "n17B_uFF4cA"
    }
  , { siteId = YouTube.siteId
    , kind = Video
    , mediaId = "iwGFalTRHDA"
    }
  , { siteId = YouTube.siteId
    , kind = Video
    , mediaId = "iwGFalTRHDA"
    }
  , { siteId = YouTube.siteId
    , kind = Video
    , mediaId = "iwGFalTRHDA"
    }
  ]


tests : Test
tests =
  suite
    "YouTube"
    [ test "results are as expected" (assertEqual expected results)
    ]
