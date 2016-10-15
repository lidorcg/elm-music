module Utils.RemoteData exposing (..)

import Http exposing (Error)


type RemoteData a
    = NotAsked
    | Loading
    | Failure Http.Error
    | Success a
