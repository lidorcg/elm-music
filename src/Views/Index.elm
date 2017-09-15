module Views.Index exposing (view)

import State exposing (..)
import Actions exposing (..)
import Utils exposing (stylesheet)
import Html exposing (..)
import Views.Layout as Layout
import Views.Modals as Modals
import Views.Dnd as Dnd


-- VIEW


view : Model -> Html Msg
view state =
    div []
        [ stylesheet "assets/css/font-awesome.css"
        , stylesheet "assets/css/bulma.css"
        , stylesheet "assets/css/main.css"
        , Layout.view state
        , Modals.view state
        , Dnd.view state
        ]
