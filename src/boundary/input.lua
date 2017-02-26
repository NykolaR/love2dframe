--[[
-- input.lua
-- Input handling
-- Can get key pressed / key held / key released
-- In order to add a key, all that is needed is to add it to the lists at the beginning. Yay!
-- A value can have an infinite number of keys
-- 
-- This will likely be the basis of input for any of my Love games for some time.
--
-- Possible modifications: add easy way to re-map keys
-- ]]

local input = {}
input ["INPUT"] = {KEY_DOWN = 1, KEY_PRESSED = 2} --[[ DO NOT MODIFY ]]--

local PADVALUES = {
    ["b"] = 2, -- LK
    ["a"] = 3, -- MK
    ["y"] = 1, -- LP
    ["x"] = 4, -- MP
    ["rb"] = 6,
    ["lb"] = 5,
    ["rt"] = 8,
    ["lt"] = 7,
    ["start"] = 10,
    ["select"] = 9
}

--[[ "Inputs" to be mapped --]]
input ["KEYS"] = {LEFT = 1, RIGHT = 2, UP = 3, DOWN = 4, JUMP = 5, ACTION = 6, PAUSE = 7}

--[[ Keyboard mappings --]]
input ["KEYBOARD_KEYS"] =
{LEFT = {"left", "a"}, RIGHT = {"right", "d"}, UP = {"up", "w"}, DOWN = {"down", "s"}, JUMP = {"space"}, ACTION = {"b"}, PAUSE = {"return"}}

--[[ Joystick mappings. Automatically handles hat --]]
-- TODO: Handle axis and multiple controllers --
input ["JOYSTICK_KEYS"] =
{JUMP = {PADVALUES.b}, ACTION = {PADVALUES.a}, PAUSE = {PADVALUES.start}}

input ["keys"] = {}

local Joysticks = love.joystick.getJoysticks ()
if #Joysticks > 0 then
    input.joystick = Joysticks [1]
end

for x = 1, 2 do -- 2 columns
    input.keys [x] = {}

    for y = 1, #input.KEYS do
        input.keys [x][y] = false
    end
end

function love.joystickadded (joystick)
    if not input.joystick then
        input.joystick = joystick
    end
end

function input.handleInputs ()
    if input.joystick and love.joystick.getJoystickCount () > 0 then
        input.handleJoystick ()
    else
        input.handleKeyboard ()
    end
end

function input:handleKeyboard ()
    for i,v in pairs (input.KEYBOARD_KEYS) do
        input.checkDown (v, input.KEYS [i])
    end
end

function input:handleJoystick ()
    for i,v in pairs (input.JOYSTICK_KEYS) do
        input.checkJDown (v, input.KEYS [i])
    end

    -- HANDLE HATS
    local hatPos = input.joystick:getHat (1)
    local settings = {false, false, false, false}
    if hatPos == "u" then
        settings [1] = true
    elseif hatPos == "ru" then
        settings [1] = true
        settings [2] = true
    elseif hatPos == "r" then
        settings [2] = true
    elseif hatPos == "rd" then
        settings [2] = true
        settings [3] = true
    elseif hatPos == "d" then
        settings [3] = true
    elseif hatPos == "ld" then
        settings [3] = true
        settings [4] = true
    elseif hatPos == "l" then
        settings [4] = true
    elseif hatPos == "lu" then
        settings [4] = true
        settings [1] = true
    end

    input.setKey (input.KEYS.UP, settings [1])
    input.setKey (input.KEYS.RIGHT, settings [2])
    input.setKey (input.KEYS.DOWN, settings [3])
    input.setKey (input.KEYS.LEFT, settings [4])
end

function input.checkJDown (joyKey, keyAction)
    local val = false
    for i,v in pairs (joyKey) do
        if input.joystick:isDown (v) then
            val = true
        end
    end
    input.setKey (keyAction, val)
end

function input.checkDown (keyKeyboard, keyAction)
    local val = false
    for i,v in pairs (keyKeyboard) do
        if love.keyboard.isDown (v or "") then
            val = true
        end
    end
    input.setKey (keyAction, val)
end

function input.setKey (key, value)
    if value then
        if input.keys [input.INPUT.KEY_DOWN][key] then
            -- Input is being held
            input.keys [input.INPUT.KEY_PRESSED][key] = false
            input.keys    [input.INPUT.KEY_DOWN][key] = true
        else
            -- This is the first frame it was pressed
            input.keys    [input.INPUT.KEY_DOWN][key] = true
            input.keys [input.INPUT.KEY_PRESSED][key] = true
        end
    else
        -- Not pressed
        input.keys    [input.INPUT.KEY_DOWN][key] = false
        input.keys [input.INPUT.KEY_PRESSED][key] = false
    end
end

function input.keyPressed (key)
    return input.keys [input.INPUT.KEY_PRESSED][key]
end

function input.keyDown (key)
    return input.keys [input.INPUT.KEY_DOWN][key]
end

function input.getLeftStick (player)
    if input.joystick and love.joystick.getJoystickCount () > 0 then
        return input.joystick:getGamepadAxis ("leftx"), input.joystick:getGamepadAxis ("lefty")
    end

    return 0, 0
end

return input
