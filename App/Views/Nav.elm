module Views.Nav exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Views.SearchForm as SearchForm


-- VIEW


view searchState =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ a [ class "nav-item is-brand", href "#" ]
                [ h1 [ class "title" ] [ text "Music" ] ]
            , SearchForm.view searchState
            ]
        ]
