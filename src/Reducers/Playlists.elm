module Reducers.Playlists exposing (..)

import Actions.Main exposing (..)
import Utils.RemoteData exposing (..)
import GraphQL.Music exposing (playlists, PlaylistsResult)
import Task exposing (perform, Task)
import Debug exposing (log)


-- MODEL


type alias Model =
    RemoteData PlaylistsResult


init : ( Model, Cmd Msg )
init =
    let
        ( model, cmd ) =
            update FetchPlaylistsData NotAsked
    in
        ( model, cmd )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPlaylistsData ->
            ( Loading
            , playlists |> perform FetchPlaylistsFail FetchPlaylistsSucceed
            )

        FetchPlaylistsFail error ->
            ( Failure (log "error" error)
            , Cmd.none
            )

        FetchPlaylistsSucceed result ->
            ( Success result
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
