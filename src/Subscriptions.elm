module Subscriptions exposing (..)

import State exposing (..)
import Actions exposing (..)
import Mouse exposing (moves, ups)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.dnd.pos of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DropTrack ]
