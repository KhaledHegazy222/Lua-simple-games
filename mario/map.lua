map = class{}

BrickTile = 1
EmptyTile = 4


CloudLeft = 6
CloudRight = 7

BushLeft = 2
BushRight = 3

MushroomTop = 10
MushroomBottom = 11

JumbBlock = 5

require'util'

require 'player'

local scrollspeed = 62
 
function map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tilewidth =  16
    self.tileheight =  16
    self.mapwidth = 30
    self.mapheight = 28
    self.tiles =  {}


    self.camX = 0
    self.camY = 0

    self.mapwidthpixel = self.mapwidth * self.tilewidth
    self.mapheightpixel = self.mapheight * self.tileheight
    
    self.tilesprite = GenerateQuad(self.spritesheet, self.tilewidth, self.tileheight )


    self.player = player(self)

    for y = 1 , self.mapheight do
        for x = 1 , self.mapwidth do 
            self:settile(x,y,EmptyTile)
        end
    end





    local x = 1
    while x < self.mapwidth do
        
        -- 2% chance to generate a cloud
        -- make sure we're 2 tiles from edge at least
        if x < self.mapwidth - 2 then
            if math.random(20) == 1 then
                
                -- choose a random vertical spot above where blocks/pipes generate
                local cloudStart = math.random(self.mapheight / 2 - 6)

                self:settile(x, cloudStart, CloudLeft)
                self:settile(x + 1, cloudStart, CloudRight)
            end
        end

        -- 5% chance to generate a mushroom
        if math.random(20) == 1 then
            -- left side of pipe
            self:settile(x, self.mapheight / 2 - 2, MushroomTop)
            self:settile(x, self.mapheight / 2 - 1, MushroomBottom)

            -- creates column of tiles going to bottom of map
            for y = self.mapheight / 2, self.mapheight do
                self:settile(x, y, BrickTile)
            end

            -- next vertical scan line
            x = x + 1

        -- 10% chance to generate bush, being sure to generate away from edge
        elseif math.random(10) == 1 and x < self.mapwidth - 3 then
            local bushLevel = self.mapheight / 2 - 1

            -- place bush component and then column of bricks
            self:settile(x, bushLevel, BushLeft)
            for y = self.mapheight / 2, self.mapheight do
                self:settile(x, y, BrickTile)
            end
            x = x + 1

            self:settile(x, bushLevel, BushRight)
            for y = self.mapheight / 2, self.mapheight do
                self:settile(x, y, BrickTile)
            end
            x = x + 1

        -- 10% chance to not generate anything, creating a gap
        elseif math.random(10) ~= 1 then
            
            -- creates column of tiles going to bottom of map
            for y = self.mapheight / 2, self.mapheight do
                self:settile(x, y, BrickTile)
            end

            -- chance to create a block for Mario to hit
            if math.random(15) == 1 then
                self:settile(x, self.mapheight / 2 - 4, JumbBlock)
            end

            -- next vertical scan line
            x = x + 1
        else
            -- increment X so we skip two scanlines, creating a 2-tile gap
            x = x + 2
        end
    end

    



end


function map:settile(x, y, index)

    self.tiles[ ((y-1) * self.mapwidth ) + x] = index

end

function map:gettile(x,y)
    return self.tiles[(y-1) * self.mapwidth + x]
end


function map:tileat(x,y)
    return self:gettile(math.floor(x/self.tilewidth) + 1 , math.floor(y/self.tileheight) + 1 )
end


function map:collides(tile)
    local collidables = {
        BrickTile,
        MushroomTop,
        MushroomBottom
    }

    for _,v in ipairs(collidables) do 
        if tile == v then
            return true
        end
    end
    return false

end




function map:update(dt)
    
    self.camX = math.max(0,
        math.min(self.player.x - VirtualWidth / 2,
            math.min( self.mapwidthpixel - VirtualWidth, self.player.x)))
    
    

    self.player:update(dt)

end


function map:render()
    for y = 1 ,  self.mapheight do
        for x = 1 , self.mapwidth do 
            love.graphics.draw(self.spritesheet, self.tilesprite[self:gettile(x,y)],
               (x-1) * self.tilewidth  ,  (y-1) * self.tileheight ) 

        end
    end



    self.player:render()
end