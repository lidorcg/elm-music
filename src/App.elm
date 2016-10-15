module App exposing (..)

import Html.App as App
import Utils.RemoteData exposing (..)
import GraphQL.Music exposing (search, SearchResult, playlists, PlaylistsResult)
import Http exposing (Error)
import Task exposing (perform, Task)
import Debug exposing (log)
import List exposing (map, filter, head)
import Maybe exposing (withDefault)
import String exposing (toInt)
import Html exposing (..)
import Html.Attributes exposing (class, href, style, placeholder, type')
import Html.Events exposing (onClick, onSubmit, onInput)
import CDN exposing (bulma, fontAwesome)


-- MAIN


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }



-- MODEL


type alias Model =
    { display : Display
    , playlists : RemoteData PlaylistsResult
    , query : String
    , searchResult : RemoteData SearchResult
    }


type Display
    = List String
    | SearchResult


init : ( Model, Cmd Msg )
init =
    ( Model SearchResult NotAsked "" NotAsked
    , playlists |> perform FetchPlaylistsFail FetchPlaylistsSucceed
    )


type alias Playlist =
    { id : String
    , name : Maybe String
    , tracks :
        List Track
    }


type alias Track =
    { name : Maybe String
    , artists : Maybe String
    , duration : Maybe String
    , youtubeId : Maybe String
    }



-- UPDATE


type Msg
    = ShowPlaylist String
    | FetchPlaylistsData
    | FetchPlaylistsFail Http.Error
    | FetchPlaylistsSucceed PlaylistsResult
    | ChangeQuery String
    | Search
    | FetchSearchFail Http.Error
    | FetchSearchSucceed SearchResult


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowPlaylist id ->
            ( { model | display = List id }
            , Cmd.none
            )

        Search ->
            ( { model | display = SearchResult, searchResult = Loading }
            , search { query = model.query } |> perform FetchSearchFail FetchSearchSucceed
            )

        ChangeQuery string ->
            ( { model | query = string }
            , Cmd.none
            )

        FetchSearchFail error ->
            ( { model | searchResult = Failure (log "error" error) }
            , Cmd.none
            )

        FetchSearchSucceed result ->
            ( { model | searchResult = Success result }
            , Cmd.none
            )

        FetchPlaylistsData ->
            ( { model | playlists = Loading }
            , playlists |> perform FetchPlaylistsFail FetchPlaylistsSucceed
            )

        FetchPlaylistsFail error ->
            ( { model | playlists = Failure (log "error" error) }
            , Cmd.none
            )

        FetchPlaylistsSucceed result ->
            ( { model | playlists = Success result }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , layout model
        ]


layout : Model -> Html Msg
layout model =
    div
        [ class "columns is-gapless" ]
        [ div
            [ class "column is-2" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ menu model ]
            ]
        , div
            [ class "column" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ navbar model
                , content model
                ]
            ]
        ]


menu : Model -> Html Msg
menu model =
    aside
        [ class "menu" ]
        [ a
            [ class "nav-item is-brand", href "#" ]
            [ h1
                [ class "title is-2 has-text-centered" ]
                [ text "Music" ]
            ]
        , hr [ style [ ( "margin", "10px" ) ] ] []
        , menuItems model
        ]


menuItems : Model -> Html Msg
menuItems model =
    case model.playlists of
        NotAsked ->
            p [] [ text "We haven't asked for your playlists yet" ]

        Loading ->
            p [] [ text "We're fetching your playlists now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            let
                active =
                    case model.display of
                        List id ->
                            id

                        SearchResult ->
                            ""
            in
                ul
                    [ class "menu-list" ]
                    (map (menuItem active) res.playlists)


menuItem : String -> Playlist -> Html Msg
menuItem active playlist =
    let
        isActive =
            if active == playlist.id then
                "is-active"
            else
                ""

        name =
            playlist.name |> withDefault "Unknown Playlist"
    in
        li
            []
            [ a
                [ class isActive, onClick (ShowPlaylist playlist.id) ]
                [ text name ]
            ]


navbar : Model -> Html Msg
navbar model =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ searchFrom model ]
        ]


searchFrom : Model -> Html Msg
searchFrom model =
    let
        isLoading =
            case model.searchResult of
                Loading ->
                    "is-loading"

                _ ->
                    ""
    in
        form [ onSubmit Search ]
            [ p [ class "nav-item control has-addons" ]
                [ input
                    [ class "input"
                    , placeholder "Find music"
                    , type' "text"
                    , onInput ChangeQuery
                    ]
                    []
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]


content : Model -> Html Msg
content model =
    case model.display of
        List id ->
            displayList id model.playlists

        SearchResult ->
            displaySearchResult model


displayList : String -> RemoteData PlaylistsResult -> Html Msg
displayList id playlists =
    case playlists of
        NotAsked ->
            p [] [ text "We haven't asked for this playlist yet" ]

        Loading ->
            p [] [ text "We're fetching your playlist right now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            let
                playlist =
                    filter (\lst -> lst.id == id) res.playlists |> head
            in
                case playlist of
                    Nothing ->
                        p [] [ text "There's no playlist here, we should probably check the DB" ]

                    Just lst ->
                        trackTable lst.tracks


displaySearchResult : Model -> Html Msg
displaySearchResult model =
    case model.searchResult of
        NotAsked ->
            p [] [ text "Try Searching for music..." ]

        Loading ->
            p [] [ text "We're fetching your music right now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            trackTable res.searchTracks


trackTable : List Track -> Html Msg
trackTable trackList =
    let
        trackRows =
            map trackRow trackList
    in
        table [ class "table" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Name" ]
                    , th [] [ text "Artist" ]
                    , th [] [ text "Duration" ]
                    , th [] [ text "ytID" ]
                    ]
                ]
            , tbody [] trackRows
            ]


trackRow : Track -> Html Msg
trackRow track =
    let
        name =
            track.name |> withDefault "Unknown Name"

        artist =
            track.artists |> withDefault "Unknown Artist"

        duration =
            track.duration |> viewDuration

        youtubeId =
            track.youtubeId |> viewYoutubeLink
    in
        tr []
            [ td [] [ text name ]
            , td [] [ text artist ]
            , td [] [ text duration ]
            , td [ class "is-icon" ] [ youtubeId ]
            ]


viewDuration : Maybe String -> String
viewDuration t =
    case t of
        Nothing ->
            "Unknown Duration"

        Just time ->
            let
                ms =
                    Result.withDefault 0 (toInt time)

                minutes =
                    ms // 1000 // 60

                seconds =
                    ms // 1000 `rem` 60

                zeroPadding =
                    if seconds < 10 then
                        "0"
                    else
                        ""
            in
                toString minutes ++ ":" ++ zeroPadding ++ toString seconds


viewYoutubeLink : Maybe String -> Html Msg
viewYoutubeLink ytId =
    case ytId of
        Nothing ->
            span [ class "icon" ]
                [ i [ class "fa fa-minus-circle" ] [] ]

        Just id ->
            a [ href <| "https://www.youtube.com/watch?v=" ++ id ]
                [ i [ class "fa fa-play-circle" ] [] ]
