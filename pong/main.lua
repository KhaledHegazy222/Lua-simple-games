








-- ===========================>      Constants      <=========================== --             






WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 244

score1 = 0
score2 = 0



state = 'start'


PaddleSpeed = 200

push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'


paddle1 = Paddle(5,30,5,20)
paddle2 = Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-50,5,20)

ball = Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,4,4)




servingplayer = math.random(2) == 1 and 1 or 2

if servingplayer == 1 then
  ball.dx = 100
else
  ball.dx = -100
end



-- ===========================>       Controls      <=========================== --             

function love.keypressed(key)


  if key == 'escape' then
    love.event.quit()



  elseif key == 'enter' or key == 'return' then
    

    if state == 'start' then 
      state = 'serve'
      ball:reset()

    elseif state == 'serve' then
      state = 'play'

    elseif state == 'victory'  then
      score1 = 0
      score2 = 0
      state = 'start'
    end


    
  end

end








-- ===========================>      The Load Function      <=========================== --             

function love.load()

    math.randomseed(os.time())
    love.window.setTitle("Pong")



-- ===========================>      Fonts        <=========================== --             

    smallfont = love.graphics.newFont('font.ttf',8)
    largefont = love.graphics.newFont('font.ttf',20)
    victoryfont = love.graphics.newFont('font.ttf',24)


    sounds = {
      ['paddle'] = love.audio.newSource('paddle.wav','static'),
      ['point'] = love.audio.newSource('point.wav','static'),
      ['win'] = love.audio.newSource('win.wav','static'),
      ['wall'] = love.audio.newSource('wall.wav','static'),
      
    }



    love.graphics.setDefaultFilter('nearest','nearest')
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT, WINDOW_WIDTH , WINDOW_HEIGHT , {
      fullscreen = false,
      vsync = true ,
      resizable = true
    })

end






function love.resize(width, height)
  push:resize(width,height)


end












-- ===========================>      The Updte Function      <=========================== --             
function love.update(dt)

  paddle1:update(dt)
  --paddle2:update(dt)
  paddle2.y = math.min(VIRTUAL_HEIGHT-20,ball.y)


  if ball.x <= -4 then
    ball:reset()
    score2 = score2 + 1
    state = 'serve'
    servingplayer = 1
    ball.dx = 100
    sounds['point']:play()

  end

  if ball.x >= VIRTUAL_WIDTH then
    ball:reset()
    score1 = score1 + 1
    state = 'serve'
    servingplayer = 2
    ball.dx = -100
    sounds['point']:play()

  end







  if ball:collides(paddle1) or  ball:collides(paddle2) then
    ball.dx = math.min(-ball.dx * 1.5,ball.dx < 0 and 300 or -300)

    sounds['paddle']:play()

  end



  if ball.y <= 0 then
    ball.dy = -ball.dy
    ball.y = 0
    sounds['wall']:play()

  end

  if ball.y >= VIRTUAL_HEIGHT- 4 then
    ball.dy = -ball.dy
    ball.y = VIRTUAL_HEIGHT - 4
    sounds['wall']:play()


  end




if score1 == 2 or score2 == 2 then 
  state = 'victory'
  sounds['win']:play()


end



  if love.keyboard.isDown('w') then
      paddle1.dy = -PaddleSpeed
  elseif love.keyboard.isDown('s') then 
      paddle1.dy = PaddleSpeed
  else
    paddle1.dy = 0
  end



  if love.keyboard.isDown('up') then
      paddle2.dy = -PaddleSpeed
  elseif love.keyboard.isDown('down') then 
      paddle2.dy = PaddleSpeed
  else
      paddle2.dy = 0
  end



    if state == 'play' then
      ball:update(dt)
    end




end












-- ===========================>      The Draw Function      <=========================== --             

function love.draw()
  push:apply('start')
  
    love.graphics.clear(40/255,45/255,52/255,1)

    -- ===============>    The Ball    <=============== --
    ball:render()

    -- ===============>    The Two Boards    <=============== --
    paddle1:render()
    paddle2:render()

    -- ===============>    Tge Name Of The Game    <=============== --
    love.graphics.setFont(smallfont)
    if state == 'start' then
      love.graphics.printf("Welcome To Pong!",0,20,VIRTUAL_WIDTH,'center') 
      love.graphics.printf("press enter to start!",0,30,VIRTUAL_WIDTH,'center') 
    elseif state == 'serve'  then
      love.graphics.printf("Player " .. tostring(servingplayer) .. "'s Turn",0,20,VIRTUAL_WIDTH,'center') 
      love.graphics.printf("Press Enter To Serve",0,30,VIRTUAL_WIDTH,'center')
    elseif state == 'victory' then
      love.graphics.setFont(victoryfont)
      love.graphics.printf("Player"..tostring(servingplayer==1 and 2 or 1) .. " Wins",0,20,VIRTUAL_WIDTH,'center')

      love.graphics.setFont(smallfont)
      love.graphics.printf("press enter to start!",0,50,VIRTUAL_WIDTH,'center') 

    end
    -- ===============>    The Score Of The Two Player    <=============== --
    love.graphics.setFont(largefont)
    love.graphics.print(score1,VIRTUAL_WIDTH/2-45,VIRTUAL_HEIGHT/3)
    love.graphics.print(score2,VIRTUAL_WIDTH/2+30,VIRTUAL_HEIGHT/3)



    displayFPS()

    love.graphics.setFont(smallfont)

    love.graphics.printf("Created by: Khaled Hegazy",0,VIRTUAL_HEIGHT-10,VIRTUAL_WIDTH-20,'right')
    

  push:apply('end')
end








function displayFPS()

  love.graphics.setColor(0,1,0,1)
  love.graphics.setFont(smallfont)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),20,10)
  love.graphics.setColor(1,1,1,1)
  
end