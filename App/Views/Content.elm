module Views.Content exposing (view)

import Html exposing (..)
import Views.TrackList as TrackList
import State.Main as State
import State.Display as Display
import State.Playlists as Playlists
import State.Search as Search
import List exposing (filter, head)
import Utils.RemoteData exposing (..)


-- VIEW


view : State.Model -> Html State.Msg
view state =
    case state.display of
        Display.List id ->
            displayList id state.playlists

        Display.SearchResult ->
            displaySearchResult state.search

        Display.Nothing ->
            TrackList.view []


displayList : String -> Playlists.Model -> Html State.Msg
displayList id playlists =
    case playlists of
        NotAsked ->
            TrackList.view []

        Loading ->
            TrackList.view []

        Failure err ->
            TrackList.view []

        Success res ->
            let
                playlist =
                    filter (\p -> p.id == id) res.playlists |> head
            in
                case playlist of
                    Nothing ->
                        TrackList.view []

                    Just p ->
                        TrackList.view p.tracks


displaySearchResult : Search.Model -> Html State.Msg
displaySearchResult search =
    case search.result of
        NotAsked ->
            TrackList.view []

        Loading ->
            TrackList.view []

        Failure err ->
            TrackList.view []

        Success res ->
            TrackList.view res.searchTracks
