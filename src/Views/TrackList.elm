module Views.TrackList exposing (view)

import Actions exposing (..)
import Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, style, target)
import Html.Events exposing (on, onClick)
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
                    , th [] [ text "Remove" ]
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
            , td [ class "is-icon" ] [ removeTrackIcon track.id ]
            ]


grabHandle : Html Msg
grabHandle =
    span [ class "icon", style [ ( "cursor", "grab" ) ] ]
        [ i [ class "fa fa-bars" ] [] ]


viewTrackDuration : String -> String
viewTrackDuration time =
    let
        ms =
            Result.withDefault 0 (toInt time)

        s = ms // 1000

        minutes =
            s // 60

        seconds =
            rem s 60

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
            a [ href <| "https://www.youtube.com/watch?v=" ++ id, target "_blank" ]
                [ i [ class "fa fa-play-circle" ] [] ]


removeTrackIcon : Maybe String -> Html Msg
removeTrackIcon trackId =
    case trackId of
        Nothing ->
            span [] []

        Just id ->
            a [ onClick <| RemoveTrack id ]
                [ i [ class "fa fa-trash-o" ] [] ]


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
