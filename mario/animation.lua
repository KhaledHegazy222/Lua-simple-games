animation = class{}

function animation:init(params)
    self.texture = params.texture
    self.frames = params.frames
    self.interval = params.interval or 0.05
    self.timer = 0
    self.currentframe = 1
end



function animation:getcurrentframe()
    return self.frames[self.currentframe]
end


function animation:restart()
    self.timer = 0 
    self.currentframe = 1
end

function animation:update(dt)
    self.timer = self.timer + dt


    if #self.frames == 1 then 
        return self.currentframe

    else 
        while self.timer > self.interval do
            self.timer = self.timer - self.interval
            self.currentframe = (self.currentframe + 1) % (#self.frames + 1)

            if self.currentframe == 0 then self.currentframe = 1  end
        end

    end
end