module Actions exposing (..)

import Models exposing (Playlist, Track)
import GraphQL.Discover exposing (Search)
import GraphQL.Playlists exposing (Playlists, CreatePlaylist, RenamePlaylist, DeletePlaylist, AddTrackToPlaylist, RemoveTrack)
import Http exposing (Error)
import Dom exposing (Error)
import Mouse exposing (Position)
import Table


-- ACTIONS


type Msg
    = -- Search
      SearchFormInputQuery String
    | Search
    | SearchResponse (Result Http.Error Search)
    | ShowSearchResult
      -- Display Playlist
    | PlaylistResponse (Result Http.Error Playlists)
    | ShowPlaylist Playlist
      -- Create New Playlist
    | ShowNewPlaylistForm
    | NewPlaylistFormInputName String
    | CreateNewPlaylist
    | CreateNewPlaylistResponse (Result Http.Error CreatePlaylist)
      -- Rename Playlist
    | ShowRenamePlaylistForm
    | RenamePlaylistFormInput String
    | RenamePlaylist
    | RenamePlaylistResponse (Result Http.Error RenamePlaylist)
      -- Delete Playlist
    | ShowDeletePlaylistForm
    | DeletePlaylist
    | DeletePlaylistResponse (Result Http.Error DeletePlaylist)
      -- Add Track To Playlist
    | DragTrack Track Position
    | DragAt Position
    | DropTrack Position
    | EnterPlaylist String
    | LeavePlaylist
    | AddTrackToPlaylistResponse (Result Http.Error AddTrackToPlaylist)
      -- Remove Track From Playlist
    | RemoveTrack String
    | RemoveTrackResponse (Result Http.Error RemoveTrack)
      -- Edit Track On Playlist
      -- Create New Track
      -- Search and sort music
    | SetTableState Table.State
      -- Commons
    | FocusFail (Result Dom.Error ())
    | HideForm
    | DoNothing
