module Views.Main exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (RemoteData(..),WebData)
import Html exposing (..)
import Views.TrackList as TrackList


-- VIEW


view : Model -> Html Msg
view {displayMain, playlists, searchResult} =
    case displayMain of
        DisplayPlaylist playlist ->
            displayList playlist

        DisplaySearchResult ->
            displaySearchResult searchResult

        DisplayNone ->
            p [] [ text "There is nothing to show" ]


displayList : Playlist -> Html Msg
displayList playlist =
  TrackList.view playlist.tracks


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
