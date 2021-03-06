module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)


type Route
    = MainRoute String
    | SessionRoute String String
    | NotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ format MainRoute (string </> (s ""))
        , format SessionRoute (string </> string)
        ]


hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.href
        |> String.split "/"
        |> List.reverse
        |> List.take 2
        |> List.reverse
        |> String.join "/"
        |> parse identity matchers

parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route

routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            NotFound
