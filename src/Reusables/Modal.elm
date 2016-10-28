module Reusables.Modal exposing (Model, init, Msg, update, view, open, close)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Html.App exposing (map)


-- MODEL


type Model
    = Show
    | Hide


init : Model
init =
    Hide



-- UPDATE


type Msg
    = CloseModal
    | OpenModal


update : Msg -> Model -> Model
update msg model =
    case msg of
        CloseModal ->
            Hide

        OpenModal ->
            Show



-- VIEW


view : Model -> (Msg -> a) -> Html a -> Html a
view model msg children =
    let
        isActive =
            case model of
                Show ->
                    "is-active"

                Hide ->
                    ""
    in
        div
            [ class ("modal " ++ isActive) ]
            [ map msg background
            , div
                [ class "modal-content" ]
                [ children ]
            , map msg closeButton
            ]


background : Html Msg
background =
    div
        [ class "modal-background"
        , onClick CloseModal
        , style [ ( "background-color", "rgba(17, 17, 17, 0.16)" ) ]
        ]
        []


closeButton : Html Msg
closeButton =
    button
        [ class "modal-close", onClick CloseModal ]
        []



-- API


open : Msg
open =
    OpenModal


close : Msg
close =
    CloseModal
