conf = {
	window = {
		width = 1800,
		height = 900,
		fullScreen = false,
		edgeless = true,
	},

	respawn = {
		amount = 30,
		active = true,
	},

	cret = {
		descendants = true,

		minWidth = 2,
		width = 5,

		drawNose = false,
		noseLength = 3,

		childCircleWidth = 20,
		parentTriangleSize = 20,

		energy = {
			max = 1000,
			start = 500,
			loss = .5,
		},

		eye = {
			num = 2,
			length = 25,
			width = 15,
			alpha = 0.4,
			offset = .8,
			offVal = 0,
			draw = true,
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
			amount = 1,
			offset = 15,
		},
	},

	mutate = {
		rate = .4,
		range = 1,
		color = {
			range = .05,
			min = .4,
		},
	},

	food = {
		bgWidth = 10,
		number = 50,
		width = 3,
		color = {0,.8,0},
		hitbox = 6,
		spawnRate = 30,
	},

	brain = {
		layout = {
			layers = {3, 5, 3},
			afSpecial = {{"4:3", "tanh"}},
			afHidden = "sig",
			afOutput = "sig",
		},

		inputs = {
			e1 = 1, --eye 1 food
			e2 = 2, --eye 2 food
			en = 3, --cret energy
		},

		outputs = {
			ar = 1, --turn right
			al = 2, --turn left
			bs = 3, --boost
		},
	},

	ui = {
		info = {
			background = true,
			color = {1,1,1,1},
		},

		cretInfo = {
			scale = 1,
			background = {
				color = {.3,.3,.3,.2},
				draw = true,
			},
		},
		brain = {
			x = 690,
			y = 30,
			offsetX = 50,
			offsetY = 15,
			symmetrical = true,
			background = {
				color = {.5,.5,.5, .3},
				offset = 2,
				draw = false,
			},

			neuron = {
				width = 5,
				posColor = {1,1,1},
				negColor = {.8,.8,.4},
			},

			synapse = {
				posColor = {0,0,0},
				negColor = {1,1,1},
				onlyDrawActive = true,
				activeRange = 0,
				range = 3,
			},

			info = {
				--Neuron values
				color = {.7,.7,.3},
				draw = false,
				--Neuron names
				name = {
					scale = 1,
					inputOffset = 25,
					outputOffset = 25,
					yOffset = -6,
					color = {.7,.7,.7},
					draw = false,
					biasName = "cs"
				},
			},
		},
	},
}
