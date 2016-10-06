module Views.SearchResult exposing (view)

import Views.TrackList as TrackList
import Models.RemoteData exposing (..)


-- VIEW


view searchState =
  case searchState.result of
    NotAsked ->
      TrackList.view []

    Loading ->
      TrackList.view []

    Failure e ->
      TrackList.view []

    Success res ->
      TrackList.view res.searchTracks
