inputs = {}

--Returns whether food is spawned on the map, 0 is no and 1 is yes
function inputs.foodSpawned(cret)
	local spawned = 0
	if #Food.foods >= 1 then
		spawned = 1
	end
	return spawned
end

--Returns angle from cret to food source, normalizes to 3.14 = 0.5
local noFood = -1
function inputs.foodAngle(cret)
	local foodAng = nil
	for k, food in pairs(Food.foods) do
		foodAng = mod(angle(cret.x, cret.y, food.x, food.y), math.pi*2)
	end
	if not foodAng then return noFood end
	local cretAng = mod(cret.angle, math.pi*2)
	return foodAng/cretAng
end

--Returns distance from food source, normalizes to (current distance/farthest distance), the farthest possible distance, so 800 for a screen width of 800, Returns 1(max distance) if there is no food
function inputs.foodDistance(cret)
	for k, food in pairs(Food.foods) do
		return dist(cret.x, cret.y, food.x, food.y)/math.max(conf.window.width, conf.window.height)
	end
	return 1
end

--Returns energy of cret, normalized as (current energy/ max energy)
function inputs.energy(cret)
	return cret.energy/conf.cret.energy.max
end


function inputs.get(cret)
	local inputTable = {}
	inputTable[conf.brain.inputs.fs] = inputs.foodSpawned(cret)
	inputTable[conf.brain.inputs.fa] = inputs.foodAngle(cret)
	inputTable[conf.brain.inputs.fd] = inputs.foodDistance(cret)
	inputTable[conf.brain.inputs.en] = inputs.energy(cret)
	return inputTable
end
