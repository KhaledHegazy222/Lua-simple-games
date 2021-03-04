-- ===============================> Constants <=============================== --


WindowWidth = 1280
WindowHeight = 720


VirtualWidth = 432
VirtualHeight = 243


push = require 'push'
class = require 'class'


require 'map'









function love.keypressed(key) 
    
    if key == 'escape' then 
        love.event.quit()

    end

    love.keyboard.keyspressed[key] = true


end









-- ===============================> Load Function <=============================== --

function love.load()

    math.randomseed(os.time())

    map = map()

    love.graphics.setDefaultFilter('nearest','nearest')

    push:setupScreen(VirtualWidth, VirtualHeight, WindowWidth, WindowHeight, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })


    love.keyboard.keyspressed = {}

end





-- ===============================> Update Function <=============================== --

function love.update(dt)
    map:update(dt)

    love.keyboard.keyspressed = {}




end




function love.keyboard.wasDown(key)
    return love.keyboard.keyspressed[key]

end



-- ===============================> Draw Function <=============================== --

function love.draw()
    push:apply('start')
    love.graphics.clear(108/255, 140/255, 1,1)

    love.graphics.translate(math.floor(-map.camX),math.floor(-map.camY))

    --love.graphics.print("Welcome To Mario")
    map:render( )

    push:apply('end')
end



