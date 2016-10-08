module Views.Main exposing (view)

import Html exposing (..)
import CDN exposing (bulma, fontAwesome)
import Views.Layout as Layout
import State.Main as State


-- VIEW


view : State.Model -> Html State.Msg
view state =
    div []
        [ bulma.css
        , fontAwesome.css
        , Layout.view state
        ]
