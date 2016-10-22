module Utils.SendMsg exposing (..)

import Task

sendMsg : msg -> Cmd msg
sendMsg msg =
    Task.perform (always msg) (always msg) (Task.succeed ())
