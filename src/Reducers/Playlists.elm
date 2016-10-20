module Reducers.Playlists exposing (..)

import Actions.Main exposing (..)
import Utils.RemoteData exposing (..)
import GraphQL.Playlists exposing (allPlaylists, AllPlaylistsResult)
import Task exposing (perform, Task)
import Debug exposing (log)


-- MODEL


type alias Model =
    RemoteData AllPlaylistsResult


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
            , allPlaylists |> perform FetchPlaylistsFail FetchPlaylistsSucceed
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
