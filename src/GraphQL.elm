module GraphQL exposing (query , mutation , apply , maybeEncode)

{-| This library provides support functions used by
    [elm-graphql](https://github.com/jahewson/elm-graphql), the GraphQL code generator for Elm.

# Helper functions
@docs query, mutation, apply, maybeEncode

-}

import Task exposing (Task)
import Json.Decode exposing (..)
import Json.Encode
import Http


{-| Executes a GraphQL query.
-}
query : String -> String -> String -> String -> Json.Encode.Value -> Decoder a -> Task Http.Error a
query method url query operation variables decoder =
    fetch method url query operation variables decoder


{-| Executes a GraphQL mutation.
-}
mutation : String -> String -> String -> Json.Encode.Value -> Decoder a -> Task Http.Error a
mutation url query operation variables decoder =
    fetch "POST" url query operation variables decoder


fetch : String -> String -> String -> String -> Json.Encode.Value -> Decoder a -> Task Http.Error a
fetch verb url query operation variables decoder =
    let
        request =
            (case verb of
                "GET" ->
                    buildRequestWithQuery verb url query operation variables

                _ ->
                    buildRequestWithBody verb url query operation variables
            )
    in
        Http.toTask <| request decoder


buildRequestWithQuery : String -> String -> String -> String -> Json.Encode.Value -> Decoder a -> Http.Request a
buildRequestWithQuery method url query operation variables decoder =
    let
        params =
            [ ( "query", query )
            , ( "operationName", operation )
            , ( "variables", (Json.Encode.encode 0 variables) )
            ]
    in
        Http.request
            { method = method
            , headers = [ Http.header "Accept" "application/json" ]
            , url = urlBuilder url params
            , body = Http.emptyBody
            , expect = Http.expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }


buildRequestWithBody : String -> String -> String -> String -> Json.Encode.Value -> Decoder a -> Http.Request a
buildRequestWithBody method url query operation variables decoder =
    let
        params =
            Json.Encode.object
                [ ( "query", Json.Encode.string query )
                , ( "operationName", Json.Encode.string operation )
                , ( "variables", variables )
                ]
    in
        Http.request
            { method = method
            , headers =
                [ Http.header "Accept" "application/json"
                , Http.header "Content-Type" "application/json"
                ]
            , url = urlBuilder url []
            , body = Http.jsonBody params
            , expect = Http.expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }


queryResult : Decoder a -> Decoder a
queryResult decoder =
    oneOf
        [ at [ "data" ] decoder
        , fail "Expected 'data' field"
          -- todo: report failure reason from server
        ]


{-| Combines two object decoders.
-}
apply : Decoder (a -> b) -> Decoder a -> Decoder b
apply func value =
    map2 (<|) func value


{-| Encodes a `Maybe` as JSON, using `null` for `Nothing`.
-}
maybeEncode : (a -> Value) -> Maybe a -> Value
maybeEncode e v =
    case v of
        Nothing ->
            Json.Encode.null

        Just a ->
            e a


urlBuilder : String -> List ( String, String ) -> String
urlBuilder baseUrl args =
    case args of
        [] ->
            baseUrl

        _ ->
            baseUrl ++ "?" ++ String.join "&" (List.map queryPair args)


queryPair : ( String, String ) -> String
queryPair ( key, value ) =
    queryEscape key ++ "=" ++ queryEscape value


queryEscape : String -> String
queryEscape string =
    String.join "+" (String.split "%20" (Http.encodeUri string))
