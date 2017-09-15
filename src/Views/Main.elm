module Views.Main exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (RemoteData(..), WebData)
import Html exposing (Html, p, text, div, span, i, a)
import List exposing (map, filter, head)
import Views.TrackList as TrackList
import Table
import Views.MusicTable exposing (config)


-- VIEW


view : Model -> Html Msg
view { displayMain, playlists, searchResult, tableState } =
    case displayMain of
        DisplayPlaylist playlistId ->
            displayPlayist playlistId playlists tableState

        DisplaySearchResult ->
            displaySearchResult searchResult

        DisplayNone ->
            p [] [ text "There is nothing to show" ]


displayPlayist : String -> WebData (List Playlist) -> Table.State -> Html Msg
displayPlayist playlistId playlists tableState =
    case playlists of
        NotAsked ->
            p [] [ text "We haven't asked for this playlist yet" ]

        Loading ->
            p [] [ text "We're fetching your playlist right now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            let
                playlistView =
                    res
                        |> filter (\p -> p.id == playlistId)
                        |> map (\p -> Table.view config tableState p.tracks)
            in
                div [] playlistView


displaySearchResult : WebData (List Track) -> Html Msg
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
