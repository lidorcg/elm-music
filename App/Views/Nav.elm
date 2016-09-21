module Views.Nav exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class, href)
import Views.SearchForm as SearchForm

-- VIEW


view searchModel =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ a [ class "nav-item is-brand", href "#" ]
                [ h1 [ class "title" ] [ text "Music" ] ]
            , a [ class "nav-item", href "#" ]
                [ text "Home    " ]
            , a [ class "nav-item", href "#" ]
                [ text "Documentation    " ]
            , a [ class "nav-item", href "#" ]
                [ text "Blog    " ]
            ]
        , div [ class "nav-center" ]
            [ SearchForm.view searchModel ]
        ]
