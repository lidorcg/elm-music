{-
    This file is automatically generated by elm-graphql. Do not modify!
-}
module GraphQL.Playlists exposing (playLists, PlayListsResult, createPlaylist, CreatePlaylistResult)

import Task exposing (Task)
import Json.Decode exposing (..)
import Json.Encode exposing (encode)
import Http
import GraphQL exposing (apply, maybeEncode, ID)

endpointUrl : String
endpointUrl =
    "http://localhost:5000/playlists/graphql"


type alias PlayListsResult 
    = { playlists : (List     { id : String
    , name : (Maybe String)
    , tracks : (List         { id : String
        , name : (Maybe String)
        , duration : (Maybe String)
        , artists : (Maybe String)
        , youtubeId : (Maybe String)
        })
    })
}


playLists : Task Http.Error PlayListsResult
playLists =
    let graphQLQuery = """query playLists { playlists { id name tracks { id name duration artists youtubeId } } }""" in
    let graphQLParams =
            Json.Encode.object
                [ 
                ]
    in
    GraphQL.query endpointUrl graphQLQuery "playLists" (encode 0 graphQLParams) playListsResult


playListsResult : Decoder PlayListsResult
playListsResult =
    map PlayListsResult ("playlists" :=
        (list (map (\id name tracks -> { id = id, name = name, tracks = tracks }) ("id" := string)
        `apply` (maybe ("name" := string))
        `apply` ("tracks" :=
        (list (map (\id name duration artists youtubeId -> { id = id, name = name, duration = duration, artists = artists, youtubeId = youtubeId }) ("id" := string)
        `apply` (maybe ("name" := string))
        `apply` (maybe ("duration" := string))
        `apply` (maybe ("artists" := string))
        `apply` (maybe ("youtubeId" := string))))))))


type alias CreatePlaylistResult 
    = { createPlaylist :     { ok : (Maybe Bool)
    }
}


createPlaylist :     { name : String
    } -> Task Http.Error CreatePlaylistResult
createPlaylist params =
    let graphQLQuery = """mutation createPlaylist($name: String!) { createPlaylist(name: $name) { ok } }""" in
    let graphQLParams =
            Json.Encode.object
                [ ("name", Json.Encode.string params.name)
                ]
    in
    GraphQL.mutation endpointUrl graphQLQuery "createPlaylist" (encode 0 graphQLParams) createPlaylistResult


createPlaylistResult : Decoder CreatePlaylistResult
createPlaylistResult =
    map CreatePlaylistResult ("createPlaylist" :=
        (map (\ok -> { ok = ok }) (maybe ("ok" := bool))))
