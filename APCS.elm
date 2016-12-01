module APCS exposing (..)

import Html exposing (Html)
import Dict exposing (Dict)
import Keyboard exposing (KeyCode)
import AnimationFrame exposing (..)
import Mouse exposing (Position)
import Time exposing (Time)


intermediateProgram :
    { model : model
    , view : model -> Html msg
    , update : msg -> model -> model
    , subscriptions : Sub msg
    }
    -> Program Never model msg
intermediateProgram { model, view, update, subscriptions } =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = always subscriptions
        }


type Key
    = Cancel
    | Help
    | BackSpace
    | Tab
    | Clear
    | Enter
    | Shift
    | Control
    | Alt
    | Pause
    | CapsLock
    | Escape
    | Convert
    | NonConvert
    | Accept
    | ModeChange
    | Space
    | PageUp
    | PageDown
    | End
    | Home
    | ArrowLeft
    | ArrowUp
    | ArrowRight
    | ArrowDown
    | Select
    | Print
    | Execute
    | PrintScreen
    | Insert
    | Delete
    | Number0
    | Number1
    | Number2
    | Number3
    | Number4
    | Number5
    | Number6
    | Number7
    | Number8
    | Number9
    | Colon
    | Semicolon
    | LessThan
    | Equals
    | GreaterThan
    | QuestionMark
    | At
    | A
    | B
    | C
    | D
    | E
    | F
    | G
    | H
    | I
    | J
    | K
    | L
    | M
    | N
    | O
    | P
    | Q
    | R
    | S
    | T
    | U
    | V
    | W
    | X
    | Y
    | Z
    | Super
    | ContextMenu
    | Sleep
    | Numpad0
    | Numpad1
    | Numpad2
    | Numpad3
    | Numpad4
    | Numpad5
    | Numpad6
    | Numpad7
    | Numpad8
    | Numpad9
    | Multiply
    | Add
    | Separator
    | Subtract
    | Decimal
    | Divide
    | F1
    | F2
    | F3
    | F4
    | F5
    | F6
    | F7
    | F8
    | F9
    | F10
    | F11
    | F12
    | F13
    | F14
    | F15
    | F16
    | F17
    | F18
    | F19
    | F20
    | F21
    | F22
    | F23
    | F24
    | NumLock
    | ScrollLock
    | Circumflex
    | Exclamation
    | DoubleQuote
    | Hash
    | Dollar
    | Percent
    | Ampersand
    | Underscore
    | OpenParen
    | CloseParen
    | Asterisk
    | Plus
    | Pipe
    | HyphenMinus
    | OpenCurlyBracket
    | CloseCurlyBracket
    | Tilde
    | VolumeMute
    | VolumeDown
    | VolumeUp
    | Comma
    | Minus
    | Period
    | Slash
    | BackQuote
    | OpenBracket
    | BackSlash
    | CloseBracket
    | Quote
    | Meta
    | Altgr
    | Other


codeBook : List ( KeyCode, Key )
codeBook =
    [ ( 3, Cancel )
    , ( 6, Help )
    , ( 8, BackSpace )
    , ( 9, Tab )
    , ( 12, Clear )
    , ( 13, Enter )
    , ( 16, Shift )
    , ( 17, Control )
    , ( 18, Alt )
    , ( 19, Pause )
    , ( 20, CapsLock )
    , ( 27, Escape )
    , ( 28, Convert )
    , ( 29, NonConvert )
    , ( 30, Accept )
    , ( 31, ModeChange )
    , ( 32, Space )
    , ( 33, PageUp )
    , ( 34, PageDown )
    , ( 35, End )
    , ( 36, Home )
    , ( 37, ArrowLeft )
    , ( 38, ArrowUp )
    , ( 39, ArrowRight )
    , ( 40, ArrowDown )
    , ( 41, Select )
    , ( 42, Print )
    , ( 43, Execute )
    , ( 44, PrintScreen )
    , ( 45, Insert )
    , ( 46, Delete )
    , ( 48, Number0 )
    , ( 49, Number1 )
    , ( 50, Number2 )
    , ( 51, Number3 )
    , ( 52, Number4 )
    , ( 53, Number5 )
    , ( 54, Number6 )
    , ( 55, Number7 )
    , ( 56, Number8 )
    , ( 57, Number9 )
    , ( 58, Colon )
    , ( 59, Semicolon )
    , ( 60, LessThan )
    , ( 61, Equals )
    , ( 62, GreaterThan )
    , ( 63, QuestionMark )
    , ( 64, At )
    , ( 65, A )
    , ( 66, B )
    , ( 67, C )
    , ( 68, D )
    , ( 69, E )
    , ( 70, F )
    , ( 71, G )
    , ( 72, H )
    , ( 73, I )
    , ( 74, J )
    , ( 75, K )
    , ( 76, L )
    , ( 77, M )
    , ( 78, N )
    , ( 79, O )
    , ( 80, P )
    , ( 81, Q )
    , ( 82, R )
    , ( 83, S )
    , ( 84, T )
    , ( 85, U )
    , ( 86, V )
    , ( 87, W )
    , ( 88, X )
    , ( 89, Y )
    , ( 90, Z )
    , ( 91, Super )
    , ( 93, ContextMenu )
    , ( 95, Sleep )
    , ( 96, Numpad0 )
    , ( 97, Numpad1 )
    , ( 98, Numpad2 )
    , ( 99, Numpad3 )
    , ( 100, Numpad4 )
    , ( 101, Numpad5 )
    , ( 102, Numpad6 )
    , ( 103, Numpad7 )
    , ( 104, Numpad8 )
    , ( 105, Numpad9 )
    , ( 106, Multiply )
    , ( 107, Add )
    , ( 108, Separator )
    , ( 109, Subtract )
    , ( 110, Decimal )
    , ( 111, Divide )
    , ( 112, F1 )
    , ( 113, F2 )
    , ( 114, F3 )
    , ( 115, F4 )
    , ( 116, F5 )
    , ( 117, F6 )
    , ( 118, F7 )
    , ( 119, F8 )
    , ( 120, F9 )
    , ( 121, F10 )
    , ( 122, F11 )
    , ( 123, F12 )
    , ( 124, F13 )
    , ( 125, F14 )
    , ( 126, F15 )
    , ( 127, F16 )
    , ( 128, F17 )
    , ( 129, F18 )
    , ( 130, F19 )
    , ( 131, F20 )
    , ( 132, F21 )
    , ( 133, F22 )
    , ( 134, F23 )
    , ( 135, F24 )
    , ( 144, NumLock )
    , ( 145, ScrollLock )
    , ( 160, Circumflex )
    , ( 161, Exclamation )
    , ( 162, DoubleQuote )
    , ( 163, Hash )
    , ( 164, Dollar )
    , ( 165, Percent )
    , ( 166, Ampersand )
    , ( 167, Underscore )
    , ( 168, OpenParen )
    , ( 169, CloseParen )
    , ( 170, Asterisk )
    , ( 171, Plus )
    , ( 172, Pipe )
    , ( 173, HyphenMinus )
    , ( 174, OpenCurlyBracket )
    , ( 175, CloseCurlyBracket )
    , ( 176, Tilde )
    , ( 181, VolumeMute )
    , ( 182, VolumeDown )
    , ( 183, VolumeUp )
    , ( 186, Semicolon )
    , ( 187, Equals )
    , ( 188, Comma )
    , ( 189, Minus )
    , ( 190, Period )
    , ( 191, Slash )
    , ( 192, BackQuote )
    , ( 219, OpenBracket )
    , ( 220, BackSlash )
    , ( 221, CloseBracket )
    , ( 222, Quote )
    , ( 224, Meta )
    , ( 225, Altgr )
    ]


codeDict : Dict KeyCode Key
codeDict =
    Dict.fromList codeBook


toKey : KeyCode -> Key
toKey code =
    codeDict
        |> Dict.get code
        |> Maybe.withDefault Other


keyDowns : (Key -> msg) -> Sub msg
keyDowns m =
    Keyboard.downs (m << toKey)


keyUps : (Key -> msg) -> Sub msg
keyUps m =
    Keyboard.ups (m << toKey)


keyPresses : (Key -> msg) -> Sub msg
keyPresses m =
    Keyboard.presses (m << toKey)


mouseDowns : (Position -> msg) -> Sub msg
mouseDowns =
    Mouse.downs


mouseUps : (Position -> msg) -> Sub msg
mouseUps =
    Mouse.ups


mouseClicks : (Position -> msg) -> Sub msg
mouseClicks =
    Mouse.clicks


mouseMoves : (Position -> msg) -> Sub msg
mouseMoves =
    Mouse.moves


frames : (Time -> msg) -> Sub msg
frames =
    AnimationFrame.diffs
