module Reducer exposing (..)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import GraphQL.Discover exposing (search, SearchResult)
import GraphQL.Playlists exposing (playlists, PlaylistsResult, createPlaylist)
import Debug exposing (log)
import Task exposing (perform)
import List exposing (map)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormInputQuery string ->
            ( { model
                | searchQuery = string
              }
            , Cmd.none
            )

        Search ->
            ( { model
                | searchResult = Loading
                , displayMain = DisplaySearchResult
              }
            , search { query = model.searchQuery }
                |> perform SearchFail SearchSucceed
            )

        SearchFail error ->
            ( { model
                | searchResult = Failure (log "error" error)
              }
            , Cmd.none
            )

        SearchSucceed result ->
            ( { model
                | searchResult = Success <| processSearchResult result
                , displayMain = DisplaySearchResult
              }
            , Cmd.none
            )

        FetchPlaylistsFail error ->
            ( { model
                | playlists = Failure (log "error" error)
              }
            , Cmd.none
            )

        FetchPlaylistsSucceed result ->
            ( { model
                | playlists = Success <| processPlaylists result
              }
            , Cmd.none
            )

        ShowPlaylist id ->
            ( { model
                | displayMain = DisplayPlaylist id
              }
            , Cmd.none
            )

        ShowNewPlaylistModal ->
            ( { model | displayModal = ShowNewPlaylist }
            , Cmd.none
            )

        HideNewPlaylistModal ->
            ( { model | displayModal = Hide }
            , Cmd.none
            )

        NewPlaylistFormInputName name ->
            ( { model | newPlaylistName = name }
            , Cmd.none
            )

        CreateNewPlaylist ->
            ( { model | displayModal = Hide }
            , createPlaylist { name = model.newPlaylistName }
                |> perform CreateNewPlaylistResponseError CreateNewPlaylistResponseOk
            )

-- TODO: handle create new playlist response
        CreateNewPlaylistResponseError error ->
            ( { model
                | playlists = Failure (log "error" error)
              }
            , Cmd.none
            )

        CreateNewPlaylistResponseOk result ->
            ( model
            , Cmd.none
            )


processPlaylists : PlaylistsResult -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.playlists


processSearchResult : SearchResult -> List Track
processSearchResult result =
    map remoteSearchTrackToTrack result.searchTracks
