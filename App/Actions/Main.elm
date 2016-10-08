module Actions.Main exposing (..)

import GraphQL.Music exposing (PlaylistsResult, SearchResult)
import Http exposing (Error)


-- ACTIONS


type Msg
    = ShowPlaylist String
    | FetchPlaylistsData
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed PlaylistsResult
    | ChangeQuery String
    | Search
    | FetchSearchFail Http.Error
    | FetchSearchSucceed SearchResult
