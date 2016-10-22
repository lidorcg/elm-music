module Reducers.Data.CreateNewPlaylist exposing (..)

import Actions.Main exposing (..)
import Utils.RemoteData exposing (..)
import Utils.SendMsg exposing (sendMsg)
import GraphQL.Playlists exposing (CreatePlaylistResult, createPlaylist)
import Task exposing (perform, Task)
import Debug exposing (log)


-- MODEL


type alias Model =
    RemoteData CreatePlaylistResult


init : Model
init =
    NotAsked



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CreateNewPlaylistRequest name ->
            ( Loading
            , createPlaylist { name = name }
                |> perform CreateNewPlaylistRequestError CreateNewPlaylistRequestOk
            )

        CreateNewPlaylistRequestError error ->
            ( Failure (log "error" error)
            , sendMsg GetPlaylistsRequest
            )

        CreateNewPlaylistRequestOk result ->
            ( Success result
            , sendMsg GetPlaylistsRequest
            )

        _ ->
            ( model, Cmd.none )
