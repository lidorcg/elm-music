module Views.SearchForm exposing (view)

import State exposing (..)
import Actions exposing (..)
import Utils exposing (RemoteData(..), WebData)
import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type_, placeholder)


-- VIEW


view : Model -> Html Msg
view { searchResult } =
    let
        isLoading =
            isResultLoading searchResult
    in
        form [ onSubmit Search ]
            [ p [ class "nav-item control has-addons" ]
                [ input
                    [ class "input"
                    , placeholder "Artist"
                    , type_ "text"
                    , onInput SearchFormInputArtist
                    ]
                    []
                , input
                    [ class "input"
                    , placeholder "Track"
                    , type_ "text"
                    , onInput SearchFormInputTrack
                    ]
                    []
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]


isResultLoading : WebData a -> String
isResultLoading result =
    case result of
        Loading ->
            "is-loading"

        _ ->
            ""
