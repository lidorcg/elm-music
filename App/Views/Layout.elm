module Views.Layout exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Menu as Menu
import Views.Nav as Nav
import Views.Content as Content
import State.Main as Main


-- VIEW


view : Main.State -> Html Main.Msg
view state =
    div
        [ class "columns is-gapless" ]
        [ div
            [ class "column is-2" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ Menu.view state ]
            ]
        , div
            [ class "column" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ Nav.view state
                , Content.view state
                ]
            ]
        ]
