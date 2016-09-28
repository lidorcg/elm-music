module Views.Main exposing (view)

import Html exposing (..)
import CDN exposing (bulma, fontAwesome)
import Views.Layout as Layout


-- VIEW


view state =
    div []
        [ bulma.css
        , fontAwesome.css
        , Layout.view state
        ]
