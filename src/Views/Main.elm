module Views.Main exposing (view)

import Reducers.Main as State
import Actions.Main as Actions
import Html exposing (..)
import CDN exposing (bulma, fontAwesome)
import Views.Layout as Layout


-- VIEW


view : State.Model -> Html Actions.Msg
view state =
    div []
        [ bulma.css
        , fontAwesome.css
        , Layout.view state
        ]
