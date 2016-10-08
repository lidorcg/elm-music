module Views.TrackList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import List exposing (map)
import String exposing (toInt)
import Maybe exposing (withDefault)


-- MODEL


type alias Model =
    List Track


type alias Track =
    { name : Maybe String
    , artists : Maybe String
    , duration : Maybe String
    , youtubeId : Maybe String
    }



-- VIEW


view : List Track -> Html msg
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
                    , th [] [ text "Duration" ]
                    , th [] [ text "ytID" ]
                    ]
                ]
            , tbody [] trackRows
            ]


trackRow : Track -> Html msg
trackRow track =
    let
        name =
            track.name |> withDefault "Unknown Name"

        artist =
            track.artists |> withDefault "Unknown Artist"

        duration =
            track.duration |> viewDuration

        youtubeId =
            track.youtubeId |> viewYoutubeLink
    in
        tr []
            [ td [] [ text name ]
            , td [] [ text artist ]
            , td [] [ text duration ]
            , td [ class "is-icon" ] [ youtubeId ]
            ]


viewDuration : Maybe String -> String
viewDuration t =
    case t of
        Nothing ->
            "Unknown Duration"

        Just time ->
            let
                ms =
                    Result.withDefault 0 (toInt time)

                minutes =
                    ms // 1000 // 60

                seconds =
                    ms // 1000 `rem` 60

                zeroPadding =
                  if seconds < 10 then "0" else ""
            in
                toString minutes ++ ":" ++ zeroPadding ++ toString seconds


viewYoutubeLink : Maybe String -> Html msg
viewYoutubeLink ytId =
    case ytId of
        Nothing ->
            span [ class "icon" ]
                [ i [ class "fa fa-minus-circle" ] [] ]

        Just id ->
            a [ href <| "https://www.youtube.com/watch?v=" ++ id ]
                [ i [ class "fa fa-play-circle" ] [] ]
