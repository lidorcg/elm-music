module Views.Menu exposing (view)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (class, href)
import State.Main as Main
import Views.MenuItems as MenuItems


-- VIEW

view : Main.State -> Html Main.Msg
view state =
    aside
        [ class "menu" ]
        [ a
            [ class "nav-item is-brand", href "#" ]
            [ h1
                [ class "title is-2 has-text-centered" ]
                [ text "Music" ]
            ]
        , viewMenuList state
        ]


viewMenuList : Main.State -> Html Main.Msg
viewMenuList state =
    App.map Main.ListsMsg <| MenuItems.view state.listsState
