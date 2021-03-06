import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Events exposing (onClick)

main: Program Never
main =
  App.beginnerProgram { model = 0, view = view, update = update }

type Msg = Increment | Decrement | Reset

update: Msg -> number -> number
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

    Reset ->
      0

view: a -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]
    ]
