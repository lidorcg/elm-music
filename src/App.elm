module App exposing (..)

import Html as App
import State
import View
import Actions
import Reducer
import Subscriptions exposing (subscriptions)

main : Program Never State.Model Actions.Msg
main =
    App.program
        { init = State.init
        , view = View.view
        , update = Reducer.update
        , subscriptions = subscriptions
        }
