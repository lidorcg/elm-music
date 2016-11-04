module App exposing (..)

import Html.App as App
import State
import View
import Reducer
import Subscriptions exposing (subscriptions)

main : Program Never
main =
    App.program
        { init = State.init
        , view = View.view
        , update = Reducer.update
        , subscriptions = subscriptions
        }
