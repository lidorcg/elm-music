module Reducers.State.Modal exposing (..)

import Actions.Main exposing (..)
import Utils.SendMsg exposing (sendMsg)


-- MODEL


type alias Model =
    { display : Display
    , newPlaylistFrom : NewPlaylistFormModel
    }


type Display
    = NewPlaylistForm
    | None


type alias NewPlaylistFormModel =
    { name : String
    , status : String
    }


init : Model
init =
    let
        emptyNewPlaylistFrom =
            NewPlaylistFormModel "" ""
    in
        Model None emptyNewPlaylistFrom



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayNewPlaylistModal ->
            ( { model | display = NewPlaylistForm }
            , Cmd.none
            )

        CloseNewPlaylistModal ->
            ( { model | display = None }
            , Cmd.none
            )

        NewPlaylistFormInputName name ->
            let
                newPlaylistFrom =
                    NewPlaylistFormModel name model.newPlaylistFrom.status
            in
                ( { model | newPlaylistFrom = newPlaylistFrom }
                , Cmd.none
                )

        NewPlaylistFormSubmit ->
            ( { model | display = None }
            , sendMsg (CreateNewPlaylistRequest model.newPlaylistFrom.name)
            )

        _ ->
            ( model, Cmd.none )
