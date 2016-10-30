module Components.DragAndDrop exposing (Model, init, update, subscriptions, view, dragableTrack, dropablePlaylist)

import Actions exposing (..)
import Utils.Models exposing (Track)
import Mouse exposing (Position)
import Json.Decode as Json
import Html exposing (..)
import Html.Attributes exposing (class, style, href)
import Html.Events exposing (on, onMouseUp, onMouseEnter, onMouseLeave)


-- MODEL


type alias Model =
    { track : Maybe Track
    , playlistId : Maybe String
    , drag : Maybe Position
    }


init : Model
init =
    Model Nothing Nothing Nothing



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DragTrack track pos ->
            ( { model | track = Just track, drag = Just pos }
            , Cmd.none
            )

        DragAt pos ->
            let
                drag =
                    (Maybe.map (\_ -> pos) model.drag)
            in
                ( { model | drag = drag }
                , Cmd.none
                )

        DropTrack _ ->
            ( { model | track = Nothing, playlistId = Nothing, drag = Nothing }
            , Cmd.none
            )

        EnterPlaylist playlistId ->
            ( { model | playlistId = Just playlistId }
            , Cmd.none
            )

        LeavePlaylist ->
            ( { model | playlistId = Nothing }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


makeAddTrackArgs : Track -> String -> { track : Track, playlistId : String }
makeAddTrackArgs track playlistId =
    { track = track, playlistId = playlistId }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DropTrack ]



-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


view : Model -> Html Msg
view model =
    case model.drag of
        Nothing ->
            div [] []

        Just pos ->
            span
                [ class "icon is-large"
                , style
                    [ "position" => "absolute"
                    , "left" => px (pos.x-28)
                    , "top" => px (pos.y-28)
                    , "cursor" => "move"
                    ]
                ]
                [ i [ class "fa fa-music" ] [] ]


px : Int -> String
px number =
    toString number ++ "px"


dragableTrack : Track -> Html Msg -> Html Msg
dragableTrack track view =
    div [ onMouseDown track ]
        [ view ]


dropablePlaylist : String -> Html Msg -> Html Msg
dropablePlaylist playlistId view =
    div [ onMouseEnter (EnterPlaylist playlistId), onMouseLeave LeavePlaylist ]
        [ view ]


onMouseDown : Track -> Attribute Msg
onMouseDown track =
    on "mousedown" (Json.map (dragTrack track) Mouse.position)


dragTrack : Track -> Position -> Msg
dragTrack track pos =
    DragTrack track pos
