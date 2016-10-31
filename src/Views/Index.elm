module Views.Index exposing (view)

import State exposing (..)
import Actions exposing (..)
import Html exposing (..)
import CDN exposing (bulma, fontAwesome)
import Views.Layout as Layout
import Views.Modals as Modals


-- VIEW


view : Model -> Html Msg
view state =
    div []
        [ bulma.css
        , fontAwesome.css
        , Layout.view state
        , Modals.view state
        ]
