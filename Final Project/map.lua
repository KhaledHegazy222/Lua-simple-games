map = class {}

require 'util'
require 'player'


function map:init()
    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    

    self.tilewidth =  16
    self.tileheight =  16


    self.mapwidth = 2000
    self.mapheight = 28

    self.tiles =  {}

    self.player = player(self)
    
    self.tilesprite = GenerateQuads(self.spritesheet, self.tilewidth, self.tileheight )


    self.mapwidthpixels = self.tilewidth * self.mapwidth

    for y = 1 , self.mapheight do
        for x = 1 , self.mapwidth do 
            self:settile(x,y,4)
        end
    end

    for y = self.mapheight / 2 , self.mapheight do
        for x = 1 , self.mapwidth do
            self:settile(x,y,1)
        end
    end



    for x = 30, self.mapwidth do 
       if math.random(25) == 1 then
        
                self:settile(x,self.mapheight/2-1 ,16)        
                self:settile(x,self.mapheight/2-2 ,12)        
                self:settile(x,self.mapheight/2-3 ,8)   
        else

        end


        if math.random(20) == 1 and self:gettile(x - 1,self.mapheight / 2- 5) ~= 6 then
            self:settile(x, self.mapheight / 2 - 10, 6)
            self:settile(x+1 , self.mapheight / 2 - 10, 7)


        end
    end



end



function map:update(dt)

    self.player:update(dt)
end


function map:settile(x, y, index)

    self.tiles[ ((y-1) * self.mapwidth ) + x] = index

end

function map:gettile(x,y)
    return self.tiles[(y-1) * self.mapwidth + x]
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

