module Models.Main exposing (State, init)

import Models.Search as Search


-- MODEL


type alias State =
    { searchState : Search.State }


init =
    ( State Search.init
    , Cmd.none
    )
