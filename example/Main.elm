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
  """elm-media is a small Elm library for extracting social media URLs from text.

Some examples:

Imgur:

  https://imgur.com/cjCGCNH

YouTube:

  https://youtu.be/oYk8CKH7OhE
  https://www.youtube.com/watch?v=DfLvDFxcAIA

Other supported sites:

  Gfycat, Twitch, Livecap, Oddshot (more coming soon)

Pull-requests welcome!
"""


type Action
  = NoOp
  | ChangeText String


kindToString : MediaKind -> String
kindToString kind =
  case kind of
    Post ->
      "Post"

    Reply ->
      "Reply"

    Stream ->
      "Stream"

    Video ->
      "Video"

    Image ->
      "Image"

    Album ->
      "Album"

    Listing ->
      "Listing"


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
        , class "media-iframe"
        , width 560
        , height 315
        , attribute "frameborder" "0"
        , attribute "allowfullscreen" "true"
        ]
        []
    else if not (String.isEmpty imgUrl) then
      img
        [ src imgUrl
        , class "media-image"
        ]
        []
    else
      div
        [ class "media-none" ]
        [ text "no image url"
        , text urls.media.id
        , text urls.media.siteId
        ]


view : Signal.Address Action -> Model -> Html
view address model =
  let
    input =
      div
        [ class "input" ]
        [ textarea
            [ on "input" targetValue (Signal.message address << ChangeText)
            , autofocus True
            ]
            [ text model ]
        ]

    mediaView ( site, media, urls, html ) =
      div
        [ class "media" ]
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
                    [ text "ID: " ]
                , span
                    []
                    [ text media.id ]
                ]
            , li
                []
                [ strong
                    []
                    [ text "Kind: " ]
                , span
                    []
                    [ media.kind |> kindToString |> text ]
                ]
            ]
        , div
            [ class "media-embed" ]
            [ html
            , a
                [ urls.url |> Maybe.withDefault "" |> href ]
                [ urls.url |> Maybe.withDefault "" |> text ]
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
        [ class "output" ]
        [ div
            [ class "media-list" ]
            media
        ]
  in
    div
      [ class "container" ]
      [ header
          []
          [ h1 [] [ text "elm-media" ]
          , nav
              []
              [ a
                  [ href "http://package.elm-lang.org/packages/liamcurry/elm-media/" ]
                  [ text "Documentation" ]
              , a
                  [ href "https://github.com/liamcurry/elm-media" ]
                  [ text "Github" ]
              ]
          ]
      , div
          [ class "input-output" ]
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
