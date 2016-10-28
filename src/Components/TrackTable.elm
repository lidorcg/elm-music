module Components.TrackTable exposing (Model, init, update, view)

import Actions.Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import List exposing (map)
import Maybe exposing (withDefault)


-- MODEL


type alias Model =
    List Track


type alias Track =
    { name : String
    , artists : String
    , duration : String
    , youtubeId : Maybe String
    }


init : Model
init =
    []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
                    [ th [] [ text "Name" ]
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
            [ td [] [ text track.name ]
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
