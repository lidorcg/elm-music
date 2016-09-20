module Main exposing (..)

import Html.App
import Layout


main : Program Never
main =
    Html.App.program
        { init = Layout.init
        , view = Layout.view
        , update = Layout.update
        , subscriptions = \_ -> Sub.none
        }
