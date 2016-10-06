module State.Content exposing (..)

-- MODEL


type Content i
    = List i
    | Search
    | Nothing


type alias State =
    Content Int


init : State
init =
    Nothing



-- UPDATE


type Msg
    = SetContent (Content Int)

update : Msg -> State -> State
update msg state =
    case msg of
        SetContent content ->
            content
