module Updates.DisplayPlaylist exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models
    exposing
        ( MainDisplay(DisplayPlaylist)
        , DisplayForm(DisplayNoForm)
        , RenamePlaylistForm
        , DeletePlaylistForm
        , remotePlaylistToPlaylist
        , RemotePlaylist
        , Playlist
        )
import Utils exposing (RemoteData(..))
import Debug exposing (log)
import List exposing (map)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPlaylistsFail error ->
            ( { model
                | playlists = Failure (log "error" error)
              }
            , Cmd.none
            )

        FetchPlaylistsSucceed result ->
            ( { model
                | playlists =
                    Success <|
                        processPlaylists result.playlists
              }
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


processPlaylists : List RemotePlaylist -> List Playlist
processPlaylists playlists =
    map remotePlaylistToPlaylist playlists
