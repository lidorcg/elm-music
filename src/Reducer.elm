module Reducer exposing (..)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (RemoteData(..))
import GraphQL.Discover exposing (search, SearchResult)
import GraphQL.Playlists exposing (playlists, createPlaylist, renamePlaylist, deletePlaylist)
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


processPlaylists : List RemotePlaylist -> List Playlist
processPlaylists playlists =
    List.map remotePlaylistToPlaylist playlists


processSearchResult : SearchResult -> List Track
processSearchResult result =
    List.map remoteSearchTrackToTrack result.searchTracks
