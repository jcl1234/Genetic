-- version  -  1.1
-- date     -  12/17/18

--Function that creates instance(ie: class:new())
local instanceFunc = "new"
--Function that runs upon instance creation
local initFunc = "init"
--Prototype argument position(ie: (prototype, inheritances) or (inheritances, prototype))
local protoLast = true
--

--Index value from object
local function indexObj(obj, key)
	local class = rawget(obj, "_class_")
	--If not an object then set to class
	if not class then class = obj end
	local prototype = rawget(class, "_prototype_")

	--Try Prototype
	if rawget(prototype, key) then return prototype[key] end
	--Try raw
	if rawget(class, key) then return rawget(class, key) end
	--Try Super Classes
	local supers = rawget(class, "_inherit_")
	if supers then
		for k, super in pairs(supers) do
			if super[key] then return super[key] end
		end
	end
end


--Create Class
function class(...)
	local args = {...}
	local argLen = 0
	local protoPos = 1
	if protoLast then protoPos = #args end

	local prototype, inherit = nil, {}
	for k, v in pairs(args) do
		if k == protoPos then prototype = v
		elseif k ~= protoPos then table.insert(inherit, v) end
	end
	--Create New Class
	local cls = {}
	cls._prototype_ = prototype
	cls._type_ = "class"
	cls._inherit_ = inherit
	local meta = {__index = indexObj}
	cls._meta_ = meta
	setmetatable(cls, meta)
	----Create Instance Function
	cls[instanceFunc] = function(self, ...)
		local object = setmetatable({}, cls._meta_)
		object._class_ = cls
		--Super Function
		object.super = function(num)
			local num = num or 1
			return cls._inherit_[num]
		end
		--Run Init Function On Creation
		if object[initFunc] or rawget(cls, initFunc) then
			object[initFunc](object, ...)
		end
		return object
	end

	return cls
end
-----------

--Example--

--[[
require("class")

local superClass = class({
	printVal = function(self)
		print(self.val)
	end
	})

local Sub = class(superClass, {
	init = function(self, val)
		self.val = val
	end,
	})

local sub1 = Sub:new(10)
sub1:printVal()

]]