module Media.Site.Livecap (id, site) where

import Media exposing (Kind(..), Media, Url, SiteId, Site)


id : SiteId
id =
  "livecap"


url : Media -> Maybe Url
url media =
  case media.kind of
    Video ->
      Just ("https://www.livecap.tv/t/" ++ media.id)

    _ ->
      Nothing


iframeUrl : Media -> Maybe Url
iframeUrl media =
  case media.kind of
    Video ->
      Just ("https://www.livecap.tv/s/embed/" ++ media.id)

    _ ->
      Nothing


matchers : List ( Kind, String )
matchers =
  [ ( Video, "livecap.tv\\/t\\/([\\w_-]+\\/[\\w_-]+)" )
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
