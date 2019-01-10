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
			loss = 0.1,
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
			amount = 2,
			offset = 20,
		},
	},

	mutate = {
		rate = .4,
		range = .5,
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
			layers = {4, 10, 7, 5, 2},
			afHidden = "unst",--"sig",
			afOutput = "tanh",
		},

		inputs = {
			fs = 1, --food spawned
			fa = 2, --food angle
			fd = 3, --food Distance
			en = 4, --cret energy
		},

		outputs = {
			an = 1, --Angle
			bs = 2, --Boost
		},
	},

	ui = {
		info = {
			background = true,
			color = {1,1,1,1},
		},

		cretInfo = {
			background = false,
			scale = 1,
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
