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

hud = {
    bg = nil,

    draw = function(self)
        love.graphics.push()

        if the.app.state == the.app.STATE_START then
            love.graphics.setColor(255, 0, 0, 255)
            love.graphics.draw(self.bg, 0, arena.height)
        else
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.draw(self.bg, 0, arena.height)
        end

        love.graphics.setColor(100, 200, 255, math.random(100,150))

        if the.app.state == the.app.STATE_PLAYING or the.app.state == the.app.STATE_GAMEOVER then
            -- Draw score graph
            local BARS = 51
            local MAX_HEIGHT = 80
            local max = 0
            for i = #score.level_graph-BARS, #score.level_graph do
                if score.level_graph[i] then
                    max = math.max(score.level_graph[i], max)
                end
            end
            if max == 0 then max = 1 end
            local w = 3
            for n = 0, BARS-1 do
                i = #score.level_graph - n
                if score.level_graph[i] then
                    love.graphics.rectangle("fill", 15 + n * (w+1), arena.height+9, w, score.level_graph[i]/max * MAX_HEIGHT + 1)
                else
                    love.graphics.rectangle("fill", 15 + n * (w+1), arena.height+9, w, 1)
                end
            end

            -- Fuel/minute gauge
            love.graphics.setFont(the.app.small_font)
            love.graphics.print("FPM " .. score:getFuelPerMinute(), 223, arena.height+80)

            -- Level
            love.graphics.print("LVL".. the.app.level, 418, arena.height+80)

            -- Random
            love.graphics.print(math.random(1000,9999)/10, 352, arena.height+80)

            -- Score
            love.graphics.setFont(the.app.big_font)
            local n = score:getScore()
            love.graphics.printf(n, 535, arena.height+43, 150, "center")

            -- Fuel tank
            local tank_height = 65
            local tank_fill = score:getFuel()/levels[the.app.level].fuel * tank_height
            love.graphics.setColor(100, 255, 200, math.random(100, 150))
            love.graphics.rectangle("fill", 226, arena.height+10+tank_height-tank_fill, 40, tank_fill)
        end

        self:drawStatic(7, arena.height+8, 215, 86)
        self:drawStatic(528, arena.height+40, 164, 48)

        love.graphics.pop()
    end,

    drawStatic = function(self, x, y, w, h)
        love.graphics.setColor(255, 255, 255, math.random(40,80))
        for i = 1,w*h/20 do
            love.graphics.point(math.random(x, x+w), math.random(y, y+h))
        end
    end,

    drawGauge = function(self, x, y, r, min, max, value)
    end
}