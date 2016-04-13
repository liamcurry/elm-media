module Embed (..) where

import Embed.Common exposing (..)
import Embed.Gfycat as Gfycat
import Embed.Imgur as Imgur
import Embed.Livecap as Livecap
import Embed.Oddshot as Oddshot
import Embed.Twitch as Twitch
import Embed.YouTube as YouTube
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode exposing (string)
import Regex exposing (Regex, Match, regex)


mediaIdFromMatch : Match -> Maybe MediaId
mediaIdFromMatch match =
  let
    sub =
      List.head match.submatches
  in
    case sub of
      Just maybeMediaId ->
        maybeMediaId

      Nothing ->
        Nothing


buildMatchRefs : Maybe MediaId -> List MediaId -> List MediaId
buildMatchRefs maybeMediaId result =
  case maybeMediaId of
    Just mediaId ->
      mediaId :: result

    Nothing ->
      result


match : String -> SiteId -> ( Kind, Regex ) -> List Media
match input siteId ( kind, re ) =
  input
    |> Regex.find Regex.All re
    |> List.map mediaIdFromMatch
    |> List.foldl buildMatchRefs []
    |> List.map (\mediaId -> { siteId = siteId, kind = kind, id = mediaId })


defaultSites : List Site
defaultSites =
  [ Gfycat.site
  , Imgur.site
  , Livecap.site
  , Oddshot.site
  , Twitch.site
  , YouTube.site
  ]


find : String -> List Media
find input =
  findWithSites input defaultSites


findWithSites : String -> List Site -> List Media
findWithSites input sites =
  sites
    |> List.map (findWithSite input)
    |> List.concat


findWithSite : String -> Site -> List Media
findWithSite input site =
  site.matchers
    |> List.map (match input site.id)
    |> List.concat


withoutNothing : Maybe a -> List a -> List a
withoutNothing maybe result =
  case maybe of
    Just thing ->
      thing :: result

    Nothing ->
      result


html : List Media -> List Html
html media =
  media
    |> List.map ((flip htmlWithSites) defaultSites)
    |> List.foldl withoutNothing []


htmlWithSites : Media -> List Site -> Maybe Html
htmlWithSites media sites =
  sites
    |> List.filter (\site -> site.id == media.siteId)
    |> List.map (htmlWithSite media)
    |> Maybe.oneOf


htmlWithSite : Media -> Site -> Maybe Html
htmlWithSite media site =
  let
    maybeIframeUrl =
      case site.iframeUrl of
        Just iframeUrl ->
          iframeUrl media

        Nothing ->
          Nothing

    maybeImgUrlFn =
      Maybe.oneOf
        [ site.imgLgUrl
        , site.imgMdUrl
        , site.imgSmUrl
        ]

    maybeImgUrl =
      case maybeImgUrlFn of
        Just imgUrlFn ->
          imgUrlFn media

        Nothing ->
          Nothing
  in
    if site.id /= media.siteId then
      Nothing
    else
      case maybeIframeUrl of
        Just url ->
          Just
            (iframe
              [ src url
              , attribute "frameborder" "0"
              , attribute "allowfullscreen" "true"
              ]
              []
            )

        Nothing ->
          case maybeImgUrl of
            Just imgUrl ->
              Just
                (img
                  [ src imgUrl ]
                  []
                )

            Nothing ->
              Just
                (div
                  []
                  [ text "no image url"
                  , text media.id
                  , text media.siteId
                  ]
                )
