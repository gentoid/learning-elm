import Html exposing (..)
import Html.App as App
import Html.Events exposing (onClick)
import Random exposing (..)

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { dieFace1 : Int
  , dieFace2 : Int
  }

init : (Model, Cmd Msg)
init =
  (Model 1 1, Cmd.none)

type Msg
  = Roll1
  | Roll2
  | NewFace1 Int
  | NewFace2 Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll1 ->
      (model, Random.generate NewFace1 (Random.int 1 6))

    Roll2 ->
      (model, Random.generate NewFace2 (Random.int 1 6))

    NewFace1 newFace ->
      let
        model = { model | dieFace1 = newFace }
      in
        update Roll2 model

    NewFace2 newFace ->
      ({ model | dieFace2 = newFace }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.dieFace1) ]
    , h1 [] [ text (toString model.dieFace2) ]
    , button [ onClick Roll1 ] [ text "Roll" ]
    ]
