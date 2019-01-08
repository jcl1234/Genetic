conf = {
	window = {
		width = 1800,
		height = 950,
		edgeless = true,
	},

	respawn = {
		amount = 30,
		active = true,
	},

	cret = {
		descendants = true,

		minWidth = 3,
		width = 10,

		noseLength = 2.25,

		childCircleWidth = 20,
		parentTriangleSize = 20,

		energy = {
			max = 1000,
			start = 500,
			loss = 0.05,
		},

		boost = {
			speedFactor = 2,
			rotFactor = 4,
			lossFactor = 4,
			color = {1,0,0},
		},

		physics = {
			speed = 75,
			rotSpeed = .06,
		},

		birth = {
			amount = 4,
			offset = 20,
		},
	},

	mutate = {
		rate = .2,
		range = 1,
		color = {
			range = .05,
			min = .4,
		},
	},

	food = {
		width = 6,
		color = {0,.8,0},
		hitbox = 12,
		spawnRate = 180,
	},

	brain = {
		layout = {
			layers = {4, 3, 2, 2},
			afHidden = "sig",
			afOutput = "tanh",
		},

		inputs = {
			foodSpawned = 1,
			foodAngle = 2,
			foodDistance = 3,
			energy = 4,
		},

		outputs = {
			angle = 1,
			boost = 2,
		},
	},

	ui = {
		brain = {
			x = 690,
			y = 30,
			background = {
				color = {.5,.5,.5, .3},
				offset = 20,
				draw = false,
			},

			neuron = {
				width = 10,
				posColor = {.5,.5,.2},
				negColor = {.2,.5,.5},
			},

			synapse = {
				posColor = {0,1,0},
				negColor = {1,0,0},
				range = 3,
			},

			info = {
				color = {1,1,1}
			},
		},
	},
}