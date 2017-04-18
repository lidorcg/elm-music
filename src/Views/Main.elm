module Views.Main exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (RemoteData(..), WebData)
import Html exposing (Html, p, text, div, span, i, a)
import Html.Attributes exposing (class, href, target)
import List exposing (map, filter, head)
import Views.TrackList as TrackList
import String exposing (toInt)
import Utils exposing (timeToString)
import Table exposing (defaultCustomizations)


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


config : Table.Config Track Msg
config =
    Table.customConfig
        { toId = .id >> Maybe.withDefault "no-id"
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Name" .name
            , Table.stringColumn "Artists" .artists
            , durationColumn
            , youtubeColumn
            ]
        , customizations =
            { defaultCustomizations | tableAttrs = [ class "table" ] }
        }


durationColumn : Table.Column Track Msg
durationColumn =
    Table.customColumn
        { name = "Duration"
        , viewData = .duration >> toInt >> Result.withDefault 0 >> timeToString
        , sorter = Table.increasingOrDecreasingBy .duration
        }


youtubeColumn : Table.Column Track Msg
youtubeColumn =
    Table.veryCustomColumn
        { name = "Youtube"
        , viewData = .youtubeId >> viewYoutubeLink
        , sorter = Table.unsortable
        }


viewYoutubeLink : Maybe String -> Table.HtmlDetails Msg
viewYoutubeLink ytId =
    let
        html =
            case ytId of
                Nothing ->
                    span [ class "icon" ]
                        [ i [ class "fa fa-minus-circle" ] [] ]

                Just id ->
                    a [ href <| "https://www.youtube.com/watch?v=" ++ id, target "_blank" ]
                        [ i [ class "fa fa-play-circle" ] [] ]
    in
        Table.HtmlDetails [ class "is-icon" ] [ html ]
