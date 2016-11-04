module Reducer exposing (..)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (RemoteData(..))
import GraphQL.Discover exposing (search, SearchResult)
import GraphQL.Playlists
    exposing
        ( playlists
        , createPlaylist
        , renamePlaylist
        , deletePlaylist
        , addTrackToPlaylist
        )
import Debug exposing (log)
import Task exposing (perform)
import List exposing (map, filter, head)
import Dom


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormInputQuery string ->
            ( { model
                | searchForm = SearchForm string
              }
            , Cmd.none
            )

        Search ->
            ( { model
                | searchResult = Loading
                , displayMain = DisplaySearchResult
              }
            , search model.searchForm
                |> perform SearchFail SearchSucceed
            )

        SearchFail error ->
            ( { model
                | searchResult = Failure (log "error" error)
              }
            , Cmd.none
            )

        SearchSucceed result ->
            ( { model
                | searchResult =
                    Success <|
                        processSearchResult result
                , displayMain = DisplaySearchResult
              }
            , Cmd.none
            )

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
                | displayMain = DisplayPlaylist playlist
                , displayForm = DisplayNoForm
                , renamePlaylistForm = RenamePlaylistForm playlist.id playlist.name
                , deletePlaylistForm = DeletePlaylistForm playlist.id
              }
            , Cmd.none
            )

        HideForm ->
            ( { model | displayForm = DisplayNoForm }
            , Cmd.none
            )

        ShowNewPlaylistForm ->
            ( { model | displayForm = DisplayNewPlaylistForm }
            , Dom.focus "new-playlist-form"
                |> perform FocusFail (always DoNothing)
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
                |> perform CreateNewPlaylistResponseError CreateNewPlaylistResponseOk
            )

        CreateNewPlaylistResponseError error ->
            ( { model
                | playlists = Failure (log "error" error)
              }
            , Cmd.none
            )

        CreateNewPlaylistResponseOk result ->
            ( { model
                | playlists =
                    Success <|
                        processPlaylists result.createPlaylist.playlists
              }
            , Cmd.none
            )

        ShowRenamePlaylistForm ->
            ( { model
                | displayForm = DisplayRenamePlaylistForm
              }
            , Dom.focus "rename-playlist-form"
                |> perform FocusFail (always DoNothing)
            )

        RenamePlaylistFormInput name ->
            let
                renamePlaylistForm =
                    RenamePlaylistForm
                        model.renamePlaylistForm.id
                        name
            in
                ( { model
                    | renamePlaylistForm = renamePlaylistForm
                  }
                , Cmd.none
                )

        RenamePlaylist ->
            ( { model
                | displayForm = DisplayNoForm
              }
            , renamePlaylist model.renamePlaylistForm
                |> perform RenamePlaylistResponseError RenamePlaylistResponseOk
            )

        RenamePlaylistResponseError error ->
            ( { model
                | playlists = Failure (log "error" error)
              }
            , Cmd.none
            )

        RenamePlaylistResponseOk result ->
            ( { model
                | playlists =
                    Success <|
                        processPlaylists result.renamePlaylist.playlists
              }
            , Cmd.none
            )

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
                |> perform DeletePlaylistResponseError DeletePlaylistResponseOk
            )

        DeletePlaylistResponseError error ->
            ( { model
                | playlists = Failure (log "error" error)
              }
            , Cmd.none
            )

        DeletePlaylistResponseOk result ->
            ( { model
                | playlists =
                    Success <|
                        processPlaylists result.deletePlaylist.playlists
              }
            , Cmd.none
            )

        DoNothing ->
            ( model
            , Cmd.none
            )

        FocusFail err ->
            let
                error =
                    log "error" error
            in
                ( model, Cmd.none )

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
                ( { model
                    | dnd = Dnd Nothing Nothing Nothing
                  }
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

        AddTrackToPlaylistResponseError error ->
            ( { model
                | playlists = Failure (log "error" error)
              }
            , Cmd.none
            )

        AddTrackToPlaylistResponseOk result ->
            ( { model
                | playlists =
                    Success <|
                        processPlaylists result.addTrack.playlists
              }
            , Cmd.none
            )


processPlaylists : List RemotePlaylist -> List Playlist
processPlaylists playlists =
    List.map remotePlaylistToPlaylist playlists


processSearchResult : SearchResult -> List Track
processSearchResult result =
    List.map remoteSearchTrackToTrack result.searchTracks


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
                            |> perform AddTrackToPlaylistResponseError AddTrackToPlaylistResponseOk
