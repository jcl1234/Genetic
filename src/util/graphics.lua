--Line
line = {}
line.orig = love.graphics.getLineWidth()
function line.set(width)
	love.graphics.setLineWidth(width)
end

function line.pop()
	love.graphics.setLineWidth(line.orig)
end

--Triangle
function triangle(mode, x, y, size)
	local x1, y1 = x, y-size
	local x2, y2 = x+size, y+size
	local x3, y3 = x-size, y+size
	love.graphics.polygon(mode, x1, y1, x2, y2, x3, y3)
end