module Actions.Main exposing (..)

import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (AllPlaylistsResult, CreatePlaylistResult)
import Http exposing (Error)


-- ACTIONS


type Msg
    =
    -- Display
      DisplayPlaylist String
    | DisplayNewPlaylistForm
    | CloseNewPlaylistForm
    -- Playlists
    | FetchPlaylists
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed AllPlaylistsResult
    -- Search
    | SearchFormInputQuery String
    | SearchFormSubmit
    | FetchSearchResultFail Http.Error
    | FetchSearchResultSucceed SearchResult
    -- NewPlaylist
    | NewPlaylistFormInputName String
    | NewPlaylistFormSubmit
    | CreateNewPlaylistFail Http.Error
    | CreateNewPlaylistSucceed CreatePlaylistResult
