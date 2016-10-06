module State.Main exposing (..)

import State.Search as Search
import State.Lists as Lists
import State.Content as Content


-- MODEL


type alias State =
    { searchState : Search.State
    , listsState : Lists.State
    , contentState : Content.State
    }


init : ( State, Cmd a )
init =
    ( State Search.init Lists.init Content.init
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

                ( updatedlistsState, updatedcontentState ) =
                    case searchMsg of
                        Search.ChangeQuery input ->
                            ( state.listsState, state.contentState )

                        _ ->
                            ( Lists.update (Lists.SetActiveList Nothing) state.listsState
                            , Content.update (Content.SetContent Content.Search) state.contentState
                            )
            in
                ( { state
                    | searchState = updatedSearchState
                    , listsState = updatedlistsState
                  }
                , Cmd.map SearchMsg searchCmd
                )

        ListsMsg listsMsg ->
            let
                updatedListsState =
                    Lists.update listsMsg state.listsState

                updatedcontentState =
                  case listsMsg of
                    Lists.SetActiveList index ->
                      case index of
                        Nothing ->
                          state.contentState

                        Just i ->
                          Content.update (Content.SetContent <| Content.List i) state.contentState
            in
                ( { state | listsState = updatedListsState }
                , Cmd.none
                )
