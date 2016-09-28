module Views.MenuItems exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import List exposing (map)
import State.Lists as Lists
import Models.List as List


-- VIEW


view : Lists.State -> Html Lists.Msg
view listsState =
    ul
        [ class "menu-list" ]
        (viewItems listsState)


viewItems : Lists.State -> List (Html Lists.Msg)
viewItems listsState =
    map (viewItem listsState.active) listsState.lists


viewItem : Maybe Int -> List.Model -> Html Lists.Msg
viewItem active list =
    let
        isActive =
            isListActive active list.id
    in
        li
            []
            [ a
                [ class isActive, onClick (Lists.SetActiveList (Just list.id)) ]
                [ text list.name ]
            ]


isListActive : Maybe Int -> Int -> String
isListActive active id =
    case active of
        Nothing ->
            ""

        Just activeId ->
            if activeId == id then
                "is-active"
            else
                ""
