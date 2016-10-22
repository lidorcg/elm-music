module Views.Layout exposing (view)

import Reducers.State exposing (Model)
import Actions.Main exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Menu as Menu
import Views.Nav as Nav
import Views.Content as Content


-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "columns is-gapless" ]
        [ div
            [ class "column is-2" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ Menu.view model.menu ]
            ]
        , div
            [ class "column" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ Nav.view model.nav
                , Content.view model.main
                ]
            ]
        ]
