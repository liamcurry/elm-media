module Media.Site.Oddshot (id, site) where

import Media exposing (Kind(..), Media, Url, SiteId, Site)


id : SiteId
id =
  "oddshot"


url : Media -> Maybe Url
url media =
  case media.kind of
    Video ->
      Just ("https://oddshot.tv/shot/" ++ media.id)

    _ ->
      Nothing


iframeUrl : Media -> Maybe Url
iframeUrl media =
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
      [ ( Video, "" )
      ]
  , url = url
  , imgSmUrl = Nothing
  , imgMdUrl = Nothing
  , imgLgUrl = Nothing
  , iframeUrl = Just iframeUrl
  }
