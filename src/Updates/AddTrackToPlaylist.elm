module Updates.AddTrackToPlaylist exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (..)
import GraphQL.Playlists exposing (addTrackToPlaylist, AddTrackToPlaylist)
import Task exposing (attempt)
import Debug exposing (log)
import List exposing (map)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DragTrack track pos ->
            let
                playlistId =
                    model.dnd.playlistId
            in
                ( { model
                    | dnd = Dnd (Just track) playlistId (Just pos)
                  }
                , Cmd.none
                )

        DragAt pos ->
            let
                track =
                    model.dnd.track

                playlistId =
                    model.dnd.playlistId

                newPos =
                    (Maybe.map (\_ -> pos) model.dnd.pos)
            in
                ( { model
                    | dnd = Dnd track playlistId newPos
                  }
                , Cmd.none
                )

        DropTrack _ ->
            let
                track =
                    model.dnd.track

                playlistId =
                    model.dnd.playlistId
            in
                ( { model | dnd = Dnd Nothing Nothing Nothing }
                , maybeAddTrackToPlaylist playlistId track
                )

        EnterPlaylist playlistId ->
            let
                id =
                    case model.dnd.track of
                        Nothing ->
                            Nothing

                        _ ->
                            Just playlistId

                track =
                    model.dnd.track

                pos =
                    model.dnd.pos
            in
                ( { model | dnd = Dnd track id pos }
                , Cmd.none
                )

        LeavePlaylist ->
            let
                track =
                    model.dnd.track

                pos =
                    model.dnd.pos
            in
                ( { model | dnd = Dnd track Nothing pos }
                , Cmd.none
                )

        AddTrackToPlaylistResponse result ->
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


processPlaylists : AddTrackToPlaylist -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.addTrack.playlists


maybeAddTrackToPlaylist : Maybe String -> Maybe Track -> Cmd Msg
maybeAddTrackToPlaylist playlistId track =
    case playlistId of
        Nothing ->
            Cmd.none

        Just id ->
            case track of
                Nothing ->
                    Cmd.none

                Just t ->
                    let
                        trk =
                            { name = t.name
                            , artists = t.artists
                            , duration = t.duration
                            , youtubeId = t.youtubeId
                            }
                    in
                        addTrackToPlaylist { track = trk, playlistId = id }
                            |> attempt AddTrackToPlaylistResponse
