module Views.TrackList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import List exposing (map)
import Maybe exposing (withDefault)
import String exposing (join)


-- VIEW


view trackList =
    let
        trackRows =
            map trackRow trackList
    in
        table [ class "table" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Name" ]
                    , th [] [ text "Artist" ]
                    , th [] [ text "ytID" ]
                    ]
                ]
            , tbody [] trackRows
            ]


trackRow track =
    let
        name =
            track.name |> withDefault "Unknown"

        artistsNames =
            map (.name >> withDefault "Unknown") track.artists |> join ", "

        youtubeId =
            track.youtubeId |> youtubeLinkView
    in
        tr []
            [ td [] [ text name ]
            , td [] [ text artistsNames ]
            , td [ class "is-icon" ] [ youtubeId ]
            ]


youtubeLinkView ytId =
    case ytId of
        Nothing ->
            span [ class "icon" ]
                [ i [ class "fa fa-minus-circle" ] [] ]

        Just id ->
            a [ href <| "https://www.youtube.com/watch?v=" ++ id ]
                [ i [ class "fa fa-play-circle" ] [] ]
