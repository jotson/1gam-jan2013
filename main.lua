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

DEBUG = true
STRICT = true

require 'zoetrope'
require 'shaders'
require 'arena'
require 'player'
require 'fuel'
require 'hud'
require 'enemy'

the.app = App:new{
    name = "#onegameamonth jan/2013",
    fuel = {},
    surplus_fuel = 0,
    shake = 0,

    onRun = function(self)
        self:add(arena)
        self:add(player)
        fuel:create(20)
        -- self.view.focus = player
        -- self.view:clampTo(arena)
        Enemy:new()
        Enemy:new()
        Enemy:new()
    end,

    onUpdate = function(self)
        if the.keys:pressed('w') then
            player:thrust(nil, -player.THRUST)
        end
        if the.keys:pressed('s') then
            player:thrust(nil, player.THRUST)
        end
        if the.keys:pressed('a') then
            player:thrust(-player.THRUST, nil)
        end
        if the.keys:pressed('d') then
            player:thrust(player.THRUST, nil)
        end
    end,

    onDraw = function(self)
        drawHUD()

        -- Simple camera shake
        if self.shake ~= 0 then
            the.view:panTo({ love.graphics.getWidth()/2 + math.random(-self.shake, self.shake), love.graphics.getHeight()/2 + math.random(-self.shake, self.shake)}, 0)
        end
        self.shake = 0
    end
}
