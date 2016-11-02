module Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http

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
