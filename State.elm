module State exposing (..)

import Logic.Search as Search


type alias Model =
    { searchState : Search.Model }


init =
    ( Model Search.init
    , Cmd.none
    )
