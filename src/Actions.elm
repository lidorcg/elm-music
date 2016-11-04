module Actions exposing (..)

import Models exposing (Playlist, Track)
import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists
    exposing
        ( PlaylistsResult
        , CreatePlaylistResult
        , RenamePlaylistResult
        , DeletePlaylistResult
        , AddTrackToPlaylistResult
        )
import Http exposing (Error)
import Dom exposing (Error)
import Mouse exposing (Position)


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
    | DragTrack Track Position
    | DragAt Position
    | DropTrack Position
    | EnterPlaylist String
    | LeavePlaylist
    | AddTrackToPlaylistResponseError Http.Error
    | AddTrackToPlaylistResponseOk AddTrackToPlaylistResult
      -- Remove Track From Playlist
      -- Edit Track On Playlist
      -- Create New Track
    | DoNothing
