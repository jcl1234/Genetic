physics = {}
local function collisions(cret)
	--Update cret width
	cret.width = (conf.cret.width-conf.cret.minWidth) * (cret.energy/conf.cret.energy.max) + conf.cret.minWidth

	--Cret collision with food
	local hitbox = conf.food.hitbox
	for k, food in pairs(Food.foods) do
		if cret.x >= food.x-hitbox/2 and cret.x <= food.x + food.width+hitbox and cret.y >= food.y-hitbox/2 and cret.y <= food.y + food.width+hitbox then
			cret:eat(food)
		end
	end
end

local function move(cret, dt)
	--See if boosting
	if output.boost(cret) > 0 then
		cret.boosting = true
	else
		cret.boosting = false
	end

	local factor = .02
	--Move at current angle
	local newX = cret.x + math.cos(cret.angle) * cret.speed * factor
	local newY = cret.y - math.sin(cret.angle) * cret.speed * factor

	if conf.window.edgeless then
		if newX < 0 then newX = conf.window.width end
		if newX > conf.window.width then newX = 0 end
		if newY < 0 then newY = conf.window.height end
		if newY > conf.window.height then newY = 0 end
	end

	cret.x = newX
	cret.y = newY

	--Change angle from output
	local newAng = cret.angle - output.angle(cret)
	-- local oldAng = cret.angle
	-- local dif = 0
	-- --Negative to positive
	-- if newAng < -math.pi then
	-- 	dif = newAng - oldAng
	-- 	newAng = math.pi + dif
	-- --Positive to negative
	-- elseif newAng > math.pi then
	-- 	dif = newAng - oldAng
	-- 	newAng = -math.pi + dif
	-- end

	cret.angle = newAng
end



function physics.tick(cret, dt)
	move(cret, dt)
	collisions(cret)
end