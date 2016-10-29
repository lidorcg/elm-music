module Components.Search exposing (Model, init, update, view)

import Actions exposing (..)
import GraphQL.Discover exposing (SearchResult, search)
import Task exposing (perform)
import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type', placeholder)


-- MODEL


type alias Model =
    { query : String
    , isLoading : Bool
    }


init : Model
init =
    Model "" False



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearchQuery string ->
            ( { model | query = string }
            , Cmd.none
            )

        Search ->
            ( { model | isLoading = True }
            , search { query = model.query }
                |> perform SearchResponseError SearchResponseOk
            )

        SearchResponseError _ ->
            ( { model | isLoading = False }
            , Cmd.none
            )

        SearchResponseOk _ ->
            ( { model | isLoading = False }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        isLoading =
            if model.isLoading then
                "is-loading"
            else
                ""
    in
        form [ onSubmit Search ]
            [ p [ class "nav-item control has-addons" ]
                [ input
                    [ class "input"
                    , placeholder "Find music"
                    , type' "text"
                    , onInput ChangeSearchQuery
                    ]
                    []
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]
