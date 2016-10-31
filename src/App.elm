module App exposing (..)

import Html.App as App
import State
import View
import Reducer


main : Program Never
main =
    App.program
        { init = State.init
        , view = View.view
        , update = Reducer.update
        , subscriptions = (always Sub.none)
        }
