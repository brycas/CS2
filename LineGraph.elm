module Main exposing (..)

-- From evancz/graphics

import Collage exposing (..)
import Text exposing (..)
import Element exposing (leftAligned)


-- Normal imports

import Html exposing (Html, div)
import Color exposing (Color)


-- import Mouse exposing (Position)


type alias DataPoint =
    { x : Float, y : Float }



{- You are guaranteed that each `x` value will only appear at most once in the following list. -}


data : List DataPoint
data =
    [ DataPoint -2 5.5
    , DataPoint 3 10
    , DataPoint 6 -1
    , DataPoint 8 20
    , DataPoint 5 2
    , DataPoint 7 4
    ]



{-
   -2 5.5
   3 10
   5 2
   6 -1
   7 4
   8 20

-}


height : Float
height =
    500


width : Float
width =
    500



{- Change `view` to show a line graph. The line graph should:
   - Use the space well. Choose good scales for the axes.
     In the sample data, the x axis should probably go from -5 to 10 or 11,
     because the lowest x value is -2 and the highest is 8. Similarly, the
     y axis should probably go from -5 to 25 or so.
   - Draw the axes: two lines, a horizontal one at y = 0 and a vertical one at x = 0
   - Draw a line connecting each consecutive pair of data points.
       By "consecutive," I do NOT mean next to each other in the original list,
       but rather next to each other on the x axis. You should probably sort
       the data points by x value.
   - Hint: use documentation! Go to package.elm-lang.org. You will find that the
     Collage module has functions for drawing paths consisitng of a list of points :-)
     There are also ways to sort lists easily.
-}


myCircle : Float -> Float -> Float -> Color -> Form
myCircle x y r color =
    (filled color (circle r))
        |> moveX x
        |> moveY y


view : Html a
view =
    let
        height1 =
            height - 25

        width1 =
            width - 25

        getX datapoint =
            datapoint.x

        getY datapoint =
            datapoint.y

        xMin =
            Maybe.withDefault 0 (List.minimum (List.map getX data))

        yMin =
            Maybe.withDefault 0 (List.minimum (List.map getY data))

        xMax =
            Maybe.withDefault 0 (List.maximum (List.map getX data))

        yMax =
            Maybe.withDefault 0 (List.maximum (List.map getY data))

        toPointPartial thing =
            toPoint thing xMin yMin xMax yMax

        pts =
            List.sort (List.map toPointPartial data)

        xAxis =
            filled Color.black (rect (2 * width1) 5)
                |> moveY (properCord yMin yMax height1)

        yAxis =
            filled Color.black (rect 5 (2 * height1))
                |> moveX (properCord xMin xMax width1)

        properCord : Float -> Float -> Float -> Float
        properCord min max scale =
            if False then
                -(scale / 2)
            else if False then
                scale / 2
            else
                -min * scale / (max - min) - scale / 2

        line =
            traced (solid Color.black) (path pts)

        displayedPt : ( Float, Float ) -> Form
        displayedPt pt =
            myCircle (Tuple.first pt) (Tuple.second pt) 5 Color.black

        displayedPts =
            List.map displayedPt pts

        labels =
            [ text (fromString (toString xMax))
                |> moveX (width1 / 2)
                |> moveY ((properCord yMin yMax height1) + 10)
            , text (fromString (toString xMin))
                |> moveX (-width1 / 2)
                |> moveY ((properCord yMin yMax height1) + 10)
            , text (fromString (toString yMax))
                |> moveX ((properCord xMin xMax width1) + 10)
                |> moveY (height1 / 2)
            , text (fromString (toString yMin))
                |> moveX ((properCord xMin xMax width1) + 10)
                |> moveY (-height1 / 2)
            ]

        forms : List Form
        forms =
            [ xAxis
            , yAxis
            , line
            , group displayedPts
            , outlined (solid Color.red) (rect width1 height1)
            , group labels
            ]

        toLocationX : DataPoint -> Float -> Float -> Float
        toLocationX datapoint xMin xMax =
            if xMin > 0 then
                ((datapoint.x * width1) / xMax) - width1 / 2
            else if xMax < 0 then
                -1 * (((datapoint.x * width1) / xMin) - width1 / 2)
            else
                (datapoint.x - xMin) * width1 / (xMax - xMin) - width1 / 2

        toLocationY : DataPoint -> Float -> Float -> Float
        toLocationY datapoint yMin yMax =
            if yMin > 0 then
                ((datapoint.y * height1) / yMax) - height1 / 2
            else if yMax < 0 then
                -1 * (((datapoint.y * height1) / yMin) - height1 / 2)
            else
                (datapoint.y - yMin) * height1 / (yMax - yMin) - height1 / 2

        toPoint : DataPoint -> Float -> Float -> Float -> Float -> ( Float, Float )
        toPoint datapoint xMin yMin xMax yMax =
            ( (toLocationX datapoint xMin xMax), (toLocationY datapoint yMin yMax) )
    in
        div []
            [ Element.toHtml (collage (round width) (round height) forms)
            ]


main : Html a
main =
    view
