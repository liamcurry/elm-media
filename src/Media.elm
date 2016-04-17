module Media (Kind(..), Id, Media, SiteId, Site, Url, Urls, find, urls) where

{-| This package is for extracting social media references from text. The
most common use-case for this package is to embed social media widgets on
a webpage from user input.

Basic example:

    import Media
    import Media.Site as Site

    text = """https://imgur.com/cjCGCNH
    https://youtu.be/oYk8CKH7OhE
    https://www.youtube.com/watch?v=DfLvDFxcAIA
    """

    -- Find all the media references in some text
    media = Media.find Site.all text

    -- Generate URLs for media objects
    urls = Media.urls media

# Types
@docs Kind, Id, Media, SiteId, Site, Url, Urls

# Extracting media
@docs find, urls

-}

import Regex exposing (Regex, Match, regex)


{-| Represents the general type of media.
-}
type Kind
  = Post
  | Reply
  | Stream
  | Video
  | Image
  | Album
  | Listing


{-| Unique site-specific identifier for media.
-}
type alias Id =
  String


{-| A slim reference to media on a site.
-}
type alias Media =
  { id : Id
  , kind : Kind
  , siteId : SiteId
  }


{-| A basic representation of a URL.
-}
type alias Url =
  String


{-| Unique identifier for a site.
-}
type alias SiteId =
  String


{-| Represents a site.
-}
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


{-| Represents all possible URLs for a given media object and site.
-}
type alias Urls =
  { media : Media
  , url : Maybe Url
  , imgSmUrl : Maybe Url
  , imgMdUrl : Maybe Url
  , imgLgUrl : Maybe Url
  , iframeUrl : Maybe Url
  }


{-| Generates URLs for a media object based on a site.
-}
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
