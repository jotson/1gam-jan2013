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

Fuel = Sprite:extend{
    acceleration = { x = 0, y = 0 },

    onNew = function(self)
        self.x = math.random(0, love.graphics.getWidth())
        self.y = math.random(0, love.graphics.getHeight())
        self.velocity = { x = math.random(-25,25) , y = math.random(-25,25), rotation = math.random(-math.pi, math.pi) }
        self.size = math.random(5,30)
        self.width = self.size
        self.height = self.size
    end,

    onDraw = function(self, x, y)
        love.graphics.push()

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setLineWidth(1)
        love.graphics.translate(x, y)
        love.graphics.rotate(self.rotation)
        love.graphics.circle("line", 0, 0, self.size, 5)

        love.graphics.pop()
    end,

    onCollide = function(self, other, x_overlap, y_overlap)
        if other == player then
            player:addFuel(self.size)
            fuel:destroy(self)
            return
        end

        -- for i = 1, table.getn(fuel.list) do
        --     if other == fuel.list[i] then
        --         -- collision with another fuel
        --         return
        --     end
        -- end
    end,

    onUpdate = function(self, dt)
        self:collide(player)

        -- for i = 1, table.getn(fuel.list) do
        --     self:collide(fuel.list[i])
        -- end

        if self.x < self.size then
            self.x = self.size
            self.velocity.x = -self.velocity.x
        end
        if self.x > love.graphics.getWidth() - self.size then
            self.x = love.graphics.getWidth() - self.size
            self.velocity.x = -self.velocity.x
        end
        if self.y < self.size then
            self.y = self.size
            self.velocity.y = -self.velocity.y
        end
        if self.y > love.graphics.getHeight() - self.size then
            self.y = love.graphics.getHeight() - self.size
            self.velocity.y = -self.velocity.y
        end
    end,
}

fuel = {
    list = {},

    create = function(self, n)
        if n == nil then n = 1 end

        for i = 1,n do
            f = Fuel:new()
            table.insert(self.list, f)
            the.app:add(f)
        end
    end,

    destroy = function(self, object)
        for i = 1, table.getn(self.list) do
            if self.list[i] == object then
                table.remove(self.list, i)
                object:die()
            end
        end
    end
}
