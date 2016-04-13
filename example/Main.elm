module Main (..) where

import Embed
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp


type alias Model =
  String


emptyModel : Model
emptyModel =
  """https://imgur.com/cjCGCNH
https://www.youtube.com/watch?v=oYk8CKH7Ohj
https://www.youtube.com/watch?v=DfLvDFxcAIA"""


type Action
  = NoOp
  | ChangeText String


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    ChangeText text ->
      text


view : Signal.Address Action -> Model -> Html
view address model =
  let
    input =
      div
        [ (style
            [ ( "flex", "1" )
            , ( "padding", "10px" )
            ]
          )
        ]
        [ h2
            []
            [ text "Input" ]
        , textarea
            [ (style
                [ ( "flex", "1" )
                , ( "padding", "10px" )
                ]
              )
            , on "input" targetValue (Signal.message address << ChangeText)
            ]
            [ text model ]
        ]

    media =
      Embed.find model

    output =
      div
        [ (style
            [ ( "flex", "1" )
            , ( "padding", "10px" )
            ]
          )
        ]
        (List.concat
          [ [ h2
                []
                [ text ("Output (matches: " ++ (toString (List.length media)) ++ ")") ]
            ]
          , Embed.html media
          ]
        )
  in
    div
      [ style
          [ ( "display", "flex" )
          , ( "flex-direction", "column" )
          , ( "padding", "10px" )
          ]
      ]
      [ h1 [] [ text "elm-embed" ]
      , div
          [ style
              [ ( "flex", "1" )
              , ( "display", "flex" )
              ]
          ]
          [ input
          , output
          ]
      ]


main : Signal Html
main =
  StartApp.start
    { model = emptyModel
    , view = view
    , update = update
    }
