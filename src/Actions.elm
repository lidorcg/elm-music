module Actions exposing (..)

import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (AllPlaylistsResult)
import Http exposing (Error)


-- ACTIONS


type Msg
    = ShowPlaylist String
    | FetchPlaylists
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed AllPlaylistsResult
    | ChangeQuery String
    | Search
    | FetchSearchFail Http.Error
    | FetchSearchSucceed SearchResult
