function graphics.drawFood(food)
	--Background circle
	love.graphics.setColor(.2,.2,.2,.7)
	love.graphics.circle("fill", food.x, food.y, 30)

	love.graphics.setColor(conf.food.color)
	love.graphics.circle("fill", food.x, food.y, conf.food.width)

	line.set(2)
	local hb = conf.food.hitbox + 3
	love.graphics.setColor(.3,.3,1)
	love.graphics.rectangle("line", food.x-hb/2, food.y-hb/2, hb, hb)
	line.pop()
end
