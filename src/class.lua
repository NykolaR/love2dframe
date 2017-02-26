local Class = {}
function Class.new (parent)
    local class = {}
    class.__index = class
    setmetatable (class, {
        __index = parent,
        __call = function (class, ...)
            local self = setmetatable ({}, class)
            self:_init (...)
            return self
        end,
    })
    return class
end
return Class
