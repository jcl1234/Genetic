function graphics.drawSelectedCret(cret)
	--Draw selected outline
	if cret.alive then
		line.set(3)
		love.graphics.setColor(cret.color)
		love.graphics.circle("line", cret.x, cret.y, 20)
		line.pop()
	end
	--Draw Descendants
	local alpha = .3
	local dCol = {unpack(cret.color)}
	dCol[4] = alpha
	local width = conf.cret.childCircleWidth
	love.graphics.setColor(dCol)
	for k, d in pairs(cret.descendantsAlive) do
		love.graphics.circle("fill", d.x, d.y, width)
	end
	--Draw children
	for k, child in pairs(cret.childrenAlive) do
		love.graphics.setColor(1,1,1)
		love.graphics.circle("line", child.x, child.y, width)
	end

	--Draw triangle above parent
	if cret.parent and cret.parent.alive then
		local size = conf.cret.parentTriangleSize
		local offsetFactor = 4
		local alpha = .7
		dCol[4] = alpha
		love.graphics.setColor(dCol)
		line.set(3)
		triangle("line", cret.parent.x, cret.parent.y-size/offsetFactor, size)
		line.pop()
	end
end


function graphics.drawCret(cret, x, y, width, eyes)
	x = x or cret.x
	y = y or cret.y
	width = width or cret.width

	--Cret eye
	if conf.cret.eye.draw and game.drawEyes and eyes then
		local drawCol = {unpack(cret.color)}
		drawCol[4] = conf.cret.eye.alpha
		love.graphics.setColor(drawCol)
		line.set(conf.cret.eye.width)
		for k, e in pairs(cret.eyes) do
			love.graphics.line(x, y, e.x2, e.y2)
		end
		line.pop()
	end
	--Cret nose
	if conf.cret.drawNose or (not eyes) then
		love.graphics.setColor(cret.color)
		love.graphics.line(x, y, x + math.cos(cret.angle) * (width*conf.cret.noseLength), y + math.sin(cret.angle) * ((width*conf.cret.noseLength)*-1))
	end
	--Cret body
	love.graphics.setColor(cret.color)
	love.graphics.circle("fill", x, y, width)
	--Cret outline
	love.graphics.setColor(1,1,1)
	if cret.boosting then love.graphics.setColor(conf.cret.boost.color) end
	love.graphics.circle("line", x, y, width)
end
