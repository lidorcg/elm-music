module Views.SearchResult exposing (view)

import Views.TrackList as TrackList


-- VIEW


view searchState =
    TrackList.view searchState.results
