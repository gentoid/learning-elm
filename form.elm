import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String

main: Program Never
main =
  Html.beginnerProgram { model = model, view = view, update = update }

type alias Model =
  { name: String
  , password: String
  , passwordAgain: String
  }

model: Model
model =
  Model "" "" ""

type Msg
  = Name String
  | Password String
  | PasswordAgain String

update: Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

view: Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter password", onInput PasswordAgain ] []
    , viewValidation model
    ]

viewValidation: Model -> Html Msg
viewValidation model =
  let
    longEnough = String.length model.password >= 8
    (color, message) =
      if not longEnough then
        ("red", "Password's too short!")
      else
      if model.password == model.passwordAgain then
        ("green", "OK")
      else
        ("red", "Passwords do not match!")
  in
    div [ style [("color", color)] ] [ text message ]
