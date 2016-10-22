module Views.Main exposing (view)

import Reducers.Main exposing (Model)
import Actions.Main exposing (Msg)
import Html exposing (..)
import CDN exposing (bulma, fontAwesome)
import Views.Layout as Layout
import Views.Modal as Modal


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , Layout.view model.state
        , Modal.view model.state.modal
        ]
