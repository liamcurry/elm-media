module Media.Site.Gfycat (id, site, matchers) where

import Media.Model exposing (..)
import Regex exposing (Regex, regex)


id : SiteId
id =
  "gfycat"


imgUrl : String -> Media -> Maybe Url
imgUrl size media =
  case media.kind of
    Image ->
      Just ("https://" ++ size ++ ".gfycat.com/" ++ media.id ++ ".webm")

    _ ->
      Nothing


url : Media -> Maybe Url
url media =
  case media.kind of
    Image ->
      Just ("https://gfycat.com/" ++ media.id)

    _ ->
      Nothing


matchers : List ( MediaKind, Regex )
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
