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

function odd(x)
	if mod(x, 2) == 1 then return true end
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
	if not t then return end
	return t[math.random(#t)]
end

function splitStr(str, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(str, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

--Line distance
function lineDist(x1, y1, x2, y2, px, py)
  local cx, cy = px - x1, py - y1 -- convert to origin x1, y1
  local dx, dy = x2 - x1, y2 - y1
  local d = (dx*dx + dy*dy)
  if d == 0 then
    return x1, y1 -- line is degenerate
  end
  local u = (cx*dx + cy*dy)/d -- project point on line
  -- clamp to segment length
  if u < 0 then
    u = 0
  elseif u > 1 then
    u = 1
  end

  local x, y = u*dx, u*dy -- nearest point
  local ex, ey = x - cx, y - cy -- find the distance
  local e = math.sqrt(ex*ex + ey*ey)
  return e
end
