module Layout exposing (view)

import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class, type', placeholder, href, alt, src)
import CDN exposing (bulma, fontAwesome)
import View.Search as Search
import Actions


-- VIEW


view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , viewSearch model.searchState
        ]


viewSearch searchModel =
    App.map Actions.SearchMsg <| Search.view searchModel
