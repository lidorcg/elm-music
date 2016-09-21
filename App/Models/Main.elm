module Models.Main exposing (Model, init)

import Models.Search as Search


-- MODEL


type alias Model =
    { searchState : Search.Model }


init =
    ( Model Search.init
    , Cmd.none
    )
