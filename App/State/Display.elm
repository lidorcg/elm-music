module State.Display exposing (..)

-- MODEL


type Display
    = List String
    | SearchResult
    | Nothing


type alias Model =
    Display


init : Model
init =
    Nothing



-- UPDATE


type Msg
    = ShowList String
    | ShowSearch


update : Msg -> Model -> Model
update msg model =
    case msg of
        ShowList id ->
            List id

        ShowSearch ->
            SearchResult
