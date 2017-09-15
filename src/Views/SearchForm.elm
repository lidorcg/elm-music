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
            [ div [ class "nav-item field is-grouped" ]
                [ p
                    [ class "control is-expanded" ]
                    [ input
                        [ class "input"
                        , placeholder "Artist"
                        , type_ "text"
                        , onInput SearchFormInputArtist
                        ]
                        []
                    ]
                , p
                    [ class "control is-expanded" ]
                    [ input
                        [ class "input"
                        , placeholder "Track"
                        , type_ "text"
                        , onInput SearchFormInputTrack
                        ]
                        []
                    ]
                , p
                    [ class "control" ]
                    [ button
                        [ class <| "button is-info " ++ isLoading ]
                        [ text "Search" ]
                    ]
                ]
            ]


isResultLoading : WebData a -> String
isResultLoading result =
    case result of
        Loading ->
            "is-loading"

        _ ->
            ""
