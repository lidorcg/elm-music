module Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (field, Decoder)


script : String -> Html msg
script url =
    node "script"
        [ src url
        ]
        []


stylesheet : String -> Html msg
stylesheet url =
    node "link"
        [ rel "stylesheet"
        , href url
        ]
        []


type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


type alias WebData a =
    RemoteData Http.Error a


(:=) : String -> Decoder a -> Decoder a
(:=) name decoder =
    field name decoder

timeToString : Int -> String
timeToString ms =
    let
        s = ms // 1000

        minutes =
            s // 60

        seconds =
            rem s 60

        zeroPadding =
            if seconds < 10 then
                "0"
            else
                ""
    in
        toString minutes ++ ":" ++ zeroPadding ++ toString seconds
