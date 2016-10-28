module Views.Main exposing (view)

import Reducers.State.Main exposing (..)
import Actions.Main as Actions
import Html exposing (..)
import List exposing (filter, head)
import Views.TrackTable as TrackTable


-- VIEW


view : Model -> Html Actions.Msg
view model =
    case model.display of
        ShowPlaylist id ->
            displayPlaylist id model.playlists

        SearchResult ->
            TrackTable.view model.searchResult

        None ->
            div [] []


displayPlaylist : String -> List Playlist -> Html Actions.Msg
displayPlaylist id playlists =
    let
        playlist =
            filter (\p -> p.id == id) playlists |> head
    in
        case playlist of
            Nothing ->
                p [] [ text "There's no playlist here, we should probably check the DB" ]

            Just p ->
                TrackTable.view p.tracks
