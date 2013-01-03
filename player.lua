THRUST = 60

player = Sprite:new{
    x = 0,
    y = 0,
    acceleration = { x = 0, y = 0 },
    drag = { x = THRUST/5, y = THRUST/5 },
    radius = 10,

    draw = function(self)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.circle("line", self.x, self.y, self.radius, 8)
    end,

    onNew = function(self)
        self.x = love.graphics.getWidth()/2
        self.y = love.graphics.getHeight()/2
        self.width = self.radius
        self.height = self.radius
        self.maxVelocity.x = 100
        self.maxVelocity.y = 100
        self.minVelocity.x = -100
        self.minVelocity.y = -100
    end,

    onUpdate = function(self, dt)
        if self.x < self.radius then
            self.x = self.radius
            self.velocity.x = -self.velocity.x/2
        end
        if self.x > love.graphics.getWidth() - self.radius then
            self.x = love.graphics.getWidth() - self.radius
            self.velocity.x = -self.velocity.x/2
            self.vx = 0
        end
        if self.y < self.radius then
            self.y = self.radius
            self.velocity.y = -self.velocity.y/2
            self.vy = 0
        end
        if self.y > love.graphics.getHeight() - self.radius then
            self.y = love.graphics.getHeight() - self.radius
            self.velocity.y = -self.velocity.y/2
            self.vy = 0
        end

        if self.acceleration.x ~= 0 or self.acceleration.y ~= 0 then
            the.view.factory:create(Exhaust)
        end

        self.acceleration.x = 0
        self.acceleration.y = 0
    end
}

Exhaust = Sprite:extend{
    radius = 1,
    MAX_RADIUS = 4,
    lifetime = 0.5,
    elapsed = 0,
    alpha = 255,

    onNew = function(self)
        the.app:add(self)
        self:onReset(self)
    end,

    onReset = function(self)
        self.visible = true
        self.elapsed = 0
        a = math.max(math.abs(player.acceleration.x), math.abs(player.acceleration.y))
        self.x = player.x - player.radius * player.acceleration.x/a
        self.y = player.y - player.radius * player.acceleration.y/a
        self.radius = 1
        self.velocity.x = -player.acceleration.x + player.velocity.x + math.random(-THRUST/10,THRUST/10)
        self.velocity.y = -player.acceleration.y + player.velocity.y + math.random(-THRUST/10,THRUST/10)
        self.starting_alpha = math.random(50,255)
    end,

    onUpdate = function(self, dt)
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.lifetime then
            the.view.factory:recycle(self)
            return
        end

        self.radius = self.MAX_RADIUS * self.elapsed/self.lifetime
        self.alpha = self.starting_alpha * (1 - self.elapsed/self.lifetime)
    end,

    draw = function(self)
        love.graphics.setColor(255, 255, 255, self.alpha)
        love.graphics.circle("line", self.x, self.y, self.radius, 10)
    end
}
