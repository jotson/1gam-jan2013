require 'zoetrope'

THRUST = 60

player = Sprite:new{
    x = 0,
    y = 0,
    acceleration = { x = 0, y = 0 },
    drag = { x = THRUST/5, y = THRUST/5 },
    radius = 10,

    draw = function(self)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.circle("line", self.x, self.y, self.radius, 10)
    end,

    onNew = function(self)
        self.width = self.radius
        self.height = self.radius
        self.maxVelocity.x = 100
        self.maxVelocity.y = 100
        self.minVelocity.x = -100
        self.minVelocity.y = -100
    end,

    onUpdate = function(self, dt)
        self.acceleration.x = 0
        self.acceleration.y = 0

        if self.x < self.radius then
            self.x = self.radius
            self.velocity.x = -self.velocity.x/2
            self.acceleration.x = 0
        end
        if self.x > love.graphics.getWidth() - self.radius then
            self.x = love.graphics.getWidth() - self.radius
            self.velocity.x = -self.velocity.x/2
            self.acceleration.x = 0
            self.vx = 0
        end
        if self.y < self.radius then
            self.y = self.radius
            self.velocity.y = -self.velocity.y/2
            self.acceleration.y = 0
            self.vy = 0
        end
        if self.y > love.graphics.getHeight() - self.radius then
            self.y = love.graphics.getHeight() - self.radius
            self.velocity.y = -self.velocity.y/2
            self.acceleration. y = 0
            self.vy = 0
        end
    end
}

the.app = App:new{
    onRun = function(self)
        player.x = love.graphics.getWidth()/2
        player.y = love.graphics.getHeight()/2
        self:add(player)
    end,

    onUpdate = function(self)
        if the.keys:pressed('w') then
            player.acceleration.y = -THRUST
        end
        if the.keys:pressed('s') then
            player.acceleration.y = THRUST
        end
        if the.keys:pressed('a') then
            player.acceleration.x = -THRUST
        end
        if the.keys:pressed('d') then
            player.acceleration.x = THRUST
        end
    end
}
