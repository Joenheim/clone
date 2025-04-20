--tbd clone game using tables  instead of the weird oop

--attacks
function create_attack(sprite, x, y, direction_x, direction_y, speed)
    --local helper, didn't know you could do functions within it!
    local attack = {

        x = x,
        y = y,
        direction_x = direction_x,
        direction_y = direction_y,
        speed = speed,
        sprite = sprite,

        update = function(self)
            --movement based on +/- values * speed
            self.x += self.direction_x * self.speed
            self.y += self.direction_y * self.speed

            --despawning attacks
            if self.x > 128 or self.x < 0 or self.y > 128 or self.y < 0  then
                del(attacks, self)
            end
        end,

        draw = function(self)
            spr(self.sprite, self.x, self.y)
        end,
    }
    add(attacks, attack)
end

--player
player = {
    --various stats
    x = 64,
    y = 64,
    sprite = 1,
    speed = 1.5,
    --x/y movement simplified
    movement = {
        [0] = {x = -1, y = 0},
        [1] = {x = 1, y = 0},
        [2] = {x = 0, y = -1},
        [3] = {x = 0, y = 1},
    },
    --the actual movement
    update = function(self)
        for button, motion in pairs(self.movement) do
            if btn(button) then
            self.x += motion.x * self.speed
            self.y += motion.y * self.speed
            end
        end
        --attacks
        --regular left to right
        if btnp(4) then --(spr, x, y, dir_x, dir_y, speed)
            create_attack(2, self.x + 4, self.y + 4, 0, -1, 4)
        end
        --spread tester
        if btnp(5) then
            create_attack(21, self.x +4, self.y + 0, 1, 0, 4)
            create_attack(21, self.x +4, self.y - 4, 1, -0.1, 4)
            create_attack(21, self.x +4, self.y + 4, 1, 0.1, 4)
        end
    end,
    --drawing our intrepid hero
    draw = function(self)
        spr(self.sprite, self.x, self.y)
    end
}

--randomly spawning tiles, need to play with mset
--tiles first
forest_tiles = {
    --tester set sprites 33-46
    --tiles = {33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46,}
    --learning about inline loops
    tiles = (function()
        local t = {}
        for i = 33, 46 do  -- range of sprites
            add(t, i)
        end
        return t
    end)(),


    --spawning logic
    spawn = function(self) --mset uses cells, so each map is 0-15
        for x = 0, 15 do
            for y = 0, 15 do
                if rnd(1)<0.15 then -- % to spawn
                    mset(x, y, rnd(self.tiles))
                end
            end
        end
    end,


}

function initial_variables()
    attacks = {}
    forest_tiles:spawn() --test before using some knd of game state
end

function _init()
    initial_variables()
end

function _update()
    player:update()
    for atk in all(attacks) do
        atk:update()
    end
end

function _draw()
    cls()
    map()
    player:draw()
    for atk in all(attacks) do
        atk:draw()
    end
end