module Reducer exposing (..)

import State exposing (..)
import Actions exposing (..)
import List exposing (foldr)
import Platform.Cmd exposing (batch)
import Updates.Search as Search
import Updates.DisplayPlaylist as DisplayPlaylist
import Updates.CreatePlaylist as CreatePlaylist
import Updates.RenamePlaylist as RenamePlaylist
import Updates.DeletePlaylist as DeletePlaylist
import Updates.AddTrackToPlaylist as AddTrackToPlaylist
import Updates.RemoveTrackFromPlaylist as RemoveTrackFromPlaylist
import Updates.Commons as Commons


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updates =
            [ Search.update
            , DisplayPlaylist.update
            , CreatePlaylist.update
            , RenamePlaylist.update
            , DeletePlaylist.update
            , AddTrackToPlaylist.update
            , RemoveTrackFromPlaylist.update
            , Commons.update
            ]

        ( nextModel, cmds ) =
            foldr (applyUpdate msg) ( model, [] ) updates
    in
        ( nextModel, batch cmds )


applyUpdate : Msg -> (Msg -> Model -> ( Model, Cmd Msg )) -> ( Model, List (Cmd Msg) ) -> ( Model, List (Cmd Msg) )
applyUpdate msg update ( model, cmds ) =
    let
        ( nextModel, cmd ) =
            update msg model
    in
        ( nextModel, cmd :: cmds )
