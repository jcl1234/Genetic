ui.brain = {}

--Get color modified by val
function ui.brain.color(color, val)
	local drawColor = {}
	local minColor = conf.ui.brain.minColor
	for k, colVal in pairs(color) do
		if val >= 1 then 
			drawColor[k] = colVal 
		else
			drawColor[k] = colVal*val
		end
	end
	return drawColor
end

--Draw brain
function ui.brain.init(brain, x, y)
	local offsetX = 40
	local offsetY = 30
	ui.brain.x = x or conf.ui.brain.x
	ui.brain.y = y or conf.ui.brain.y

	ui.brain.width = 0
	ui.brain.height = 0

	--Create map of brain
	local neurons = {}
	local synapses = {}
	for layerNum, layer in pairs(brain.layers) do
		--Get neurons
		for k, neuron in pairs(layer) do
			local neuronX = ui.brain.x + (layerNum-1)*offsetX
			local neuronY = ui.brain.y + (k-1)*offsetY

			ui.brain.width = neuronX-ui.brain.x
			if ui.brain.height < neuronY-ui.brain.y then
				ui.brain.height = neuronY-ui.brain.y
			end

			local dn = {}
			dn.neuron = neuron
			dn.x = neuronX
			dn.y = neuronY
			dn.val = neuron.val
			table.insert(neurons, dn)

			--Create drawable synapses from output synapses
			for k, synapse in pairs(neuron.outs) do
				local ds = {}
				ds.input = neuron
				ds.output = synapse.output
				ds.x1 = neuronX
				ds.y1 = neuronY
				ds.weight = synapse.weight

				table.insert(synapses, ds)
			end

			for k, ds in pairs(synapses) do
				if ds.output == neuron then
					ds.x2 = neuronX
					ds.y2 = neuronY
				end
			end
		end
	end

	ui.brain.brain = brain
	ui.brain.neurons = neurons
	ui.brain.synapses = synapses

	ui.brain.offset = conf.ui.brain.background.offset
	ui.brain.drawBackground = conf.ui.brain.background.draw

	return ui.brain
end

function ui.brain.draw(brain)
	if not ui.brain.brain then
		ui.brain.init(brain, x, y)
	end

	local neurons = ui.brain.neurons
	local synapses = ui.brain.synapses
	local brain = ui.brain.brain

	local radius = conf.ui.brain.neuron.width
	--Draw background
	if brain.drawBackground then
		love.graphics.setColor(conf.ui.brain.background.color)
		love.graphics.rectangle("fill", ui.brain.x-ui.brain.offset, ui.brain.y-ui.brain.offset, ui.brain.width+ui.brain.offset*2, ui.brain.height+ui.brain.offset*2)
	end
	--Draw synapses
	for k, synapse in pairs(synapses) do
		local drawColor = conf.ui.brain.synapse.posColor
		local weight = synapse.weight
		--Inverse if negative
		if synapse.weight < 0 then
			drawColor = conf.ui.brain.synapse.negColor
			weight = weight*-1
		end
		--Shade based on weight strength
		local drawColor = {unpack(drawColor)}
		drawColor[4] = weight/conf.ui.brain.synapse.range
		love.graphics.setColor(drawColor)
		love.graphics.line(synapse.x1, synapse.y1, synapse.x2, synapse.y2)
	end
	--Draw neurons
	for k, neuron in pairs(neurons) do
		--Neuron Inner
		local drawColor = conf.ui.brain.neuron.posColor
		local val = neuron.val
		--Inverse if negative
		if neuron.val < 0 then
			drawColor = conf.ui.brain.neuron.negColor
			val = val*-1
		end
		love.graphics.setColor(ui.brain.color(drawColor, val))
		love.graphics.circle("fill", neuron.x, neuron.y, radius)
		--Neuron Outer
		love.graphics.setColor(0,0,0)
		love.graphics.circle("line", neuron.x, neuron.y, radius)
		--Neuron Info
		love.graphics.setColor(conf.ui.brain.info.color)
		love.graphics.print(round(neuron.val,2), neuron.x-9, neuron.y-5, 0, .9)
	end
end