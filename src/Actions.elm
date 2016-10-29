module Actions exposing (..)

import Utils.Models exposing (Track)
import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (PlaylistsResult, CreatePlaylistResult)
import Http exposing (Error)


type Msg
    = -- DOM EVENTS
      -- Search
      ChangeSearchQuery String
    | Search
      -- Menu
    | DisplayPlaylist String
    | ShowNewPlaylistModal
     -- NewPlaylistModal
    | HideNewPlaylistModal
    | NewPlaylistFormInputName String
    | CreateNewPlaylist
      -- DragAndDrop
    | DragTrack Track
    | DropTrack
    | EnterPlaylist String
    | LeavePlaylist
      ---- REMOTE DATA EVENTS ----
      -- Search
    | SearchResponseError Http.Error
    | SearchResponseOk SearchResult
      -- Playlists
    | FetchPlaylistsResponseError Http.Error
    | FetchPlaylistsResponseOk PlaylistsResult
    | CreateNewPlaylistResponseError Http.Error
    | CreateNewPlaylistResponseOk CreatePlaylistResult


-- TODO: handle search failure
-- TODO: handle playlists fetch failure
-- TODO: handle create new playlist failure
