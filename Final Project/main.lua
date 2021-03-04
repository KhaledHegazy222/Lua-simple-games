WindowWidth = 1280
WindowHeight = 720

VirtualWidth = 432
VirtualHeight = 243


push = require'push'
class = require 'class'

require'map'

score = 0
gravity = 60
jumpspeed = 600

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key =='return'  then

        if map.player.state == 'start' then


            map.player.dx = 200
            map.player.state = 'play'

        elseif map.player.state == 'end' then
            map.player.x = 5 * map.tilewidth
            map.player.y= (map.mapheight / 2 - 1) * map.tileheight - map.player.height
            map.player.state = 'start'
            score = 0
        end

    elseif key == 'w' then
        if map.player.state == 'play' then
            sounds['jump']:play()
            map.player.animation = map.player.animations['jump']
            map.player.dy = -jumpspeed
            map.player.state = 'jump'
        end

    end


end 


















function love.load ()
    math.randomseed(os.time() )
    love.window.setTitle("Mario Jump")

    push:setupScreen(VirtualWidth, VirtualHeight, WindowWidth, WindowHeight, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })


    map = map()



    small = love.graphics.newFont('fonts/font.ttf',8)
    normal =  love.graphics.newFont('fonts/font.ttf',15)



    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['play'] = love.audio.newSource('sounds/music.wav', 'static')
    }






end



function love.update(dt)
    map:update(dt)

    map.player.x = map.player.x + map.player.dx * dt
    map.player.y = map.player.y + map.player.dy * dt

    if map.player.y >= (map.mapheight / 2 - 1) * map.tileheight - map.player.height then
        map.player.y = (map.mapheight / 2 - 1) * map.tileheight - map.player.height
        map.player.dy = 0
        if map.player.state == 'jump' then
            map.player.state = 'play'
    
            map.player.animation = map.player.animations['play']
        end
    end

        map.player.dy = map.player.dy + gravity 

    if map:gettile(math.floor((map.player.x + 32) / map.tilewidth),math.floor( (map.player.y+54) / map.tileheight)) == 16 or
    map:gettile(math.floor((map.player.x + 32) / map.tilewidth),math.floor( (map.player.y + 54) / map.tileheight)) == 12 or 
    map:gettile(math.floor((map.player.x + 32) / map.tilewidth),math.floor( (map.player.y + 54 )/ map.tileheight)) == 8 then
        map.player.dx = 0
        map.player.state = 'end'
        map.player.animation = map.player.animations['start']
        sounds['hit']:play()

    end

    if map.player.state == 'play' then
        map.player.dx = map.player.dx  + 10 * dt
    end
    if map.player.state == 'start' then
        sounds['play']:play()
    end

    


    if map:gettile(math.floor( map.player.x / map.tilewidth),  math.floor( (map.mapheight/2 - 1 )) ) == 16 then
        score = score + 0.5
    end
end



function love.draw()
    push:apply('start')

    love.graphics.clear(116/255,219/255,224/255,1)
    love.graphics.setFont(normal)


    if map.player.state == 'start' then
        love.graphics.setColor(1,1,1,1)

        love.graphics.printf("Welcome to Mario Jump",0 , 30 , VirtualWidth , 'center')
        love.graphics.printf("Press Enter to start",0 , VirtualHeight / 2 , VirtualWidth , 'center')

    elseif map.player.state == 'end' then
        love.graphics.setColor(1,0,0,1)

        love.graphics.printf("Game Over",0 , 30 , VirtualWidth , 'center')
        love.graphics.printf("Press Enter to restart",0 , VirtualHeight / 2 , VirtualWidth , 'center')

    end
    love.graphics.setColor(1,1,1,1)

    love.graphics.translate(math.floor(-map.player.x + 80),0)
    map:render()
    love.graphics.setColor(1,0,0,1)

    love.graphics.printf("Score: ",map.player.x - 70 ,20,VirtualWidth, 'left')
    love.graphics.print(math.floor(score), map.player.x - 20, 20)
    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(small)
    love.graphics.printf("Created By: Khaled Hegazy", map.player.x - 90 , 220, VirtualWidth, 'right')

    push:apply('end')

end

