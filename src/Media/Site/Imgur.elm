module Media.Site.Imgur (id, site) where

import Media exposing (Kind(..), Media, Url, SiteId, Site)


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


matchers : List ( Kind, String )
matchers =
  [ ( Image, "imgur.com/(?!gallery\\/|a\\/)(\\w+)" )
  , ( Album, "imgur.com/(?:gallery\\/|a\\/)(\\w+)" )
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
