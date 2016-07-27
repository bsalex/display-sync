port module App exposing (..)

import ColorSync
import Html exposing (Html, div)
import Html.App

type alias AppModel =
    { colorSyncModel : ColorSync.Model }

initialModel : AppModel
initialModel =
    { colorSyncModel = ColorSync.initialModel }

init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )

type Msg
  = ColorSyncMsg ColorSync.Msg
  | ChangeColorFromPort (String)

view : AppModel -> Html Msg
view model =
    Html.App.map ColorSyncMsg (ColorSync.view model.colorSyncModel)

update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case message of
        ChangeColorFromPort newColor ->
            ( model, Cmd.none )

        ColorSyncMsg subMsg ->
            let
                ( updatedColorSyncModel, colorSyncCmd ) =
                    ColorSync.update subMsg model.colorSyncModel
            in
                ( { model | colorSyncModel = updatedColorSyncModel }, Cmd.map ColorSyncMsg colorSyncCmd )

port changeColor : (String -> msg) -> Sub msg

subscriptions : AppModel -> Sub Msg
subscriptions model =
    changeColor ChangeColorFromPort

main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
