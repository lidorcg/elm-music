module Views.Main exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Html exposing (..)
import List exposing (filter, head)
import Views.TrackList as TrackList


-- VIEW


view : Model -> Html Msg
view {displayMain, playlists, searchResult} =
    case displayMain of
        DisplayPlaylist id ->
            displayList id playlists

        DisplaySearchResult ->
            displaySearchResult searchResult

        DisplayNone ->
            p [] [ text "There is nothing to show" ]


displayList : String -> RemoteData (List Playlist) -> Html Msg
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
                    filter (\p -> p.id == id) res |> head
            in
                case playlist of
                    Nothing ->
                        p [] [ text "There's no playlist here, we should probably check the DB" ]

                    Just p ->
                        TrackList.view p.tracks


displaySearchResult : RemoteData (List Track) -> Html Msg
displaySearchResult searchResult =
    case searchResult of
        NotAsked ->
            p [] [ text "Try Searching for music..." ]

        Loading ->
            p [] [ text "We're fetching your music right now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            TrackList.view res
