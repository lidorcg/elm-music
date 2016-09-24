module Views.Main exposing (view)

import Html.App as App
import Html exposing (..)
import CDN exposing (bulma, fontAwesome)
import Views.Nav as Nav
import Views.SearchResult as SearchResult
import State.Main as Actions


-- VIEW


view state =
    div []
        [ bulma.css
        , fontAwesome.css
        , navView state.searchState
        , SearchResult.view state.searchState
        ]


navView searchState =
    App.map Actions.SearchMsg <| Nav.view searchState
