module Reducers.Playlists exposing (..)

import Actions.Main exposing (..)
import Utils.RemoteData exposing (..)
import GraphQL.Playlists exposing (allPlaylists, AllPlaylistsResult, createPlaylist, CreatePlaylistResult)
import Task exposing (perform, Task)
import Debug exposing (log)


-- MODEL


type alias Model =
    { allPlaylistsRequest : RemoteData AllPlaylistsResult
    , newPlaylistName : String
    , createPlaylistRequest : RemoteData CreatePlaylistResult
    }

emptyModel : Model
emptyModel =
  Model NotAsked "" NotAsked


init : ( Model, Cmd Msg )
init =
    let
        ( model, cmd ) =
            update FetchPlaylists emptyModel
    in
        ( model, cmd )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPlaylists ->
            ( { model | allPlaylistsRequest = Loading }
            , allPlaylists |> perform FetchPlaylistsFail FetchPlaylistsSucceed
            )

        FetchPlaylistsFail error ->
            ( { model | allPlaylistsRequest = Failure (log "error" error) }
            , Cmd.none
            )

        FetchPlaylistsSucceed result ->
            ( { model | allPlaylistsRequest = Success result }
            , Cmd.none
            )

        NewPlaylistFormInputName string ->
            ( { model | newPlaylistName = string }
            , Cmd.none
            )

        NewPlaylistFormSubmit ->
            ( { model | createPlaylistRequest = Loading }
            , createPlaylist { name = model.newPlaylistName }
                |> perform CreateNewPlaylistFail CreateNewPlaylistSucceed
            )

        CreateNewPlaylistFail error ->
            ( { model | createPlaylistRequest = Failure (log "error" error) }
            , Cmd.none
            )

        CreateNewPlaylistSucceed result ->
            ( { model | createPlaylistRequest = Success result }
            , allPlaylists |> perform FetchPlaylistsFail FetchPlaylistsSucceed
            )

        _ ->
            ( model, Cmd.none )
