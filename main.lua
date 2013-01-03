require 'zoetrope'
require 'player'

DEBUG = true

the.app = App:new{
    name = "#onegameamonth jan/2013",
    
    onRun = function(self)
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
