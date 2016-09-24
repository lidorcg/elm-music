module State.Main exposing (..)

import State.Search as Search


-- MODEL


type alias State =
    { searchState : Search.State }


init =
    ( State Search.init
    , Cmd.none
    )



-- UPDATE


type Msg
    = SearchMsg Search.Msg


update : Msg -> State -> ( State, Cmd Msg )
update msg model =
    case msg of
        SearchMsg searchMsg ->
            let
                ( updatedSearchModel, searchCmd ) =
                    Search.update searchMsg model.searchState
            in
                ( { model | searchState = updatedSearchModel }
                , Cmd.map SearchMsg searchCmd
                )
