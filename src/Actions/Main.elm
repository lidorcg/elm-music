module Actions.Main exposing (..)

import Reusables.Modal as Modal
import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (AllPlaylistsResult, CreatePlaylistResult)
import Http exposing (Error)


-- ACTIONS
-- TODO: Try breaking by views

type Msg
    = ---- STATE EVENTS ----
      -- Nav
      SearchFormInputQuery String
    | SearchFormSubmit
      -- Menu
    | DisplayPlaylist String
    | DisplayNewPlaylistModal
      -- Modal
    | NewPlaylistModalMsg (Modal.Msg Msg)
    | NewPlaylistFormInputName String
    | NewPlaylistFormSubmit
      ---- STATE DATA EVENTS ----
    | SearchResponse (Result Http.Error SearchResult)
    | GetPlaylistsResponse (Result Http.Error AllPlaylistsResult)
      ---- REMOTE DATA EVENTS ----
      -- Search
    | SearchRequest String
    | SearchRequestError Http.Error
    | SearchRequestOk SearchResult
      -- Get Playlists
    | GetPlaylistsRequest
    | GetPlaylistsRequestError Http.Error
    | GetPlaylistsRequestOk AllPlaylistsResult
      -- Create New Playlist
    | CreateNewPlaylistRequest String
    | CreateNewPlaylistRequestError Http.Error
    | CreateNewPlaylistRequestOk CreatePlaylistResult


type alias Track =
    { name : String
    , artists : String
    , duration : String
    , youtubeId : Maybe String
    }
