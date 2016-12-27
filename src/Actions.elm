module Actions exposing (..)

import Models exposing (Playlist, Track)
import GraphQL.Discover exposing (Search)
import GraphQL.Playlists
    exposing
        ( Playlists
        , CreatePlaylist
        , RenamePlaylist
        , DeletePlaylist
        , AddTrackToPlaylist
        , RemoveTrack
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
    | SearchSucceed Search
    | ShowSearchResult
      -- Display Playlist
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed Playlists
    | ShowPlaylist Playlist
      -- Create New Playlist
    | HideForm
    | ShowNewPlaylistForm
    | NewPlaylistFormInputName String
    | CreateNewPlaylist
    | CreateNewPlaylistResponseError Http.Error
    | CreateNewPlaylistResponseOk CreatePlaylist
      -- Rename Playlist
    | ShowRenamePlaylistForm
    | FocusFail Dom.Error
    | RenamePlaylistFormInput String
    | RenamePlaylist
    | RenamePlaylistResponseError Http.Error
    | RenamePlaylistResponseOk RenamePlaylist
      -- Delete Playlist
    | ShowDeletePlaylistForm
    | DeletePlaylist
    | DeletePlaylistResponseError Http.Error
    | DeletePlaylistResponseOk DeletePlaylist
      -- Add Track To Playlist
    | DragTrack Track Position
    | DragAt Position
    | DropTrack Position
    | EnterPlaylist String
    | LeavePlaylist
    | AddTrackToPlaylistResponseError Http.Error
    | AddTrackToPlaylistResponseOk AddTrackToPlaylist
      -- Remove Track From Playlist
    | RemoveTrack String
    | RemoveTrackResponseError Http.Error
    | RemoveTrackResponseOk RemoveTrack
      -- Edit Track On Playlist
      -- Create New Track
    | DoNothing
