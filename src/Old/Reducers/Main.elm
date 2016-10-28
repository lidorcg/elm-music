module Reducers.Main exposing (..)

import Actions.Main exposing (..)
import Reducers.Data as Data
import Reducers.State as State
import Utils.SendMsg exposing (sendMsg)


-- MODEL


type alias Model =
    { data : Data.Model
    , state : State.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model Data.init State.init
    , sendMsg GetPlaylistsRequest
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( data, dataCmd ) =
            Data.update msg model.data

        ( state, stateCmd ) =
            State.update msg model.state
    in
        ( { model | data = data, state = state }
        , Cmd.batch [ dataCmd, stateCmd ]
        )
