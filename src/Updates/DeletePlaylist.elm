module Updates.DeletePlaylist exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (..)
import GraphQL.Playlists exposing (deletePlaylist, DeletePlaylist)
import Task exposing (attempt)
import Debug exposing (log)
import List exposing (map)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowDeletePlaylistForm ->
            ( { model
                | displayForm = DisplayDeleteForm
              }
            , Cmd.none
            )

        DeletePlaylist ->
            ( { model
                | displayForm = DisplayNoForm
              }
            , deletePlaylist model.deletePlaylistForm
                |> attempt DeletePlaylistResponse
            )

        DeletePlaylistResponse result ->
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


processPlaylists : DeletePlaylist -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.deletePlaylist.playlists
