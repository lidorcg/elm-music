module Updates.RemoveTrackFromPlaylist exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (..)
import GraphQL.Playlists exposing (removeTrack, RemoveTrack)
import Task exposing (attempt)
import Debug exposing (log)
import List exposing (map)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RemoveTrack trackId ->
            ( model
            , removeTrack { trackId = trackId }
                |> attempt RemoveTrackResponse
            )

        RemoveTrackResponse result ->
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


processPlaylists : RemoveTrack -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.removeTrack.playlists
