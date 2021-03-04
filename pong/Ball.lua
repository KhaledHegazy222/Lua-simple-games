Ball = Class{}

function Ball:init(x, y, width, height)

    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = math.random(-50,50)


end


function Ball:reset()
    self.x = VIRTUAL_WIDTH/2 -2
    self.y = VIRTUAL_HEIGHT/2-2
    self.dy = math.random(-50,50)


end


function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

end



function Ball:render()
    love.graphics.rectangle('fill',self.x , self.y,self.width,self.height)
end




function Ball:collides (box)
    
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false 
    end

    if self.y + self.height < box.y or self.y > box.y + box.height then
        return false
    end

    return true

end
