module Actions exposing (..)

import Models exposing (Playlist)
import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists
    exposing
        ( PlaylistsResult
        , CreatePlaylistResult
        , RenamePlaylistResult
        , DeletePlaylistResult
        )
import Http exposing (Error)
import Dom exposing (Error)


-- ACTIONS


type Msg
    = -- Search
      SearchFormInputQuery String
    | Search
    | SearchFail Http.Error
    | SearchSucceed SearchResult
      -- Display Playlist
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed PlaylistsResult
    | ShowPlaylist Playlist
      -- Create New Playlist
    | HideForm
    | ShowNewPlaylistForm
    | NewPlaylistFormInputName String
    | CreateNewPlaylist
    | CreateNewPlaylistResponseError Http.Error
    | CreateNewPlaylistResponseOk CreatePlaylistResult
      -- Rename Playlist
    | ShowRenamePlaylistForm
    | FocusFail Dom.Error
    | RenamePlaylistFormInput String
    | RenamePlaylist
    | RenamePlaylistResponseError Http.Error
    | RenamePlaylistResponseOk RenamePlaylistResult
      -- Delete Playlist
    | ShowDeletePlaylistForm
    | DeletePlaylist
    | DeletePlaylistResponseError Http.Error
    | DeletePlaylistResponseOk DeletePlaylistResult
      -- Add Track To Playlist
      -- Remove Track From Playlist
      -- Edit Track On Playlist
      -- Create New Track
    | DoNothing
