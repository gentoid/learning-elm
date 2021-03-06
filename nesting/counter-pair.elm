import Counter
import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Events exposing (onClick)

main :Program Never
main =
  App.beginnerProgram
    { model = init 0 0 0
    , update = update
    , view = view
    }

type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  , clicks : Int
  }

init : Int -> Int -> Int -> Model
init top bottom clicks =
  { topCounter = Counter.init top
  , bottomCounter = Counter.init bottom
  , clicks = clicks
  }

type Msg
  = Reset
  | Swap
  | Top Counter.Msg
  | Bottom Counter.Msg

update : Msg -> Model -> Model
update message model =
  case message of
    Reset ->
      init 0 0 model.clicks

    Top msg ->
      { model | topCounter = Counter.update msg model.topCounter }

    Bottom msg ->
      { model | bottomCounter = Counter.update msg model.bottomCounter }

    Swap ->
      { topCounter = Counter.init model.bottomCounter
      , bottomCounter = Counter.init model.topCounter
      , clicks = model.clicks + 1
      }

view : Model -> Html Msg
view model =
  div []
    [ App.map Top (Counter.view model.topCounter)
    , App.map Bottom (Counter.view model.bottomCounter)
    , button [ onClick Reset ] [text "Reset" ]
    , button [ onClick Swap ] [ text "Swap" ]
    , div []
      [ text ("Maximum is " ++ toString (max model.topCounter model.bottomCounter)) ]
    , div []
      [ text ("Minimum is " ++ toString (min model.topCounter model.bottomCounter)) ]
    , div []
      [ text ("Clicks on 'Swap' button " ++ toString model.clicks) ]
    ]
