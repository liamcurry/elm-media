module Embed (find, urls, html) where

import Html exposing (..)
import Html.Attributes exposing (src, attribute)
import Regex exposing (Regex, Match, regex)
import String
import Embed.Model exposing (..)


{-| A library for finding and embedding social media links.

# Finding media
@docs find

# Building URLs
@docs urls

# Embedding media
@docs html

-}
justValues : List (Maybe a) -> List a
justValues list =
  let
    buildResults maybe result =
      case maybe of
        Just value ->
          value :: result

        Nothing ->
          result
  in
    List.foldr buildResults [] list


match : String -> Site -> ( MediaKind, Regex ) -> List ( Site, Media )
match input site ( kind, re ) =
  input
    |> Regex.find Regex.All re
    |> List.map (\match -> List.head match.submatches)
    |> justValues
    |> justValues
    |> List.map (\mediaId -> ( site, { siteId = site.id, kind = kind, id = mediaId } ))


find : List Site -> String -> List ( Site, Media )
find sites input =
  let
    matches site =
      site.matchers
        |> List.map (match input site)
        |> List.concat
  in
    sites
      |> List.map matches
      |> List.concat


urls : List ( Site, Media ) -> List Urls
urls results =
  results
    |> List.map (\( site, media ) -> toUrls site media)


html : List Urls -> List Html
html urls =
  List.map toHtml urls


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
        [ src imgUrl ]
        []
    else
      div
        []
        [ text "no image url"
        , text urls.media.id
        , text urls.media.siteId
        ]
