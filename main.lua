local Input = require ("src.boundary.input")

local font = love.graphics.newImageFont ("assets/visual/font.png",
    " abcdefghijklmnopqrstuvwxyz0123456789", 1)
love.graphics.setFont (font)

function love.load ()

end

local centerX, centerY = 500, 500
local x, y = 0, 0

function love.update (dt)
    Input.handleInputs ()
    checkQuit ()

    if Input.keyPressed (Input.KEYS.LEFT) then
        print ("up")
    end

    x, y = Input.getLeftStick ()
end

function love.draw ()
    if Input.keyPressed (Input.KEYS.UP) then
        love.graphics.print ("hi there, this is a message 11011")
    end

    love.graphics.line (centerX + (x * 500), centerY + (y * 500), centerX, centerY)
end

function checkQuit ()
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
end
