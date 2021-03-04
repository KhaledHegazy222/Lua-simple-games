player = class{}

require 'animation'
gravity = 0

function player:init(map)

    self.texture = love.graphics.newImage('graphics/mario.png')


    self.width = 32
    self.height = 64

    self.x = 5 * map.tilewidth
    self.y= (map.mapheight / 2 - 1) * map.tileheight - self.height

    self.frames = GenerateQuads(self.texture , self.width, self.height)

    self.dx = 0
    self.dy = 0
    self.state = 'start'



    self.animations = {
        ['start'] = animation{
            texture = self.texture,
            frames = {
                self.frames[1]
            },
            interval = 1
        },
        ['play'] = animation {
            texture = self.texture,
            frames = {
                self.frames[2],
                self.frames[3],
                self.frames[4]
            },
            interval = 0.15
        },
        ['jump'] = animation {
            texture = self.texture,
            frames = {
                self.frames[5]
            }
        }
    }

    self.animation = self.animations[self.state]

end


function player:render()
    love.graphics.draw(self.texture,self.animation:getcurrentframe(), self.x, self.y)
end



function player:update(dt)

    self.animation:update(dt)
    self.animation = self.animations[self.state]

end

