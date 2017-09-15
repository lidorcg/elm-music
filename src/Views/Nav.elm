module Views.Nav exposing (view)

import State exposing (..)
import Actions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Views.SearchForm as SearchForm


-- VIEW


view : Model -> Html Msg
view state =
    nav [ class "nav" ]
        [ div [ class "container" ]
            [ div [ class "nav-left" ]
                [ SearchForm.view state ]
            ]
        ]
