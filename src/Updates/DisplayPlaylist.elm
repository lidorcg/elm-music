module Updates.DisplayPlaylist exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (..)
import GraphQL.Playlists exposing (Playlists)
import Debug exposing (log)
import List exposing (map)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlaylistResponse result ->
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

        ShowPlaylist playlist ->
            ( { model
                | displayMain = DisplayPlaylist playlist.id
                , displayForm = DisplayNoForm
                , renamePlaylistForm = RenamePlaylistForm playlist.id playlist.name
                , deletePlaylistForm = DeletePlaylistForm playlist.id
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


processPlaylists : Playlists -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.playlists
