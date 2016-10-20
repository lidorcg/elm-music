module Actions.Main exposing (..)

import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (AllPlaylistsResult)
import Http exposing (Error)


-- ACTIONS


type Msg
    = ShowPlaylist String
    | FetchPlaylistsData
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed AllPlaylistsResult
    | ChangeQuery String
    | Search
    | FetchSearchFail Http.Error
    | FetchSearchSucceed SearchResult
