module Updates.RenamePlaylist exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (..)
import GraphQL.Playlists exposing(renamePlaylist, RenamePlaylist)
import Dom exposing (focus)
import Task exposing (attempt)
import Debug exposing (log)
import List exposing (map)

-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowRenamePlaylistForm ->
            ( { model | displayForm = DisplayRenamePlaylistForm }
            , focus "new-playlist-form" |> attempt FocusFail
            )

        RenamePlaylistFormInput name ->
            let
                renamePlaylistForm =
                    RenamePlaylistForm model.renamePlaylistForm.id name
            in
                ( { model | renamePlaylistForm = renamePlaylistForm }
                , Cmd.none
                )

        RenamePlaylist ->
            ( { model | displayForm = DisplayNoForm }
            , renamePlaylist model.renamePlaylistForm
                |> attempt RenamePlaylistResponse
            )

        RenamePlaylistResponse result ->
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

processPlaylists : RenamePlaylist -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.renamePlaylist.playlists
