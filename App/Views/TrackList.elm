module Views.TrackList exposing (view)

import List exposing (map)
import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class)
import Views.TrackListItem as Track


-- VIEW


view model =
    let
        tracks =
            map viewTrack model
    in
        div []
            [ h3 [ class "title is-3" ] [ text "Tracks:" ]
            , tracks |> trackTable
            ]


trackTable tracks =
    table [ class "table" ]
        [ thead []
            [ tr []
                [ th [] [ text "Name" ]
                , th [] [ text "Artist" ]
                , th [] [ text "ytID" ]
                ]
            ]
        , tbody [] tracks
        ]


viewTrack track =
    Track.view track
