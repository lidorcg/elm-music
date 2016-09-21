module Main exposing (..)

import Html.App
import Views.Main as View
import Models.Main as Model
import Actions.Main as Actions


main : Program Never
main =
    Html.App.program
        { init = Model.init
        , view = View.view
        , update = Actions.update
        , subscriptions = \_ -> Sub.none
        }
