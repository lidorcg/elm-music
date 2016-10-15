module Views.Nav exposing (view)

import Reducers.Main as State
import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (..)
import Views.SearchForm as SearchForm


-- VIEW


view : State.Model -> Html Actions.Msg
view state =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ SearchForm.view state.search ]
        ]
