module Actions exposing (..)

import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (PlaylistsResult, CreatePlaylistResult)
import Http exposing (Error)


-- ACTIONS


type Msg
    =
      -- Search
      SearchFormInputQuery String
    | Search
    | SearchFail Http.Error
    | SearchSucceed SearchResult
      -- Display Playlist
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed PlaylistsResult
    | ShowPlaylist String
      -- Create New Playlist
    | ShowNewPlaylistModal
    | HideNewPlaylistModal
    | NewPlaylistFormInputName String
    | CreateNewPlaylist
    | CreateNewPlaylistResponseError Http.Error
    | CreateNewPlaylistResponseOk CreatePlaylistResult
      -- Rename Playlist
      -- Delete Playlist
      -- Add Track To Playlist
      -- Remove Track From Playlist
      -- Edit Track On Playlist
      -- Create New Track
