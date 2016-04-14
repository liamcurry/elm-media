module Media.Site.YouTube (id, site) where

import Media exposing (Kind(..), Media, Url, SiteId, Site)


id : SiteId
id =
  "youtube"


imgUrl : String -> Media -> Maybe Url
imgUrl size media =
  case media.kind of
    Video ->
      Just ("https://img.youtube.com/vi/" ++ media.id ++ "/" ++ size ++ ".jpg")

    _ ->
      Nothing


url : Media -> Maybe Url
url media =
  case media.kind of
    Video ->
      Just ("https://www.youtube.com/watch?v=" ++ media.id)

    _ ->
      Nothing


iframeUrl : Media -> Maybe Url
iframeUrl media =
  case media.kind of
    Video ->
      Just ("https://www.youtube.com/embed/" ++ media.id)

    _ ->
      Nothing


matchers : List ( Kind, String )
matchers =
  [ ( Video, "(?:youtu\\.be\\/|youtube(?:-nocookie)?\\.com\\S*[^\\w\\s-])([\\w-]{11})(?=[^\\w-]|$)(?![?=&+%\\w.-]*(?:['\"][^<>]*>|<\\/a>))[?=&+%\\w.-]*" )
  ]


site : Site
site =
  { id = id
  , name = "YouTube"
  , matchers = matchers
  , url = url
  , imgSmUrl = Just (imgUrl "default")
  , imgMdUrl = Just (imgUrl "mqdefault")
  , imgLgUrl = Just (imgUrl "hqdefault")
  , iframeUrl = Just iframeUrl
  }
