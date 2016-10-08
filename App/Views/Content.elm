module Views.Content exposing (view)

import Stores.Main as State
import Actions.Main as Actions
import Html exposing (..)
import Stores.Display as Display
import Stores.Playlists as Playlists
import Stores.Search as Search
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
            p [] [ text "It's seems that we didn't even try to get this playlist" ]

        Loading ->
            p [] [ text "We're fetching your playlist right now" ]

        Failure err ->
            p [] [ text "We couldn't fetch your playlist" ]

        Success res ->
            let
                playlist =
                    filter (\p -> p.id == id) res.playlists |> head
            in
                case playlist of
                    Nothing ->
                        p [] [ text "There's nothing here" ]

                    Just p ->
                        TrackList.view p.tracks


displaySearchResult : Search.Model -> Html Actions.Msg
displaySearchResult search =
    case search.result of
        NotAsked ->
            p [] [ text "It's seems that we didn't even try to search your music" ]

        Loading ->
            p [] [ text "We're fetching your music right now" ]

        Failure err ->
            p [] [ text "We couldn't fetch your music" ]

        Success res ->
            TrackList.view res.searchTracks
