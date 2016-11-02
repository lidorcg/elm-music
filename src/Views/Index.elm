module Views.Index exposing (view)

import State exposing (..)
import Actions exposing (..)
import Utils exposing (stylesheet)
import Html exposing (..)
import Views.Layout as Layout
import Views.Modals as Modals


-- VIEW


view : Model -> Html Msg
view state =
    div []
        [ stylesheet "assets/css/bulma.css"
        , stylesheet "assets/css/font-awesome.css"
        , Layout.view state
        , Modals.view state
        ]
