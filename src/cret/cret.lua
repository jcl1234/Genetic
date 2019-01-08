Cret = class({
	crets = {},
	--Stats
	oldestGen = 1,
	highestGen = 1,

	init = function(self, parent, x, y)
		self.parent = parent
		self.color = nil

		self.energy = conf.cret.energy.start

		self.alive = true

		--Physics
		self.width = conf.cret.width
		self.speed = conf.cret.physics.speed
		self.rotSpeed = conf.cret.physics.rotSpeed
		self.angle = 0
		self.x = x
		self.y = y
		self.xVel = 0
		self.yVel = 0

		--Stats
		self.foodEaten = 0
		self.childrenBirthed = 0
		self.childrenAlive = {}
		self.generation = 1
		--Descendants
		self.descendants = 0
		self.descendantsAlive = {}

		--Brain
		self.brain = nil
		if parent then
			local info = parent.brain:info()
			info.weights = self:mutate(info.weights)
			self.brain = Brain:new(info)
			self.color = self:mutateColor(parent.color)
			self.generation = self.parent.generation + 1
			table.insert(self.parent.childrenAlive, self)
			self:countDescendant(self)
		else
			self.brain = Brain:new(conf.brain.layout)
			self.color = self:mutateColor()
		end

		--Update highest generation
		if self.generation > Cret.highestGen then Cret.highestGen = self.generation end

		self.outputs = {}

		table.insert(self.crets, self)
	end,

	--Mutate color
	mutateColor = function(self, color)
		color = color or {math.random(), math.random(), math.random()}
		local newCol = {}
		for k, colVal in pairs(color) do
			local newVal = colVal + (math.random() * math.random(-conf.mutate.color.range, conf.mutate.color.range))
			if newVal > 1 then newVal = 1 end
			if newVal < conf.mutate.color.min then newVal = conf.mutate.color.min end
			newCol[k] = newVal
		end
		return newCol
	end,

	--Mutate
	mutate = function(self, weights)
		local newWeights = {}
		for k, weight in pairs(weights) do
			if math.random() <= conf.mutate.rate then
				newWeights[k] = weight + (math.random() * math.random(-conf.mutate.range, conf.mutate.range))
			else
				newWeights[k] = weight
			end
		end
		return newWeights
	end,

	--Birth children
	birth = function(self)
		for i=1, conf.cret.birth.amount do
			local x = self.x + (math.random() * conf.cret.birth.offset)
			local y = self.y + (math.random() * conf.cret.birth.offset)
			local cret = Cret:new(self, x, y)
			cret.angle = math.random() * (math.pi*2)

			self.childrenBirthed = self.childrenBirthed + 1
		end
	end,

	--Count as a descendent for every parent up the line
	countDescendant = function(self, cret)
		if not self.parent or not conf.cret.descendants then return end
		self.parent.descendants = self.parent.descendants + 1
		table.insert(self.parent.descendantsAlive, cret)
		self.parent:countDescendant(cret)
	end,

	--Count as a dead descendant
	killDescendant = function(self, cret)
		if not self.parent or not conf.cret.descendants then return end
		remove(self.parent.descendantsAlive, cret)
		self.parent:killDescendant(cret)
	end,

	--Eat a food
	eat = function(self, food)
		if game.swarm then return end
		food:remove()
		self.energy = conf.cret.energy.max
		if self.energy >= conf.cret.energy.max then self.energy = conf.cret.energy.max end

		self.foodEaten = self.foodEaten + 1

		self:birth()
	end,

	--Tick
	tick = function(self, dt)
		--Update speed and energy
		if not self.boosting then
			self.speed = conf.cret.physics.speed
			self.rotSpeed = conf.cret.physics.rotSpeed
			if not game.swarm then
				self.energy = self.energy - conf.cret.energy.loss
			end
		else
			self.speed = (conf.cret.physics.speed*conf.cret.boost.speedFactor)
			self.rotSpeed = (conf.cret.physics.rotSpeed*conf.cret.boost.rotFactor)
			if not game.swarm then
				self.energy = self.energy - (conf.cret.energy.loss*conf.cret.boost.lossFactor)
			end
		end

		--Kill if low energy
		if self.energy <= 0 then
			self:kill()
		end

		--Update cret outputs
		self.outputs = self.brain:output(inputs.get(self))
	end,

	--Update cret stats on death
	oldestGenUpdate = function(self)
		if self.generation <= Cret.oldestGen then
			local oldest = inf
			for k, cret in pairs(Cret.crets) do
				if cret ~= self and cret.generation <= oldest then oldest = cret.generation end
			end
			Cret.oldestGen = oldest
		end
	end,

	--Kill cret
	kill = function(self)
		self.alive = false
		self:oldestGenUpdate()

		for k,v in pairs(self.crets) do
			if v == self then
				self.energy = 0
				table.remove(self.crets, k)
			end
		end
		if self.parent then
			remove(self.parent.childrenAlive, self)
		end

		self:killDescendant(self)

	end,

	--CLASSMETHODS
	--Spawn crets
	spawn = function(cls, amount)
		for i=1, amount do
			Cret:new(nil, math.random()*conf.window.width, math.random()*conf.window.height)
		end
		game.tick = 0
	end,

	--Run physics and logic on all crets
	update = function(cls, dt)
		for k, cret in pairs(cls.crets) do
			cret:tick(dt)
			physics.tick(cret, dt)
		end

		--Spawn if pop extinct
		if game.respawn and #cls.crets <= 0 then
			cls:spawn(conf.respawn.amount)
			cls:resetStats()
		end

		game.pop = #Cret.crets
	end,

	--Draw all crets
	draw = function(cls)
		for k, cret in pairs(cls.crets) do
			graphics.drawCret(cret)
		end
	end,

	--Reset stats
	resetStats = function(cls)
		cls.oldestGen = nil
		cls.highestGen = 1
	end,
	})