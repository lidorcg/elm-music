module Updates.Commons exposing (update)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Debug exposing (log)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HideForm ->
            ( { model | displayForm = DisplayNoForm }
            , Cmd.none
            )

        DoNothing ->
            ( model
            , Cmd.none
            )

        FocusFail err ->
            let
                error =
                    log "error" err
            in
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
