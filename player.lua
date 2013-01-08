-- January2013
-- Copyright © 2013 John Watson <john@watson-net.com>

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

THRUST = 60
STARTING_FUEL = 100
MAX_FUEL = 100
FUEL_BURN_PER_SECOND = 25

player = Sprite:new{
    SEGMENTS = 8,
    acceleration = { x = 0, y = 0 },
    drag = { x = THRUST/10, y = THRUST/10 },
    radius = 10,
    exhaust_period = 0.1,
    exhaust_elapsed = 0,
    is_thrusting = false,
    fuel = STARTING_FUEL,

    onDraw = function(self, x, y)
        love.graphics.push()

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", x, y, self.radius, self.SEGMENTS)

        -- Draw fuel guage
        if self.fuel > 0 then
            a1 = -math.pi/2
            a2 = -math.pi/2 + 2 * math.pi * self.fuel / MAX_FUEL
            if self.fuel > MAX_FUEL * 0.5 then
                love.graphics.setColor(0, 255, 0, 200)
            elseif self.fuel > MAX_FUEL * 0.25 then
                love.graphics.setColor(255, 255, 0, 200)
            elseif self.fuel > MAX_FUEL * 0 then
                love.graphics.setColor(255, 0, 0, 200)
            end
            love.graphics.arc("fill", x, y, self.radius-3, a1, a2, self.SEGMENTS)
        else
            -- love.graphics.setColor(255, 0, 0, 200)
            -- love.graphics.print("E", self.x-4, self.y-7)
            love.graphics.setColor(255, 0, 0, 200)
            love.graphics.arc("line", x, y, self.radius/3, 0, math.pi * 2, self.SEGMENTS)
        end

        love.graphics.pop()
    end,

    thrust = function(self, x, y)
        if self.fuel <= 0 then
            return
        end

        if x ~= nil then self.acceleration.x = x end
        if y ~= nil then self.acceleration.y = y end

        if self.thrust_snd:isStopped() then
            love.audio.play(self.thrust_snd)
        end

        self.is_thrusting = true
    end,

    addFuel = function(self, fuel)
        if fuel > 0 and self.fuel >= MAX_FUEL then
            the.app.surplus_fuel = the.app.surplus_fuel + fuel
        else
            self.fuel = self.fuel + fuel
        end
        if self.fuel <= 0 then
            self.fuel = 0
            love.audio.play(self.out_of_fuel_snd)
        end
    end,

    onNew = function(self)
        self.thrust_snd = love.audio.newSource("snd/thrust.ogg", "static")
        self.thrust_snd:setLooping(true)
        self.out_of_fuel_snd = love.audio.newSource("snd/out_of_fuel.ogg", "static")

        self.x = arena.width/2
        self.y = arena.height/2
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
            self.velocity.x = -self.velocity.x
        end
        if self.x > arena.width - self.radius then
            self.x = arena.width - self.radius
            self.velocity.x = -self.velocity.x
        end
        if self.y < self.radius then
            self.y = self.radius
            self.velocity.y = -self.velocity.y
        end
        if self.y > arena.height - self.radius then
            self.y = arena.height - self.radius
            self.velocity.y = -self.velocity.y
        end

        if self.is_thrusting then
            self:addFuel(-FUEL_BURN_PER_SECOND * dt)

            if self.exhaust_elapsed > self.exhaust_period then
                the.view.factory:create(Exhaust)
                self.exhaust_elapsed = 0
            end
        else
            self.thrust_snd:stop()
        end

        self.exhaust_elapsed = self.exhaust_elapsed + dt

        self.acceleration.x = 0
        self.acceleration.y = 0
        self.is_thrusting = false
    end
}

Exhaust = Sprite:extend{
    MAX_RADIUS = 3,
    lifetime = 0.5,
    elapsed = 0,
    alpha = 255,
    width = 1,
    height = 1,

    onNew = function(self)
        the.app:add(self)
    end,

    onReset = function(self)
        self.elapsed = 0
        a = math.max(math.abs(player.acceleration.x), math.abs(player.acceleration.y))
        self.x = player.x - player.radius * player.acceleration.x/a
        self.y = player.y - player.radius * player.acceleration.y/a
        self.velocity.x = -player.acceleration.x*1.5 + player.velocity.x + math.random(-THRUST/10,THRUST/10)
        self.velocity.y = -player.acceleration.y*1.5 + player.velocity.y + math.random(-THRUST/10,THRUST/10)
        self.starting_alpha = math.random(255,255)
        self.radius = 1
    end,

    onUpdate = function(self, dt)
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.lifetime then
            the.view.factory:recycle(self)
        end

        self.radius = 1 + self.MAX_RADIUS * self.elapsed/self.lifetime
        self.alpha = self.starting_alpha * (1 - self.elapsed/self.lifetime)
    end,

    onDraw = function(self, x, y)
        love.graphics.push()

        love.graphics.setColor(255, 255, 255, self.alpha)
        love.graphics.circle("line", x, y, self.radius, 10)

        love.graphics.pop()
    end
}
