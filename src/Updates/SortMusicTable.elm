module Updates.SortMusicTable exposing (update)

import State exposing (Model)
import Actions exposing (..)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
