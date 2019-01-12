inputs = {}

--Returns if food is touching eye and how far down the eye it is
function inputs.eye(eye)
	for k, food in pairs(Food.foods) do
		-- local eyeDist = lineDist(eye.x1, eye.y1, eye.x2, eye.y2, love.mouse.getX(),love.mouse.getY())
		local eyeDist = lineDist(eye.x1, eye.y1, eye.x2, eye.y2, food.x, food.y)
		--Distance from food to line is less than the radius of the food
		if eyeDist <= conf.food.width + conf.cret.eye.width/2 then
			local cretDist = dist(eye.cret.x, eye.cret.y, food.x, food.y)
			return 1 - (cretDist/eye.length)
			-- return 1
		end
	end
	return conf.cret.eye.offVal
end

--Returns energy of cret, normalized as (current energy/ max energy)
function inputs.energy(cret)
	return cret.energy/conf.cret.energy.max
end


function inputs.get(cret)
	local inputTable = {}
	--eyes
	for k, e in pairs(cret.eyes) do
		local inputNum = conf.brain.inputs["e"..k]
		inputTable[inputNum] = inputs.eye(e)
	end
	inputTable[conf.brain.inputs.en] = inputs.energy(cret)
	return inputTable
end
