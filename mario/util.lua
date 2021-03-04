function GenerateQuad(atlas, tilewidth, tileheight)
    local SheetWidth = atlas:getWidth() / tilewidth
    local SheetHeight = atlas:getHeight() / tileheight

    local SheetCounter = 1

    local quads = {}

    for y = 0 , SheetHeight - 1 do  
        for x = 0 , SheetWidth - 1 do
            quads[SheetCounter] = love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
            SheetCounter = SheetCounter + 1   
        end
    end

    return quads

end