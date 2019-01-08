input = {}
input.selected = nil
input.lastSelected = nil
input.margin = 10

local function toggle(set)
	if set then return false else return true end
end


function input.keypressed(key)
	--Pause
	if key == binds.pause then
		game.pause = toggle(game.pause)
	end

	--Speed up
	if key == binds.speed then
		game.timeScale = game.timeScale * 2
	end
	--Slow down
	if key == binds.slow and game.timeScale > 1 then
		game.timeScale = game.timeScale/2
	end
	--Last selected
	if key == binds.lastSelected then
		input.select(input.lastSelected)
	end
	--Select parent
	if key == binds.selectParent then
		if input.selected and input.selected.parent then
			input.select(input.selected.parent)
		end
	end
	--Toggle swarming
	if key == binds.swarm then
		game.swarm = toggle(game.swarm)
		if game.swarm then
			for k, food in pairs(Food.foods) do
				Food.foods[k] = nil
			end
			Food:spawn(mouseX, mouseY)
		else
			if Food.foods[1] then Food.foods[1]:remove() end
			Food.ticks = inf
		end
	end
	--Run a tick
	if key == binds.tick then
		game.doTick()
	end
end

function input.select(sel)
	local last = input.selected
	if sel ~= last and last ~= input.lastSelected and last ~= nil then
		input.lastSelected = last
	end
	input.selected = sel
end

function input.mousepressed(x, y, button)
	if button == 1 then
		local selected = nil
		--Select cret
		for k, cret in pairs(Cret.crets) do
			if x >= cret.x-input.margin/2 and x <= cret.x + input.margin and y >= cret.y-input.margin/2 and y <= cret.y + input.margin then
				selected = cret
			end
		end
		input.select(selected)
	elseif button == 2 then
		for k, food in pairs(Food.foods) do
			food:remove()
		end
		Food:spawn(x, y)
	end
end