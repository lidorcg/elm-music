# elm-music
front-end to my MusicAPy project using:
* [elm](https://github.com/elm-lang/elm-lang.org)
* [bulma](https://github.com/jgthms/bulma)
* [elm-graphql](https://github.com/jahewson/elm-graphql)

#### Architecture
I've built this project from the bottom up and started with the simple elm architecture.
As the work progressed I chose a more separated way of Models, Views, Actions (much like flux).
I chose this separation because of depndencies, most modules will need only one of these modules (Model, View, Action)
and so I saw fit to separate them...
I'd like some comments on this architecture if anyone has any contribution, please, let it be heard
