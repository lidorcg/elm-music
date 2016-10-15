module Views.Content exposing (view)

import Reducers.Main as State
import Actions.Main as Actions
import Html exposing (..)
import Reducers.Display as Display
import Reducers.Playlists as Playlists
import Reducers.Search as Search
import Utils.RemoteData exposing (..)
import List exposing (filter, head)
import Views.TrackList as TrackList


-- VIEW


view : State.Model -> Html Actions.Msg
view state =
    case state.display of
        Display.List id ->
            displayList id state.playlists

        Display.SearchResult ->
            displaySearchResult state.search

        Display.Nothing ->
            p [] [ text "There is nothing to show" ]


displayList : String -> Playlists.Model -> Html Actions.Msg
displayList id playlists =
    case playlists of
        NotAsked ->
            p [] [ text "We haven't asked for this playlist yet" ]

        Loading ->
            p [] [ text "We're fetching your playlist right now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            let
                playlist =
                    filter (\p -> p.id == id) res.playlists |> head
            in
                case playlist of
                    Nothing ->
                        p [] [ text "There's no playlist here, we should probably check the DB" ]

                    Just p ->
                        TrackList.view p.tracks


displaySearchResult : Search.Model -> Html Actions.Msg
displaySearchResult search =
    case search.result of
        NotAsked ->
            p [] [ text "Try Searching for music..." ]

        Loading ->
            p [] [ text "We're fetching your music right now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            TrackList.view res.searchTracks
