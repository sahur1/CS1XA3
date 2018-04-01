module ShootingFun exposing (..)

import Html as Html
import Window
import Platform.Cmd as Cmd
import Platform.Sub as Sub
import Html.Attributes exposing (style)
import Keyboard as Key
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time as Time

{- Main -}
main : Program Never Game Msg
main = Html.program
      {init = (init,initCmds)
      ,update = update
      ,view = view
      ,subscriptions =subscriptions }

type alias Game = {
                   dimensions : Window.Size
                  ,position : Coords
                  ,monsters : List Coords
                  ,isDead : Bool
                  ,direction : Direction
                  ,previousDirection: Direction
                  ,blockSize : Float
                  ,bulletPosition : Coords
                  ,momentumSpeedCounter : Int
                  ,bulletMove : Bool
                  ,bulletFire : Bool
                  }

type Direction = Left | Right | NoDirection

type alias Coords = {x : Int, y : Int}

type Msg
    = KeyMsg Key.KeyCode
    | SizeUpdated Window.Size
    | Tick Time.Time
    | Nothing

init = ({   dimensions = Window.Size 0 0,
            position = {x = 380, y = 380},
            monsters = [{x = 80, y = 50},{x = 110, y = 50},{x = 140, y = 50},{x = 170, y = 50},{x = 200, y = 50},{x = 230, y = 50},{x = 260, y = 50},{x = 290, y = 50}],
            direction = NoDirection,
            previousDirection = NoDirection,
            isDead = False,
            blockSize = 0,
            momentumSpeedCounter = 0,
            bulletPosition = {x = 404, y = 391},
            bulletMove = False,
            bulletFire = True})

update : Msg -> Game -> (Game,Cmd.Cmd Msg)
update msg model = case msg of
        KeyMsg keyCode ->
            (keyCode, model)
            |> movePos
            |> fire

        SizeUpdated dimensions ->
            ({ model | dimensions = dimensions }, Cmd.none )

        Nothing -> (model, Cmd.none)

        Tick time ->
            updateGame (model, Cmd.none)

movePos : (Int, Game) -> (Int, Game, Cmd.Cmd Msg)
movePos (keyCode, model) =
    case keyCode of
      65 -> (keyCode, { model | previousDirection = model.direction, direction = Left, momentumSpeedCounter = -4}, Cmd.none)
      68 -> (keyCode, { model | previousDirection = model.direction, direction = Right, momentumSpeedCounter = 4}, Cmd.none)
      _ -> (keyCode, model, Cmd.none)

fire : (Int, Game, Cmd.Cmd Msg) -> (Game, Cmd.Cmd Msg)
fire (keyCode, model, cmd) =
  if ((keyCode == 32) && (model.bulletFire)) then ({ model | bulletMove = True, bulletFire = False, bulletPosition = {x = model.position.x + 24, y = model.position.y}}, Cmd.none)
  else (model, Cmd.none)

movBpos : (Game , Cmd Msg ) -> ( Game , Cmd Msg )
movBpos ( model, cmd) =
  if (model.bulletMove == True) && (model.bulletFire == False)
    then ( { model | bulletPosition = {x = model.bulletPosition.x, y = model.bulletPosition.y - 15}}, Cmd.none)
  else ( model, Cmd.none)

bulletReset : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
bulletReset ( model, cmd ) =
  if model.bulletPosition.y < 0 then ({ model | bulletMove = False, bulletFire = True}, Cmd.none)
  else (model, Cmd.none)

updateGame : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
updateGame ( model, cmd ) =
        ( model, cmd )
            |> blockSize
            |> momentum
            |> updateDirection
            |> bulletReset
            |> outOfScreen
            |> movBpos
            |> bulletReset

blockSize : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
blockSize ( model, cmd ) =
    ( { model | blockSize = (toFloat (winWidth model.dimensions))/800.0}, Cmd.none)


updateDirection : ( Game , Cmd Msg ) -> ( Game , Cmd Msg )
updateDirection ( model , cmd )= ({ model | previousDirection = model.direction, direction = model.direction }, Cmd.none)


momentum : ( Game , Cmd Msg ) -> ( Game , Cmd Msg )
momentum ( model , cmd ) =
    let
        reset =         if model.previousDirection == model.direction then model.momentumSpeedCounter
                        else 0
        moreSpeed =
                        if ((model.momentumSpeedCounter > -8) && (model.momentumSpeedCounter < 8)) then
                            if model.direction == Left then -1
                            else 1
                        else 0

        newCounter = reset + moreSpeed
        speed = speedConversion model
    in

        if model.direction == Left then
            ({ model | position = { x = model.position.x - speed, y = model.position.y}, momentumSpeedCounter = newCounter}, Cmd.none)
        else if model.direction == Right then
            ({ model | position = { x = model.position.x + speed, y = model.position.y}, momentumSpeedCounter = newCounter}, Cmd.none)
        else ({ model | position = { x = model.position.x, y = model.position.y } }, Cmd.none)

speedConversion : Game -> Int
speedConversion model =
    if model.momentumSpeedCounter == -7 then 3
    else if model.momentumSpeedCounter == -6 then 6
    else if model.momentumSpeedCounter == -5 then 9
    else if model.momentumSpeedCounter == -4 then 9
    else if model.momentumSpeedCounter == -3 then 9
    else if model.momentumSpeedCounter == -2 then 6
    else if model.momentumSpeedCounter == -1 then 3
    else if model.momentumSpeedCounter == 0 then 0
    else if model.momentumSpeedCounter == 1 then 3
    else if model.momentumSpeedCounter == 2 then 6
    else if model.momentumSpeedCounter == 3 then 9
    else if model.momentumSpeedCounter == 4 then 9
    else if model.momentumSpeedCounter == 5 then 9
    else if model.momentumSpeedCounter == 6 then 6
    else if model.momentumSpeedCounter == 7 then 3
    else 0

drawMonster : Coords -> Svg Msg
drawMonster coord =
  let
    mimage = "./monster.png"
    posX = toString (toFloat coord.x * model.blockSize)
    posY = toString (toFloat coord.y * model.blockSize)
  in
    [image [x posX ,y posY, width (toString(50*bs)), height (toString(50*bs)), Svg.Attributes.xlinkHref mimage] []]


scale : Window.Size -> ( String, String )
scale size =
    let
        toPixelStr =
            \i -> round i |> toString

        ( fWidth, fHeight ) =
            ( toFloat size.width, toFloat size.height )

        ( scaledX, scaledY ) =
            if fWidth > fHeight then
                ( fHeight / fWidth, 1.0 )
            else
                ( 1.0, fWidth / fHeight )
    in
        ( toPixelStr (fWidth * scaledX), toPixelStr (fHeight * scaledY) )

winWidth : Window.Size -> Int
winWidth size = size.width


outOfScreen : ( Game , Cmd Msg ) -> ( Game , Cmd Msg )
outOfScreen ( model , cmd ) =
        if model.position.x > 700 then
            ({ model | position = { x = 700, y = model.position.y} }, Cmd.none)
        else if model.position.x < 50 then
            ({ model | position = { x = 50, y = model.position.y} }, Cmd.none)
        else ({ model | position = { x = model.position.x, y = model.position.y } }, Cmd.none)

backgroundColor : Attribute Msg
backgroundColor =
    fill "Black"

view : Game -> Html.Html Msg
view model = let
        posX = toString (toFloat model.position.x * model.blockSize)
        posY = toString (toFloat model.position.y * model.blockSize)
        posBX = toString (toFloat model.bulletPosition.x * model.blockSize)
        posBY = toString (toFloat model.bulletPosition.y * model.blockSize)
        ( scaledWidth, scaledHeight ) = scale model.dimensions
        bs = model.blockSize
        pimage = "./player.png"
        mimage = "./monster.png"

    in
        if model.isDead == False then
            svg [width "100%",height "100%"]
              ([ renderBackground model ]
              ++ [monster model]
              ++ [rect [x posBX,y posBY, width (toString(2*bs)), height (toString(10*bs)), fill "red"] []]
              ++ [image [x posX, y posY, width (toString(50*bs)), height (toString(50*bs)), Svg.Attributes.xlinkHref pimage][]]
              ++ [image [x (toString (model.monsters.x)) ,y (toString (model.monsters.y)), width (toString(50*bs)), height (toString(5 0*bs)), Svg.Attributes.xlinkHref mimage] []]
              ++ fmap drawMonster monsters
              )

        else
            svg [width "0%",height "0%"]
              (
              [rect [x "posX",y "posY", width "50", height "50", fill "red"] []])

renderBackground : Game -> Svg Msg
renderBackground model =
    rect [ x "0", y "0", width "100%", height "100%", backgroundColor] []

subscriptions : Game -> Sub Msg
subscriptions model =
    Sub.batch [windowDimensionsChanged, Key.downs KeyMsg, tick]

initCmds : Cmd Msg
initCmds =
    Task.perform SizeUpdated Window.size

windowDimensionsChanged : Sub Msg
windowDimensionsChanged =
    Window.resizes SizeUpdated

tick : Sub Msg
tick =
    Time.every (33*Time.millisecond) Tick
