module Main (..) where

import ElmTest exposing (..)
import Console
import Task
import Test.Media as Media
import String


tests : Test
tests =
  suite
    "elm-embed"
    [ Media.tests
    ]


port runner : Signal (Task.Task x ())
port runner =
  Console.run (consoleRunner tests)
