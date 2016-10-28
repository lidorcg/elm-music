module Views.TrackTable exposing (view)

import Reducers.State.Main exposing (..)
import Reducers.State.DragAndDrop exposing (dragableTrack)
import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import List exposing (map)
import Maybe exposing (withDefault)


-- VIEW


view : List Track -> Html Actions.Msg
view trackList =
    let
        trackRows =
            map trackRow trackList
    in
        table [ class "table" ]
            [ thead []
                [ tr []
                    [ th []
                        [ span [ class "icon" ]
                            [ i [ class "fa fa-hand-rock-o" ] [] ]
                        ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Artist" ]
                    , th [] [ text "Duration" ]
                    , th [] [ text "ytID" ]
                    ]
                ]
            , tbody [] trackRows
            ]


trackRow : Track -> Html Actions.Msg
trackRow track =
    let
        youtubeIcon =
            track.youtubeId |> viewYoutubeLink
    in
        tr []
            [ dragableTrack grabHandle track
            , td [] [ text track.name ]
            , td [] [ text track.artists ]
            , td [] [ text track.duration ]
            , td [ class "is-icon" ] [ youtubeIcon ]
            ]


grabHandle : Html Actions.Msg
grabHandle =
    td [ style [ ( "cursor", "grab" ) ] ]
        [ span [ class "icon" ]
            [ i [ class "fa fa-bars" ] [] ]
        ]


viewYoutubeLink : Maybe String -> Html Actions.Msg
viewYoutubeLink ytId =
    case ytId of
        Nothing ->
            span [ class "icon" ]
                [ i [ class "fa fa-minus-circle" ] [] ]

        Just id ->
            a [ href <| "https://www.youtube.com/watch?v=" ++ id ]
                [ i [ class "fa fa-play-circle" ] [] ]
