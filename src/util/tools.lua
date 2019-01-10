inf = 1e309

function round(x, place)
	local placeStr = "1"
	for i=1, place do
		placeStr = placeStr..0
	end
	place = tonumber(placeStr)
	x = x * place
	x = math.floor(x + 0.5)
	return x/place
end

function copy(orig)
	if type(orig) ~= "table" then return orig end
	local newTab = {}
	for k,v in pairs(orig) do
		newTab[k] = copy(v)
	end
	setmetatable(newTab, getmetatable(orig))
	return newTab
end

function angle(x1, y1, x2, y2)
	return math.atan2 (y1 - y2, x2 - x1) 
end

function mod(a, b)
	return a - math.floor(a/b)*b
end

function exists(t, val)
	for k,v in pairs(t) do
		if v == val then return true end
	end
end

function remove(t, val)
	for k, v in pairs(t) do
		if v == val then
			table.remove(t, k)
		end
	end
end

function dist(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end

function byVal(t, val)
	for k, v in pairs(t) do
		if v == val then return k end
	end
end

function randVal(t)
	return t[math.random(#t)]
end
