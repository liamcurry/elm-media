module Media.Model (MediaKind(..), MediaId, Media, Url, Urls, SiteId, Site, toUrls) where

import Regex exposing (Regex)


type MediaKind
  = Post
  | Reply
  | Stream
  | Video
  | Image
  | Album
  | Listing


type alias MediaId =
  String


type alias Media =
  { id : MediaId
  , kind : MediaKind
  , siteId : SiteId
  }


type alias Url =
  String


type alias SiteId =
  String


type alias Site =
  { id : SiteId
  , name : String
  , matchers : List ( MediaKind, Regex )
  , url : Media -> Maybe Url
  , imgSmUrl : Maybe (Media -> Maybe Url)
  , imgMdUrl : Maybe (Media -> Maybe Url)
  , imgLgUrl : Maybe (Media -> Maybe Url)
  , iframeUrl : Maybe (Media -> Maybe Url)
  }


type alias Urls =
  { media : Media
  , url : Maybe Url
  , imgSmUrl : Maybe Url
  , imgMdUrl : Maybe Url
  , imgLgUrl : Maybe Url
  , iframeUrl : Maybe Url
  }


toUrls : Site -> Media -> Urls
toUrls site media =
  let
    url =
      (\fn -> fn media)
  in
    { media = media
    , url = site.url media
    , imgSmUrl = Maybe.andThen site.imgSmUrl url
    , imgMdUrl = Maybe.andThen site.imgMdUrl url
    , imgLgUrl = Maybe.andThen site.imgLgUrl url
    , iframeUrl = Maybe.andThen site.iframeUrl url
    }
