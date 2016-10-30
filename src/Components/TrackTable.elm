module Components.TrackTable exposing (Model, init, update, view)

import Actions exposing (..)
import Utils.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, style, draggable)
import List exposing (map)
import Maybe exposing (withDefault)
import Components.DragAndDrop exposing (dragableTrack)



-- MODEL


type alias Model =
    List Track


init : Model
init =
    []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    _ ->
      ( model, Cmd.none )



-- VIEW


view : List Track -> Html Msg
view trackList =
    let
        trackRows =
            map trackRow trackList
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
        youtubeIcon =
            track.youtubeId |> viewYoutubeLink
    in
        tr []
            [ dragableTrack track grabHandle 
            , td [] [ text track.name ]
            , td [] [ text track.artists ]
            , td [] [ text track.duration ]
            , td [ class "is-icon" ] [ youtubeIcon ]
            ]


grabHandle : Html Msg
grabHandle =
    td [ style [ ( "cursor", "grab" ) ] ]
        [ span [ class "icon" ]
            [ i [ class "fa fa-bars" ] [] ]
        ]


viewYoutubeLink : Maybe String -> Html Msg
viewYoutubeLink ytId =
    case ytId of
        Nothing ->
            span [ class "icon" ]
                [ i [ class "fa fa-minus-circle" ] [] ]

        Just id ->
            a [ href <| "https://www.youtube.com/watch?v=" ++ id ]
                [ i [ class "fa fa-play-circle" ] [] ]
