module Utils.RemoteData exposing (..)

import Http exposing (Error)


type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


type alias WebData a =
    RemoteData Error a
