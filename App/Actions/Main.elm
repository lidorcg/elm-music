module Actions.Main exposing (..)

import Actions.Search as Search
import Models.Main as Main


-- UPDATE


type Msg
    = SearchMsg Search.Msg


update : Msg -> Main.State -> ( Main.State, Cmd Msg )
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
