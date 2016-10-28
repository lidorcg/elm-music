module Reusables.Modal exposing (Model, init, Msg, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Html.App exposing (map)


-- MODEL


type alias Model a =
    { display : Display
    , childModel : a
    }


type Display
    = Show
    | Hide


init : a -> Model a
init initChildModel =
    Model Hide initChildModel



-- UPDATE


type Msg b
    = CloseModal
    | OpenModal
    | ChildMsg b


update : (b -> a -> (a, Cmd b)) -> Msg b -> Model a -> ( Model a, Cmd (Msg b) )
update childUpdate msg model =
    case msg of
        CloseModal ->
            ( { model | display = Hide }
            , Cmd.none
            )

        OpenModal ->
            ( { model | display = Show }
            , Cmd.none
            )

        ChildMsg childMsg ->
            let
                (childModel, childCmd) =
                    childUpdate childMsg model.childModel
            in
                ( { model | childModel = childModel }
                , Cmd.map ChildMsg childCmd
                )



-- VIEW


view : (mdl -> Html msg) -> Model mdl -> Html (Msg msg)
view view model =
    let
        isActive =
            case model.display of
                Show ->
                    "is-active"

                Hide ->
                    ""
    in
        div
            [ class ("modal " ++ isActive) ]
            [ div
                [ class "modal-background"
                , onClick CloseModal
                , style [ ( "background-color", "rgba(17, 17, 17, 0.16)" ) ]
                ]
                []
            , div
                [ class "modal-content" ]
                [ map ChildMsg (view model.childModel) ]
            , button
                [ class "modal-close", onClick CloseModal ]
                []
            ]
