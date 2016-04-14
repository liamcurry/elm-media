module Media (find, urls) where

{-| A library for finding and embedding social media links.

@docs find, urls

-}

import Regex exposing (Regex, Match, regex)
import Media.Model exposing (..)


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


match : String -> Site -> ( MediaKind, Regex ) -> List ( Site, Media )
match input site ( kind, re ) =
  input
    |> Regex.find Regex.All re
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
