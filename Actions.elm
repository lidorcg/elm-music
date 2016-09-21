module Actions exposing (..)

import State exposing (..)
import Logic.Search as Search


type Msg
    = SearchMsg Search.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
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
