output = {}

local val = 0
if conf.brain.layout.afOutput == "sig" then val = 0.5 end

--Returns rotation speed, below 0 (or .5 if sig) turns left
function output.angle(cret)
	return (cret.outputs[conf.brain.outputs.angle] - val) * cret.rotSpeed
end

--Returns when boost should activate, above 0 (or .5 if sig) means its active, but increases energy loss by 4x
function output.boost(cret)
	return cret.outputs[conf.brain.outputs.boost] - val
end