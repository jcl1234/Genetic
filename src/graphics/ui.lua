ui = {}
ui.mouse = {}

--Info panel
function ui.drawInfo()
	local x = 10
	local y = 10
	local width = 150
	local height = 85

	if conf.ui.info.background then
		love.graphics.setColor(.2,.2,.2,.5)
		love.graphics.rectangle("fill", x, y, width, height)
	end

	--Info
	love.graphics.setColor(conf.ui.info.color)

	local infoX = x+10
	local infoY = y+5
	local infoOffset = 15
	--Population
	love.graphics.print("Pop: "..game.pop, infoX, infoY)
	--Speed
	love.graphics.print("Speed: "..game.timeScale, infoX,infoY+infoOffset*1)
	--Time
	love.graphics.print("World Age: "..round((game.tick/8000), 2), infoX, infoY+infoOffset*2)
	--Oldest generation
	love.graphics.print("Oldest Generation: "..(Cret.oldestGen or 1), infoX, infoY+infoOffset*3)
	--Highest Generation
	love.graphics.print("Highest Generation: "..(Cret.highestGen or 1), infoX, infoY+infoOffset*4)
end

--Crete info panel
function ui.drawCretInfo(cret)
	--Amount of overhang from brain drawing
	local heightExtra =70

	local height = 210

	local xOffset = 250 + #conf.brain.layout.layers*conf.ui.brain.offsetX
	local yOffset = 10
	local x = conf.window.width - xOffset
	local y = yOffset
	--Init brain
	local brain = ui.brain.init(cret.brain, x+20, y+20)
	--Base width and height off of brain
	height = brain.height+brain.offset*2+heightExtra
	--Background
	if conf.ui.cretInfo.background.draw then
		love.graphics.setColor(conf.ui.cretInfo.background.color)
		love.graphics.rectangle("fill", x, y, conf.window.width, height)
	end
	--Draw brain
	ui.brain.draw()

	--Draw info
	local infoOffset = 20
	local bInfoX = brain.x-brain.offset+10
	local bInfoY = brain.y+brain.height+brain.offset+5

	--Infomin is the lowest x the cretinfo is allowed to draw at, this is to prevent the info from overlapping with bottom info
	local infoMin = 180
	local infoX = math.max(brain.x+brain.width+brain.offset, brain.x + infoMin)
	local infoY = y+10

	local scale = conf.ui.cretInfo.scale
	--Status
	love.graphics.setColor(0,1,0)
	local status = "Alive"
	if not cret.alive then status = "Dead"; love.graphics.setColor(1,0,0) end
	love.graphics.print("Status: "..status, infoX, infoY, 0, scale)
	--Energy
	love.graphics.setColor(1,1,1)
	love.graphics.print("Energy: "..round(cret.energy, 0), infoX, infoY + infoOffset*1, 0, scale)
	--Boosting
	love.graphics.print("Boosting: "..tostring(cret.boosting), infoX, infoY+infoOffset*2, 0, scale)
	--Stats
	love.graphics.setColor(.6,.6,.8)
	love.graphics.print("Food Eaten: "..cret.foodEaten, infoX, infoY + infoOffset*3, 0, scale)
	love.graphics.print("Children Birthed: "..cret.childrenBirthed, infoX, infoY + infoOffset*4, 0, scale)
	love.graphics.print("Children Alive: "..#cret.childrenAlive, infoX, infoY + infoOffset*5, 0, scale)
	love.graphics.print("Generation: "..cret.generation, infoX, infoY + infoOffset*6, 0, scale)
	--Bottom Info
	love.graphics.setColor(.4,.8,.7)
	local descendantsAlive = #cret.descendantsAlive
	local addval = 1
	if not cret.alive then addval = 0 end
	love.graphics.print("Descendants Alive: "..descendantsAlive.." ("..round((descendantsAlive+addval)/game.pop*100, 0).."%)", bInfoX, bInfoY + infoOffset*0 , 0, scale)
	love.graphics.print("Descendants Total: "..cret.descendants, bInfoX, bInfoY + infoOffset*1, 0, scale)
	--Cret Image
	local xAdd = 340
	local yAdd = 10
	local width = 1.5
	local x, y = bInfoX+xAdd, bInfoY + yAdd
	local bgWidth = width*30
	love.graphics.setColor(1,1,1,.1)
	love.graphics.rectangle("fill", x-bgWidth/2, y-bgWidth/2, bgWidth, bgWidth)
	graphics.drawCret(cret, x, y, width*cret.width, false)
end