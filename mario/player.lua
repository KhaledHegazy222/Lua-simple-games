player = class{}


require 'animation'

local move_speed = 80
local jump_velocity = 400
local gravity = 40

function player:init(map)

    self.width = 16
    self.height = 20
    self.x = map.tilewidth * 10
    self.y = (map.tileheight) * (map.mapheight / 2 - 1) - self.height 

    self.dx = 0
    self.dy = 0

    self.map = map
    self.texture = love.graphics.newImage('graphics/blue_alien.png')
    self.frames = GenerateQuad(self.texture, self.width, self.height)


    self.state = 'idle'
    self.direction = 'right'

    self.animations = {
        ['idle'] = animation{
            texture = self.texture,
            frames = {
                self.frames[1]
            },
            interval = 1
        },
        ['walking'] = animation {
            texture = self.texture,
            frames = {
                self.frames[9],
                self.frames[10],
                self.frames[11]
            },
            interval = 0.15
        },
        ['jumping'] = animation{
            texture = self.texture,
            frames = {
                self.frames[3]
            },
            interval = 1
            
        }
    }

    self.animation = self.animations['idle']

    self.behaviors = {
        ['idle'] = 
            function (dt)
                if love.keyboard.wasDown('w') then
                    self.dy = -jump_velocity
                    self.state = 'jumping'
                    self.animation = self.animations['jumping'] 
                    
                
                elseif love.keyboard.isDown('a') then
                    self.dx = -move_speed
                    self.direction = 'left'
                    self.animation = self.animations['walking']
                elseif love.keyboard.isDown('d') then
                    self.dx =  move_speed
                    self.direction = 'right'
                    self.animation = self.animations['walking']
                else
                    self.animation = self.animations['idle']
                    self.dx = 0

                end
            end

        ,

        ['walking'] =
            function(dt)
                if love.keyboard.isDown('w') then
                    self.dy = -jump_velocity
                    self.state = 'jumping'
                    self.animation = self.animations['jumping'] 
                    
                
                elseif love.keyboard.isDown('a') then                  
                    self.dx = -move_speed
                    self.direction = 'left'
                    self.animation = self.animations['walking']

                elseif love.keyboard.isDown('d') then
                    self.dx = move_speed
                    self.direction = 'right'
                    self.animation = self.animations['walking']

                else 
                    self.animation = self.animations['idle']
                    self.dx = 0



                end



                self:checkrightcollision()
                self:checkleftcollision()

                if not map:collides(map:tileat(self.x, self.y + self.height)) and
                    not map:collides(map:tileat(self.x + self.width - 1, self.y + self.height)) then

                        self.state = 'jumping'
                        self.animation = self.animations['jumping']
                end







            end

        ,
        ['jumping'] = 
            function (dt)
                if love.keyboard.isDown('a') then                  
                    self.dx = -move_speed
                    self.direction = 'left'

                elseif love.keyboard.isDown('d') then
                    self.dx = move_speed
                    self.direction = 'right'

                else 
                    self.animation = self.animations['idle']

                end

                self.dy =  self.dy + gravity
               


                if map:collides(map:tileat(self.x , self.y + self.height)) or
                    map:collides(map:tileat(self.x + self.width -1 , self.y + self.height)) then

                        self.dy = 0
                        self.y = (map.tileheight) * (map.mapheight / 2 - 1) - self.height 
    
                        self.state = 'idle'
                        self.animation = self.animations['idle']


                end

            end

        
    }

end



function player:update(dt)

    self.behaviors[self.state](dt)
    self.animation:update(dt)
    --self.currentframe = self.animation:getcurrentframe()
    self.x = self.x + self.dx * dt


    self.y = self.y + self.dy * dt


    if self.dy < 0 then
        if map:tileat(self.x ,self.y) ~= EmptyTile or
        map:tileat(self.x + self.width - 1,self.y) ~= EmptyTile then
            self.dy = 0


            if map:tileat(self.x,self.y) == JumbBlock then
             map:settile(math.floor(self.x/map.tilewidth)+1,
                math.floor(self.y/map.tileheight) + 1,9)
            end

            if map:tileat(self.x + self.width - 1 ,self.y + self.height -1) == JumbBlock then
                map:settile(math.floor((self.x + self.width - 1 )/map.tilewidth)+1,
                math.floor((self.y + self.height -1)/map.tileheight) + 1,9)
            end
        end
    end
            
end



function player:render()
    local scaleX
    if self.direction == 'right' then 
        scaleX = 1
    else
        scaleX = -1
    end

    love.graphics.draw(self.texture,self.animation:getcurrentframe(), self.x + self.width / 2 , self.y+ self.height/2 ,
        0, scaleX, 1,
        self.width / 2, self.height/2)

end







function player:checkleftcollision()
    if self.dx < 0 then

        if map:collides(map:tileat(self.x -1 ,self.y)) or
        map:collides(map:tileat(self.x - 1 , self.y + self.height -1)) then
            self.dx = 0
            --self.x = map:tileat(self.x - 1 ,self.y + self.height) * map.tilewidth
        end

    end


end