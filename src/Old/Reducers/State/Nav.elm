module Reducers.State.Nav exposing (..)

import Actions.Main exposing (..)
import Utils.SendMsg exposing (sendMsg)


-- MODEL


type alias Model =
    { query : String
    , status : String
    }


init : Model
init =
    Model "" ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormInputQuery string ->
            ( { model | query = string }
            , Cmd.none
            )

        SearchFormSubmit ->
            ( { model | status = "is-loading" }
            , sendMsg (SearchRequest model.query)
            )

        SearchResponse _ ->
            ( { model | status = "" }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
