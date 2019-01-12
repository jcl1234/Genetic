eye = {}
function eye.create(cret)
	local eyes = #cret.eyes
	local e = {}
	local num = eyes + 1
	e.cret = cret
	e.num = num

	e.val = 0
	e.length = conf.cret.width*conf.cret.eye.length

	eye.update(e)
	table.insert(cret.eyes, e)
end

function eye.update(e)
	local offset = conf.cret.eye.offset/2
	if e.num == 1 then offset = -offset end

	e.angle = e.cret.angle +  offset
	e.x1 = e.cret.x
	e.y1 = e.cret.y
	e.x2 = e.x1 + math.cos(e.angle) * (e.length)
	e.y2 = e.y1 + math.sin(e.angle) * ((e.length)*-1)
end
