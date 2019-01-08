ui = {}
ui.mouse = {}

--Info panel
function ui.drawInfo()
	local x = 10
	local y = 10
	local width = 160
	local height = 85

	love.graphics.setColor(.2,.2,.2,.5)
	love.graphics.rectangle("fill", x, y, width, height)

	--Info
	love.graphics.setColor(1,1,1)

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
	local heightExtra = 50

	local height = 210
	local xOffset = 300
	local yOffset = 10
	local x = conf.window.width - xOffset
	local y = yOffset
	--Init brain
	local brain = ui.brain.init(cret.brain, x+20, y+20)
	--Base width and height off of brain
	height = brain.height+brain.offset*2+heightExtra
	--Background
	love.graphics.setColor(.3,.3,.3,.7)
	love.graphics.rectangle("fill", x, y, conf.window.width, height)
	--Draw brain
	ui.brain.draw()

	--Draw info
	local infoOffset = 20
	local bInfoX = brain.x-brain.offset+10
	local bInfoY = brain.y+brain.height+brain.offset+5

	local infoX = brain.x+brain.width+brain.offset + 10
	local infoY = y+10
	--Status
	love.graphics.setColor(0,1,0)
	local status = "Alive"
	if not cret.alive then status = "Dead"; love.graphics.setColor(1,0,0) end
	love.graphics.print("Status: "..status, infoX, infoY)
	--Energy
	love.graphics.setColor(1,1,1)
	love.graphics.print("Energy: "..round(cret.energy, 0), infoX, infoY + infoOffset*1)
	--Boosting
	love.graphics.print("Boosting: "..tostring(cret.boosting), infoX, infoY+infoOffset*2)
	--Stats
	love.graphics.setColor(.6,.6,.8)
	love.graphics.print("Food Eaten: "..cret.foodEaten, infoX, infoY + infoOffset*3)
	love.graphics.print("Children Birthed: "..cret.childrenBirthed, infoX, infoY + infoOffset*4)
	love.graphics.print("Children Alive: "..#cret.childrenAlive, infoX, infoY + infoOffset*5)
	love.graphics.print("Generation: "..cret.generation, infoX, infoY + infoOffset*6)
	--Bottom Info
	love.graphics.setColor(.4,.8,.7)
	local descendantsAlive = #cret.descendantsAlive
	local addval = 1
	if not cret.alive then addval = 0 end
	love.graphics.print("Descendants Alive: "..descendantsAlive.." ("..round((descendantsAlive+addval)/game.pop*100, 0).."%)", bInfoX, bInfoY + infoOffset*0 )
	love.graphics.print("Descendants Total: "..cret.descendants, bInfoX, bInfoY + infoOffset*1)
	--Cret Image
	local xAdd = 210
	local yAdd = 10
	local width = 1.5
	local x, y = bInfoX+xAdd, bInfoY + yAdd
	local bgWidth = width*30
	love.graphics.setColor(1,1,1,.1)
	love.graphics.rectangle("fill", x-bgWidth/2, y-bgWidth/2, bgWidth, bgWidth)
	graphics.drawCret(cret, x, y, width*cret.width)
end