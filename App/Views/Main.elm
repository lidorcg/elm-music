module Views.Main exposing (view)

import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class, type', placeholder, href, alt, src)
import CDN exposing (bulma, fontAwesome)
import Views.Nav as Nav
import Views.SearchResult as SearchResult
import Actions.Main as Actions


-- VIEW


view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , navView model.searchState
        , SearchResult.view model.searchState
        ]


navView searchModel =
    App.map Actions.SearchMsg <| Nav.view searchModel
