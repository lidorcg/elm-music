module Updates.CreatePlaylist exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (..)
import GraphQL.Playlists exposing(createPlaylist, CreatePlaylist)
import Dom exposing (focus)
import Task exposing (attempt)
import Debug exposing (log)
import List exposing (map)

-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowNewPlaylistForm ->
            ( { model | displayForm = DisplayNewPlaylistForm }
            , focus "new-playlist-form" |> attempt FocusFail
            )

        NewPlaylistFormInputName name ->
            ( { model | newPlaylistForm = NewPlaylistForm name }
            , Cmd.none
            )

        CreateNewPlaylist ->
            ( { model
                | displayForm = DisplayNoForm
                , newPlaylistForm = NewPlaylistForm ""
              }
            , createPlaylist model.newPlaylistForm
                |> attempt CreateNewPlaylistResponse
            )

        CreateNewPlaylistResponse result ->
            let
                playlists =
                    case result of
                        Ok res ->
                            Success (processPlaylists res)

                        Err err ->
                            Failure (log "error" err)
            in
                ( { model | playlists = playlists }
                , Cmd.none
                )

        _ ->
            ( model, Cmd.none )

processPlaylists : CreatePlaylist -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.createPlaylist.playlists
