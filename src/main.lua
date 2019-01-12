math.randomseed(os.time())
math.random()

require("conf")
require("game")
require("util")
require("graphics")
require("input")
---------------
require("brain")
require("cret")

function love.load()
	if conf.window.fullScreen then
		love.window.setMode(0,0)
		conf.window.width, conf.window.height = love.graphics.getDimensions()
	else
		love.window.setMode(conf.window.width, conf.window.height)
	end
	love.window.setTitle("Cret World")
end


--Run game tick
function game.doTick()
	local dt = game.dt
	for i=1, game.timeScale do
		game.tick = game.tick + 1
		Cret:update(dt)
		Food:update(dt)
	end
end

--Update
function love.update(dt)
	game.dt = dt
	--Mouse
	mouseX, mouseY = love.mouse.getPosition()

	--Screen mouse position
	ui.mouse.x, ui.mouse.y = mouseX, mouseY

	if game.pause then return end
	game.doTick()
end

function love.mousepressed(x, y, button)
	input.mousepressed(x, y, button)
end

function love.keypressed(key)
	input.keypressed(key)
end


--Draw
local blue = {.2,.2,.4}
love.graphics.setBackgroundColor(blue)
function love.draw()
	Food:draw()	
	Cret:draw()

	--Draw selected cret brain
	if input.selected then
		graphics.drawSelectedCret(input.selected)
		ui.drawCretInfo(input.selected)
	end

	--Draw info panel
	ui.drawInfo()
end
