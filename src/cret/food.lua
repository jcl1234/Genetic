Food = class({
	foods = {},
	ticks = 0,
	init = function(self, x, y)
		self.x = x
		self.y = y
		self.width = conf.food.width

		table.insert(self.foods, self)
	end,

	remove = function(self)
		for k, v in pairs(self.foods) do
			if v == self then
				table.remove(self.foods, k)
			end
		end
	end,

	--CLASSMETHODS
	--Spawn in random location
	spawn = function(cls, x, y)
		local offset = 50
		x = x or math.random(offset, conf.window.width-offset)
		y = y or math.random(offset, conf.window.height-offset)

		cls:new(x, y)
	end,

	--Spawn food
	update = function(cls, dt)
		--Update food position during swarm mode
		if game.swarm then
			for k, food in pairs(cls.foods) do
				food.x, food.y = mouseX, mouseY
			end
		end

		if not game.starve and not game.swarm then
			if #cls.foods < conf.food.number then
				cls.ticks = cls.ticks + 1
				if cls.ticks >= conf.food.spawnRate then
					cls:spawn()
					cls.ticks = 0
				end
			end
		end
	end,

	draw = function(cls)
		--Dont draw if swarm is on
		if game.swarm then return end
		for k, food in pairs(cls.foods) do
			graphics.drawFood(food)
		end
	end,
	})
