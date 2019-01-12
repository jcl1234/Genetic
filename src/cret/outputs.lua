output = {}

--Returns rotation speed, below 0 (or .5 if sig) turns left
function output.angle(cret)
	local left = (cret.outputs[conf.brain.outputs.al]) * cret.rotSpeed
	local right = (cret.outputs[conf.brain.outputs.ar]) * cret.rotSpeed
	return left - right
end

--Returns when boost should activate, above 0 (or .5 if sig) means its active, but increases energy loss by 4x
function output.boost(cret)
	return cret.outputs[conf.brain.outputs.bs]
end
