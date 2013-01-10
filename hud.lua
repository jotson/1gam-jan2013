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

function drawHUD()
    love.graphics.push()

    love.graphics.setFont(the.app.big_font)
    love.graphics.setColor(100, 200, 255, math.random(100,150))

    -- Draw score graph
    local BARS = 60
    local MAX_HEIGHT = 80
    local max = 0
    for i = #score.graph-BARS, #score.graph do
        if score.graph[i] then
            max = math.max(score.graph[i], max)
        end
    end
    if max == 0 then max = 1 end
    local w = 4
    for n = 0, BARS-1 do
        i = #score.graph - n
        if score.graph[i] then
            love.graphics.rectangle("fill", 1 + n * (w+1), arena.height+1, w, score.graph[i]/max * MAX_HEIGHT + 1)
        else
            love.graphics.rectangle("fill", 1 + n * (w+1), arena.height+1, w, 1)
        end
    end

    -- Fuel/minute gauge
    local x1 = 320
    local x2 = 430
    love.graphics.print("FUEL/MIN", x1, arena.height)
    love.graphics.print(score:getFuelPerMinute(), x2, arena.height)

    love.graphics.print("TOTAL", x1, arena.height+20)
    love.graphics.print(score:getTotalFuel(), x2, arena.height+20)

    -- Static
    love.graphics.setColor(255, 255, 255, math.random(50,100))
    for i = 1,2000 do
        love.graphics.point(math.random(0, arena.width), math.random(arena.height, arena.height+100))
    end

    love.graphics.pop()
end
