module Views.Content exposing (view)

import Html exposing (..)
import Views.SearchResult as SearchResult
import State.Main as Main


-- VIEW


view : Main.State -> Html Main.Msg
view state =
    SearchResult.view state.searchState
