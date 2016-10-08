module Views.Nav exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Views.SearchForm as SearchForm
import State.Main as State


-- VIEW


view : State.Model -> Html State.Msg
view state =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ SearchForm.view state.search ]
        ]
