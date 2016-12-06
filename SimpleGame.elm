module Main exposing (..)

-- From evancz/graphics

import Collage exposing (..)
import Element exposing (leftAligned)
import Text exposing (..)


-- For this class

import APCS exposing (Key(..))


-- Normal imports

import Html exposing (div, button)
import Color exposing (Color)
import Mouse exposing (Position)


type alias Model =
    { time : Float
    , mode : ModeTypes
    , score : Int
    }


type ModeTypes
    = Ready
    | Playing
    | Done


type Msg
    = KeyPressed Bool Key
    | TimePassed Float
    | ButtonClicked ModeTypes


view : Model -> Html Msg
view model =
    let
        formsReady =
            [ h1 [] [ text (fromString "Press the space bar on the seconds only") ]
            , text (fromString ("Time passed: " ++ (toString model.time)))
            ]

        formsPlaying =
            [ text (fromString ("Time passed: " ++ (toString model.time))) ]

        formsDone =
            [ text (fromString ("Game over!  Final score: " ++ (toString model.score))) ]
    in
        case model.mode of
            Ready ->
                div []
                    [ Element.toHtml (collage 1200 800 formsReady)
                    , button [onClick (ButtonClicked Playing)] [ text "Start" ]
                    ]

            Playing ->
                div []
                    [ Element.toHtml (collage 1200 800 formsPlaying) ]

            Done ->
                div []
                    [ Element.toHtml (collage 1200 800 formsDone)
                    , button [onCllick (ButtonClicked Ready)] [ Html.text "Play again" ]
                    ]

update : Msg -> Model -> Model
update msg model =
    let
        buttonPressed = (buttonXmin < (model.mousePosition).first < buttonXmax) and (buttonYmin < (model.mousePosition).second < buttonYmax)
    in
        case msg of
            KeyPressed wasPressed Space ->
                { if (model.mode == Ready) (||) (model.mode = Done) then
                    model
                else
                    if toFloat(round model.time) == model.time then
                        { model | score = model.score + 1 }
                    else
                        { model | mode = Done }
                }
            TimePassed n ->
                -- This needs the real units time!!!
                { model | time = model.time + (inMilliseconds n) }
            ButtonClicked a ->
                { case a of
                    Ready ->
                        if buttonPressed then
                            { model | model.mode = Playing }
                        else
                            model
                    Playing ->
                        model
                    Done ->
                        if buttonPressed then
                            { model | model.mode = Ready, model.time = 0.0, model.score = 0}
                        else
                            model

model : Model
model = 
    { mode : Ready
    , time = 0.0
    , score = 0
    }

main =
    APCS.intermediateProgram
        { model = model
        , view = view
        , update = update
        , subscriptions = Sub.batch [ APCS.keyDowns (KeyPressed True), APCS.keyUps (KeyPressed False), APCS.frames TimePassed ]
        }
