module Embed.Livecap (id, site, matchers) where

import Embed.Common exposing (Kind(..), SiteId, Site, Media, Url)
import Regex exposing (Regex, regex)


id : SiteId
id =
  "livecap"


url : Media -> Maybe Url
url media =
  if media.siteId /= id then
    Nothing
  else
    case media.kind of
      Video ->
        Just ("https://www.livecap.tv/t/" ++ media.id)

      _ ->
        Nothing


iframeUrl : Media -> Maybe Url
iframeUrl media =
  if media.siteId /= id then
    Nothing
  else
    case media.kind of
      Video ->
        Just ("https://www.livecap.tv/s/embed/" ++ media.id)

      _ ->
        Nothing


matchers : List ( Kind, Regex )
matchers =
  [ ( Video, regex "livecap.tv\\/t\\/([\\w_-]+\\/[\\w_-]+)" )
  ]


site : Site
site =
  { id = id
  , name = "Livecap"
  , matchers = matchers
  , url = url
  , imgSmUrl = Nothing
  , imgMdUrl = Nothing
  , imgLgUrl = Nothing
  , iframeUrl = Just iframeUrl
  }
