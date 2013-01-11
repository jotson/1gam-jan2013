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
require 'score'
require 'levels'

the.app = App:new{
    STATE_START = 1,
    STATE_GAMEOVER = 2,
    STATE_PLAYING = 3,

    name = "#onegameamonth jan/2013",
    shake = 0,
    level = 1,

    onRun = function(self)
        self.small_font = love.graphics.newFont("fnt/jupiter.ttf", 16)
        self.big_font = love.graphics.newFont("fnt/jupiter.ttf", 30)
        self.huge_font = love.graphics.newFont("fnt/jupiter.ttf", 40)
        self.enemy_font = love.graphics.newFont("fnt/8thcargo.ttf", 16) -- No symbols

        self.start_overlay = love.graphics.newImage("img/start.png")

        -- Sprite for showing level information
        self.level_spr = Text:new{
            text = "",
            font = {"fnt/jupiter.ttf", 36},
            align = "center",
            width = arena.width,
            height = 50,
            alpha = 0,
            x = 0,
            y = 0,

            show = function(self, text, seconds)
                self.alpha = 1
                self.text = text
                the.view.tween:start(self, 'alpha', 0, seconds, "quadIn")
            end
        }
        self:add(self.level_spr)

        -- Sprite for showing tips
        self.tip_spr = Text:new{
            text = "",
            font = {"fnt/jupiter.ttf", 36},
            align = "center",
            width = arena.width,
            height = 50,
            alpha = 0,
            x = 0,
            y = 50,

            show = function(self, text, seconds)
                self.alpha = 1
                self.text = text
                the.view.tween:start(self, 'alpha', 0, seconds, "quadIn")
            end
        }
        self:add(self.tip_spr)

        self:add(arena)
        fuel:create(20)
        enemies:create(3)

        self.enemy_start = Enemy:new()

        score:startGame()
        the.view.timer:every(1, function() score:update() end)

        self:changeState(self.STATE_START)
    end,

    changeState = function(self, state)
        if state == self.STATE_START then
            player.state = player.STATE_DEAD
            self:add(self.enemy_start)

            self.state = state
        end

        if state == self.STATE_PLAYING then
            self:remove(self.enemy_start)

            self.state = state
        end

        if state == self.STATE_GAMEOVER then
            player.state = player.STATE_DEAD
            the.app:remove(player)

            self.state = state
        end
    end,

    onUpdate = function(self)
        if self.state == self.STATE_START then
            self:updateStart()
        end

        if self.state == self.STATE_GAMEOVER then
            self:updateGameover()
        end

        if self.state == self.STATE_PLAYING then
            self:updatePlaying()
        end
    end,

    updateStart = function(self)
        -- Adapt an enemy for use on the start screen
        self.enemy_start.x = arena.width - 150
        self.enemy_start.y = arena.height - 100
        self.enemy_start.state = Enemy.STATE_HOMING
        self.enemy_start.scale = 8
        if not self.enemy_start.scan_snd:isStopped() then
            self.enemy_start.scan_snd:stop()
        end

        if the.keys:justPressed('escape') then
            love.event.push("quit")
        end

        if the.keys:justPressed('1', '2', '3', '4', '5', '6', '7', '8', '9') then
            self:changeState(self.STATE_PLAYING)
            
            score:startGame()

            fuel:destroyAll()
            enemies:destroyAll()

            self:add(player)
            player:reset()

            self.level = string.byte(the.keys.typed) - string.byte('0')
            self.level_spr:show("LEVEL " .. self.level, 4)
            if levels[self.level].tip then
                self.tip_spr:show(levels[self.level].tip, 6)
            end
            fuel:create(20)
            enemies:create(levels[self.level].enemies)

            -- self.view.focus = player
            -- self.view:clampTo(arena)
        end
    end,

    updateGameover = function(self)
        if the.keys:justPressed('escape') then
            love.event.push("quit")
        end

        if the.keys:justPressed(' ') then
            self:changeState(self.STATE_START)
        end
    end,

    updatePlaying = function(self)
        if the.keys:justPressed('escape') then
            self:changeState(self.STATE_START)
        end
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
        if the.keys:pressed('0') then
            player:selfDestruct()
        end

        -- TODO Level advance
    end,

    onDraw = function(self)
        if self.state == self.STATE_START then
            self:drawStart()
        end

        if self.state == self.STATE_GAMEOVER then
            self:drawGameover()
        end

        if self.state == self.STATE_PLAYING then
            self:drawPlaying()
        end
    end,

    drawStart = function(self)
        drawHUD()

        local blink_factor = math.abs(math.sin(love.timer.getMicroTime()*1.2))

        -- love.graphics.setColor(0, 0, 0, 160)
        -- love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(self.start_overlay, 0, 0)

        love.graphics.setFont(self.big_font)
        local titles = "One Game A Month\nJanuary 2013\n\nProgramming, art, music, sound, and design by John Watson\nflagrantdisregard.com\n\nSource + dev journal @ \ngithub.com/jotson/OGAM-January2013\n\n(c) 2013 John Watson\nLicensed under the MIT license"
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf(titles, 403, 53, 350, "right")
        love.graphics.setColor(100, 200, 255, 255)
        love.graphics.printf(titles, 400, 50, 350, "right")

        love.graphics.setFont(self.huge_font)
        love.graphics.setColor(255, 255, 255, blink_factor*200+55)
        love.graphics.printf("PRESS NUMBER KEY TO SELECT LEVEL", 0, arena.height+10, arena.width, "center")
        love.graphics.printf("[ESC] TO QUIT", 0, arena.height+40, arena.width, "center")
    end,

    drawGameover = function(self)
        drawHUD()

        local blink_factor = math.abs(math.sin(love.timer.getMicroTime()*1.2))

        love.graphics.setColor(0, 0, 0, 160)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setFont(self.huge_font)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf("GAME OVER", 0, arena.height/2 - 50, arena.width, "center")
        love.graphics.printf("SCORE: " .. score:getTotalFuel(), 0, arena.height/2, arena.width, "center")
        love.graphics.setColor(255, 255, 255, blink_factor*200+55)
        love.graphics.printf("[SPACE] TO RE-START /// [ESC] TO QUIT", 0, arena.height+20, arena.width, "center")
    end,

    drawPlaying = function(self)
        drawHUD()

        -- Simple camera shake
        if self.shake ~= 0 then
            if the.view.focus then
                the.view.focusOffset = { x = math.random(-self.shake, self.shake), y = math.random(-self.shake, self.shake)}
            else
                the.view:panTo({ love.graphics.getWidth()/2 + math.random(-self.shake, self.shake), love.graphics.getHeight()/2 + math.random(-self.shake, self.shake)}, 0)
            end
        else
            the.view.focusOffset = { x = 0, y = 0 }
        end
        self.shake = 0
    end,
}
