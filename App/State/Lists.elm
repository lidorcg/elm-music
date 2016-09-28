module State.Lists exposing (..)

import Models.List as List


-- MODEL


type alias State =
    { lists : List List.Model
    , active : Maybe Int
    }


init : State
init =
    let
        lists =
            [ List.Model 1 "All"
            , List.Model 2 "Rock"
            , List.Model 3 "Classic"
            , List.Model 4 "Ruhni"
            , List.Model 5 "Jazz"
            ]
    in
        State lists Nothing



-- UPDATE


type Msg
    = SetActiveList (Maybe Int)


update : Msg -> State -> State
update msg state =
    case msg of
        SetActiveList listId ->
            { state | active = listId }
