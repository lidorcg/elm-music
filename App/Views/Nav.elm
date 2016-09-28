module Views.Nav exposing (view)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import Views.SearchForm as SearchForm
import State.Main as Main


-- VIEW


view : Main.State -> Html Main.Msg
view state =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ searchFrom state ]
        ]


searchFrom : Main.State -> Html Main.Msg
searchFrom state =
    App.map Main.SearchMsg <| SearchForm.view state.searchState
