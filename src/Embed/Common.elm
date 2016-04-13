module Embed.Common (..) where

import Regex exposing (Regex)


type alias Url =
  String


type alias SiteId =
  String


type alias MediaId =
  String


type Kind
  = Post
  | Reply
  | Stream
  | Video
  | Image
  | Album
  | Listing


type alias Media =
  { id : MediaId
  , kind : Kind
  , siteId : SiteId
  }


type alias Site =
  { id : SiteId
  , name : String
  , matchers : List ( Kind, Regex )
  , url : Media -> Maybe Url
  , imgSmUrl : Maybe (Media -> Maybe Url)
  , imgMdUrl : Maybe (Media -> Maybe Url)
  , imgLgUrl : Maybe (Media -> Maybe Url)
  , iframeUrl : Maybe (Media -> Maybe Url)
  }
