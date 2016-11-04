module Views.TrackList exposing (view)

import Actions exposing (..)
import Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (on)
import String exposing (toInt)
import Mouse exposing (Position)
import Json.Decode as Json


-- VIEW


view : List Track -> Html Msg
view trackList =
    let
        trackRows =
            List.map trackRow trackList
    in
        table [ class "table" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Drag" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Artist" ]
                    , th [] [ text "Duration" ]
                    , th [] [ text "ytID" ]
                    ]
                ]
            , tbody [] trackRows
            ]


trackRow : Track -> Html Msg
trackRow track =
    let
        duration =
            track.duration |> viewTrackDuration

        youtubeIcon =
            track.youtubeId |> viewYoutubeLink
    in
        tr []
            [ td [] [ dragableTrack track grabHandle ]
            , td [] [ text track.name ]
            , td [] [ text track.artists ]
            , td [] [ text duration ]
            , td [ class "is-icon" ] [ youtubeIcon ]
            ]


grabHandle : Html Msg
grabHandle =
    span [ class "icon", style [ ( "cursor", "grab" ) ]  ]
        [ i [ class "fa fa-bars" ] [] ]


viewTrackDuration : String -> String
viewTrackDuration time =
    let
        ms =
            Result.withDefault 0 (toInt time)

        minutes =
            ms // 1000 // 60

        seconds =
            ms // 1000 `rem` 60

        zeroPadding =
            if seconds < 10 then
                "0"
            else
                ""
    in
        toString minutes ++ ":" ++ zeroPadding ++ toString seconds


viewYoutubeLink : Maybe String -> Html Msg
viewYoutubeLink ytId =
    case ytId of
        Nothing ->
            span [ class "icon" ]
                [ i [ class "fa fa-minus-circle" ] [] ]

        Just id ->
            a [ href <| "https://www.youtube.com/watch?v=" ++ id ]
                [ i [ class "fa fa-play-circle" ] [] ]


dragableTrack : Track -> Html Msg -> Html Msg
dragableTrack track view =
    span [ onMouseDown track ]
        [ view ]


onMouseDown : Track -> Attribute Msg
onMouseDown track =
    on "mousedown" (Json.map (dragTrack track) Mouse.position)


dragTrack : Track -> Position -> Msg
dragTrack track pos =
    DragTrack track pos
