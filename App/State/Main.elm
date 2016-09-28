module State.Main exposing (..)

import State.Search as Search
import State.Lists as Lists


-- MODEL


type alias State =
    { searchState : Search.State
    , listsState : Lists.State
    }


init : ( State, Cmd a )
init =
    ( State Search.init Lists.init
    , Cmd.none
    )



-- UPDATE


type Msg
    = SearchMsg Search.Msg
    | ListsMsg Lists.Msg


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        SearchMsg searchMsg ->
            let
                ( updatedSearchState, searchCmd ) =
                    Search.update searchMsg state.searchState
            in
                ( { state | searchState = updatedSearchState }
                , Cmd.map SearchMsg searchCmd
                )

        ListsMsg listsMsg ->
            let
                updatedListsState =
                    Lists.update listsMsg state.listsState
            in
                ( { state | listsState = updatedListsState }
                , Cmd.none
                )
