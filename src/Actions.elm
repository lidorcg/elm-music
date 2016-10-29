module Actions exposing (..)

import Models exposing (Track)
import Http exposing (Error)
import GraphQL.Playlists exposing (PlayListsResult)
import GraphQL.Discover exposing (SearchResult)

-- ACTIONS

type Action
    = Search String
    | DisplayPlaylist String
    | AddTrackToPlaylist Track String
    | RemoveTrack String
    | CreateNewPlaylist String
    | RenamePlaylist
    | DeletePlaylist
    -- REMOTE DATA
    | PlaylistsRequestError Http.Error
    | PlaylistsRequestOk PlayListsResult
    | SearchRequestError Http.Error
    | SearchRequestOk SearchResult
