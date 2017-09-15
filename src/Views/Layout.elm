module Views.Layout exposing (view)

import State exposing (..)
import Actions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Menu as Menu
import Views.Nav as Nav
import Views.Main as Main


-- VIEW


view : Model -> Html Msg
view state =
    div
        [ class "columns is-gapless" ]
        [ div
            [ class "column is-2" ]
            [ div
                [ class "container is-marginless is-fixed is-1-6-width" ]
                [ Menu.view state ]
            ]
        , div
            [ class "column" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ Nav.view state
                , Main.view state
                ]
            ]
        ]
