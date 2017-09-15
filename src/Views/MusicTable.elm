module Views.MusicTable exposing (config)

import String exposing (toInt)
import Html exposing (span, i, a)
import Html.Attributes exposing (class, href, target)
import Html.Events exposing (onClick)
import Table exposing (defaultCustomizations)
import Models exposing (..)
import Actions exposing (..)
import Utils exposing (timeToString)


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
            , removeColumn
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


removeColumn : Table.Column Track Msg
removeColumn =
    Table.veryCustomColumn
        { name = "Remove"
        , viewData = .id >> viewRemoveIcon
        , sorter = Table.unsortable
        }


viewRemoveIcon : Maybe String -> Table.HtmlDetails Msg
viewRemoveIcon trackId =
    let
        html =
            case trackId of
                Nothing ->
                    span [] []

                Just id ->
                    a
                        [ class "delete", onClick <| RemoveTrack id ]
                        []
    in
        Table.HtmlDetails [ class "is-icon" ] [ html ]
