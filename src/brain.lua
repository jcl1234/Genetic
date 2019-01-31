--Activation Functions
local af = {}

--Unit Step, activates to 1 at x>0, else stays at 0
function af.unst(x)
	if x < 0 then return 0
	else return 1 end
end

--Sig num, returns the sign of x, and 0 if 0
function af.sign(x)
	if x < 0 then return -1
	elseif x == 0 then return 0
	elseif x > 0 then return 1 end
end

--Linear
function af.lin(x)
	return x
end

--Sigmoid, log between 0 and 1
function af.sig(x)
    return 1/(math.exp(-x)+1)
end

--TanH, log between -1 and 1
function af.tanh(x)
	return math.tanh(x)
end

--Random float
local function randFloat(low, high)
	if not high then low = high; high = 0 end
	return math.random() * (high - low) + low
end

--Synapse-------------------------------------
local Synapse = class {
	init = function(self, neurIn, neurOut)
		self.input = neurIn
		self.output = neurOut
		self.weight = 1

		--Register to brain and neuron
		table.insert(self.input.outs, self)
		table.insert(self.output.ins, self)
		table.insert(self.input.brain.synapses, self)
	end,

	calcVal = function(self, chain)
		if chain == nil then chain = true end

		local outVal = nil
		--[[If chain then run calcval on input neuron resulting in a chain reaction in all neurons in lower level layers than the input neuron.
		This is disabled if you've already run a chain calculation on the first output neuron, meaning all lower-than-output layer neurons
		already have their value calculated, and there is not a need for the next output neurons to initiate a chain reaction in the rest
		of the brain, so it just takes the already calculated values from the previous layer and uses them as values.
		]]
		if chain then
			outVal = self.input:calcVal() * self.weight
		else
			outVal = self.input.val * self.weight
		end
		return outVal
	end,
	}

--Neuron--------------------------------------
local Neuron = class {
	init = function(self, brain, layer, bias)
		self.brain = brain
		self.layer = layer
		self.ins = {}
		self.outs = {}

		self.bias = bias

		--Storage
		self.val = 0

		--Register to brain
		table.insert(brain.layers[self.layer], self)
		table.insert(brain.neurons, self)
	end,

	--Caulculate value of neuron from values of input synapses
	calcVal = function(self, chain)
		if self.layer ~= 1 and not self.bias then
			local sumVals = 0

			for k, synapse in pairs(self.ins) do
				sumVals = sumVals + synapse:calcVal(chain)
			end

			if self.layer == #self.brain.layers then
				self.val = self.brain.af[self.brain.afOutput](sumVals)
			else
				self.val = self.brain.af[self.brain.afHidden](sumVals)
			end

			return self.val
		else
			--Input or bias(both have no input synapses)
			return self.val
		end
	end,
	}

--[[
	--Pre defined brain
	brain = {}
	brain.layers = {4, 2, 2}
	brain.weights = {2, 1, 3, 5, 4, 6, 7, 9, 8, 10, 13, 12, 15, 16, 14, 11}
	
	--Random brain
	brain = {}
	brain.layers = {4, 2, 2}

	---Brain settings
	brain.bias = true(default)
	brain.weightRange = 3(default)
	brain.afHidden = "sig"(default)
	brain.afOutput = "tanh" (default)
]]

--Brain---------------------------------------
Brain = class {
	af = af,
	init = function(self, brainInf)
		self.layers = {}
		self.neurons = {}
		self.synapses = {}

		self.bias = true

		self.afHidden = "sig"
		self.afOutput = "tanh"

		--Set up brain
		if brainInf then
			if brainInf.bias == false then self.bias = false end
			if brainInf.afHidden then self.afHidden = brainInf.afHidden end
			if brainInf.afOutput then self.afOutput = brainInf.afOutput end
			self:setup(brainInf)
		end
	end,

	--Set up layers with neurons and synapses
	setup = function(self, inf)
		local numLayers = #inf.layers
		--Incrementing
		local numWeight = 1

		--Create neurons
		for k, layer in pairs(inf.layers) do
			local numNeurons = layer
			--Create empty layers
			self.layers[k] = {}
			--Add neuron
			for i=1, numNeurons do
				Neuron:new(self, k)
			end
			--Create bias neuron
			if self.bias and k ~= numLayers then
				local biasNeuron = Neuron:new(self, k, true)
				biasNeuron.val = 1
			end
		end
		--Create synapses
		for layerNum, layer in pairs(self.layers) do
			if layerNum ~= numLayers then
				--Get number of neurons on next layer
				local neuronsNext = #self.layers[layerNum+1]
				--Create synapses
				for k, neuron in pairs(layer) do
					for i=1, neuronsNext do
						local outputNeuron = self.layers[layerNum+1][i]
						if not outputNeuron.bias then
							local synapse = Synapse:new(neuron, outputNeuron)
							if inf.weights then
								synapse.weight = inf.weights[numWeight]
								numWeight = numWeight + 1
							else
								synapse.weight = self:rand(inf)
							end
						end
					end
				end
			end
		end
	end,

	--Set inputs from table
	setInputs = function(self, inputs)
		for k, neuron in pairs(self.layers[1]) do
			if not neuron.bias and inputs[k] then
				neuron.val = inputs[k]
			end
		end
	end,

	--Generate a random weight
	rand = function(self, inf)
		local range = inf.weightRange or 3
		return randFloat(-range, range)
	end,

	--Generate output by calculating value of output layer neurons
	output = function(self, inputs)
		if inputs then self:setInputs(inputs) end
		local outputs = {}
		for k, layer in pairs(self.layers) do
			if k ~= 1 then
				if k ~= #self.layers then
					--Run calculations on each layer below output
					for k, neuron in pairs(layer) do
						if not neuron.bias then
							neuron:calcVal(false)
						end
					end
				else
					--Run calculations on output neurons
					for k, neuron in pairs(layer) do
						table.insert(outputs, neuron:calcVal(false))
					end	
				end
			end
		end
		return outputs
	end,

	--Export weights and layers as brain info
	info = function(self)
		local inf = {}
		--Get Layers
		inf.layers = {}
		for k, layer in pairs(self.layers) do
			local neurons = #layer
			--Decrease number of neurons to add weights to by 1 if the brain has a bias neuron
			if k ~= #self.layers and self.bias then neurons = neurons - 1 end
			table.insert(inf.layers, neurons)
		end
		--Get weights
		inf.weights = {}
		for k, synapse in pairs(self.synapses) do
			table.insert(inf.weights, synapse.weight)
		end
		inf.bias = self.bias
		inf.afHidden = self.afHidden
		inf.afOutput = self.afOutput
		return inf
	end,
	}
