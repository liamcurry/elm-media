module Media (Kind(..), Id, Media, Url, SiteId, Site, Urls, toUrls, find, urls) where

{-| A library for finding and embedding social media links.

@docs find, urls

-}

import Regex exposing (Regex, Match, regex)


type Kind
  = Post
  | Reply
  | Stream
  | Video
  | Image
  | Album
  | Listing


type alias Id =
  String


type alias Media =
  { id : Id
  , kind : Kind
  , siteId : SiteId
  }


type alias Url =
  String


type alias SiteId =
  String


type alias Site =
  { id : SiteId
  , name : String
  , matchers : List ( Kind, String )
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


justValues : List (Maybe a) -> List a
justValues list =
  let
    buildResults maybe result =
      case maybe of
        Just value ->
          value :: result

        Nothing ->
          result
  in
    List.foldr buildResults [] list


match : String -> Site -> ( Kind, String ) -> List ( Site, Media )
match input site ( kind, reStr ) =
  input
    |> Regex.find Regex.All (regex reStr)
    |> List.map (\match -> List.head match.submatches)
    |> justValues
    |> justValues
    |> List.map (\mediaId -> ( site, { siteId = site.id, kind = kind, id = mediaId } ))


{-| Find media links from input text based on a list of available sites.
-}
find : List Site -> String -> List ( Site, Media )
find sites input =
  let
    matches site =
      site.matchers
        |> List.map (match input site)
        |> List.concat
  in
    sites
      |> List.map matches
      |> List.concat


{-| Generate URLs for given media.
-}
urls : List ( Site, Media ) -> List ( Site, Media, Urls )
urls results =
  results
    |> List.map (\( site, media ) -> ( site, media, toUrls site media ))
