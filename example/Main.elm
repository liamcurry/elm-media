module Main (..) where

import Media
import Media.Model exposing (..)
import Media.Site as Site
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import String


type alias Model =
  String


emptyModel : Model
emptyModel =
  """Imgur:
https://imgur.com/cjCGCNH

YouTube:
https://www.youtube.com/watch?v=oYk8CKH7OhE
https://www.youtube.com/watch?v=DfLvDFxcAIA

Other supported sites:
Gfycat, Twitch, Livecap, Oddshot
"""


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


{-| Create HTML for media.
-}
html : List ( Site, Media, Urls ) -> List ( Site, Media, Urls, Html )
html results =
  results
    |> List.map (\( site, media, urls ) -> ( site, media, urls, toHtml urls ))


toHtml : Urls -> Html
toHtml urls =
  let
    imgUrl =
      [ urls.imgSmUrl
      , urls.imgMdUrl
      , urls.imgLgUrl
      ]
        |> Maybe.oneOf
        |> Maybe.withDefault ""

    iframeUrl =
      Maybe.withDefault "" urls.iframeUrl
  in
    if not (String.isEmpty iframeUrl) then
      iframe
        [ src iframeUrl
        , attribute "frameborder" "0"
        , attribute "allowfullscreen" "true"
        ]
        []
    else if not (String.isEmpty imgUrl) then
      img
        [ src imgUrl
        ]
        []
    else
      div
        []
        [ text "no image url"
        , text urls.media.id
        , text urls.media.siteId
        ]


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

    mediaView ( site, media, urls, html ) =
      div
        []
        [ p
            []
            [ ul
                []
                [ li
                    []
                    [ strong
                        []
                        [ text "Site: " ]
                    , span
                        []
                        [ text site.name ]
                    ]
                , li
                    []
                    [ strong
                        []
                        [ text "Media ID: " ]
                    , span
                        []
                        [ text media.id ]
                    ]
                , li
                    []
                    [ strong
                        []
                        [ text "URL: " ]
                    , span
                        []
                        [ a
                            [ urls.url |> Maybe.withDefault "" |> href ]
                            [ urls.url |> Maybe.withDefault "" |> text ]
                        ]
                    ]
                ]
            , html
            , hr [] []
            ]
        ]

    media =
      model
        |> Media.find Site.all
        |> Media.urls
        |> html
        |> List.map mediaView

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
          , media
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
      [ h1 [] [ text "elm-media" ]
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
