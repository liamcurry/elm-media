module Embed.Oddshot (id, site) where

import Embed.Common exposing (Kind(..), SiteId, Site, Media, Url)
import Regex exposing (regex)


id : SiteId
id =
  "oddshot"


url : Media -> Maybe Url
url media =
  if media.siteId /= id then
    Nothing
  else
    case media.kind of
      Video ->
        Just ("https://oddshot.tv/shot/" ++ media.id)

      _ ->
        Nothing


iframeUrl : Media -> Maybe Url
iframeUrl media =
  if media.siteId /= id then
    Nothing
  else
    case media.kind of
      Video ->
        Just ("https://oddshot.tv/shot/" ++ media.id ++ "/embed")

      _ ->
        Nothing


site : Site
site =
  { id = id
  , name = "Oddshot"
  , matchers =
      [ ( Video, regex "" )
      ]
  , url = url
  , imgSmUrl = Nothing
  , imgMdUrl = Nothing
  , imgLgUrl = Nothing
  , iframeUrl = Just iframeUrl
  }
