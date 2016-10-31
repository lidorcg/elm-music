module View exposing (view)

import State exposing (Model)
import Actions exposing (Msg)
import Html exposing (..)
import Views.Index as Index


-- VIEW


view : Model -> Html Msg
view state =
    Index.view state
