module Embed.Gfycat (id, site, matchers) where

import Embed.Common exposing (Kind(..), MediaId, SiteId, Site, Media, Url)
import Regex exposing (Regex, regex)


id : SiteId
id =
  "gfycat"


imgUrl : String -> Media -> Maybe Url
imgUrl size media =
  if media.siteId /= id then
    Nothing
  else
    case media.kind of
      Image ->
        Just ("https://" ++ size ++ ".gfycat.com/" ++ media.id ++ ".webm")

      _ ->
        Nothing


url : Media -> Maybe Url
url media =
  if media.siteId /= id then
    Nothing
  else
    case media.kind of
      Image ->
        Just ("https://gfycat.com/" ++ media.id)

      _ ->
        Nothing


matchers : List ( Kind, Regex )
matchers =
  [ ( Image, regex "(?:gfycat.com\\/)(\\w+)" )
  ]


site : Site
site =
  { id = id
  , name = "Gfycat"
  , matchers = matchers
  , url = url
  , imgSmUrl = Just (imgUrl "zippy")
  , imgMdUrl = Just (imgUrl "fat")
  , imgLgUrl = Just (imgUrl "giant")
  , iframeUrl = Just (imgUrl "fat")
  }
