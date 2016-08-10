import Html exposing (Html)
import Html.App as App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Cmd.none)

type Msg = Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick

view : Model -> Html Msg
view model =
  let
    angleSeconds = turns (Time.inMinutes model)
    handYSeconds = toString (50 - 40 * cos angleSeconds)
    handXSeconds = toString (50 + 40 * sin angleSeconds)

    angleMinutes = angleSeconds / 60
    handYMinutes = toString (50 - 37 * cos angleMinutes)
    handXMinutes = toString (50 + 37 * sin angleMinutes)

    angleHours = angleMinutes / 12 + turns 1/3
    handYHours = toString (50 - 32 * cos angleHours)
    handXHours = toString (50 + 32 * sin angleHours)
  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r"45", fill "#0b79ce" ] []
      , line [ x1 "50", y1 "50", x2 handXSeconds, y2 handYSeconds, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 handXMinutes, y2 handYMinutes, stroke "#023963", strokeWidth "2" ] []
      , line [ x1 "50", y1 "50", x2 handXHours, y2 handYHours, stroke "#023963", strokeWidth "3" ] []
      ]
