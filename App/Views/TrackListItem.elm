module Views.TrackListItem exposing (view)

import String exposing (join)
import Maybe exposing (withDefault)
import List exposing (map)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class, href)


-- VIEW


view model =
    let
        name =
            model.name |> withDefault "Unknown"

        artistsNames =
            map (.name >> withDefault "Unknown") model.artists |> join ", "

        -- TODO: figure out map and |> operator
        youtubeId =
            model.youtubeId |> youtubeLinkView
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
            a [ href ("https://www.youtube.com/watch?v=" ++ id) ]
                [ i [ class "fa fa-play-circle" ] [] ]
