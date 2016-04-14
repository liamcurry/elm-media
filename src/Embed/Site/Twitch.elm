module Embed.Site.Twitch (id, site, matchers) where

import Embed.Model exposing (..)
import Regex exposing (Regex, regex)


id : SiteId
id =
  "twitch"


imgUrl : String -> Media -> Maybe Url
imgUrl size media =
  case media.kind of
    Stream ->
      Just ("https://static-cdn.jtvnw.net/previews-ttv/live_user_" ++ media.id ++ "_-" ++ size ++ ".jpg")

    Video ->
      -- TODO
      Nothing

    _ ->
      Nothing


url : Media -> Maybe Url
url media =
  case media.kind of
    Stream ->
      Just ("https://www.twitch.tv/" ++ media.id)

    Video ->
      -- TODO
      Nothing

    _ ->
      Nothing


iframeUrl : Media -> Maybe Url
iframeUrl media =
  case media.kind of
    Stream ->
      Just ("https://player.twitch.tv/?channel=" ++ media.id)

    Video ->
      Just ("https://player.twitch.tv/?video=" ++ media.id)

    _ ->
      Nothing


matchers : List ( MediaKind, Regex )
matchers =
  [ ( Stream, regex "(?:twitch.tv\\/)([\\w_]+)" )
  , ( Stream, regex "(?:livecap.tv\\/t\\/)([\\w_]+)" )
  , ( Stream, regex "(?:oddshot.tv\\/shot\\/)([\\w_]+)" )
    -- TODO: saving links to specific times
  , ( Video, regex "(?:twitch.tv\\/[\\w_]+\\/v\\/)(\\d+)" )
  ]


site : Site
site =
  { id = id
  , name = "Twitch"
  , matchers = matchers
  , url = url
  , imgSmUrl = Just (imgUrl "80x45")
  , imgMdUrl = Just (imgUrl "320x180")
  , imgLgUrl = Just (imgUrl "640x360")
  , iframeUrl = Just iframeUrl
  }
