module Embed.Site.Imgur (id, site, matchers) where

import Embed.Model exposing (..)
import Regex exposing (Regex, regex)


id : SiteId
id =
  "imgur"


imgUrl : String -> Media -> Maybe Url
imgUrl size media =
  case media.kind of
    Image ->
      Just ("https://i.imgur.com/" ++ media.id ++ size ++ ".jpg")

    Album ->
      Nothing

    _ ->
      Nothing


imgSmUrl : Media -> Maybe Url
imgSmUrl =
  imgUrl "t"


imgMdUrl : Media -> Maybe Url
imgMdUrl =
  imgUrl "m"


imgLgUrl : Media -> Maybe Url
imgLgUrl =
  imgUrl "l"


url : Media -> Maybe Url
url media =
  case media.kind of
    Image ->
      Just ("https://imgur.com/" ++ media.id)

    Album ->
      Just ("https://imgur.com/gallery/" ++ media.id)

    _ ->
      Nothing


matchers : List ( MediaKind, Regex )
matchers =
  [ ( Image, regex "imgur.com/(?!gallery\\/|a\\/)(\\w+)" )
  , ( Album, regex "imgur.com/(?:gallery\\/|a\\/)(\\w+)" )
  ]


site : Site
site =
  { id = id
  , name = "Imgur"
  , matchers = matchers
  , url = url
  , imgSmUrl = Just imgSmUrl
  , imgMdUrl = Just imgMdUrl
  , imgLgUrl = Just imgLgUrl
  , iframeUrl = Nothing
  }
