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
    speed = 2,
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
        if btnp(4) then --(spr, x, y, dir_x, dir_y, speed)
            create_attack(2, self.x + 4, self.y + 4, 0, -1, 4)
        end
        if btnp(5) then
            create_attack(54, self.x +4, self.y + 0, 1, 0, 4)
            create_attack(54, self.x +4, self.y - 2, 1, -0.1, 4)
            create_attack(54, self.x +4, self.y + 2, 1, 0.1, 4)
        end
    end,
    --drawing our intrepid hero
    draw = function(self)
        spr(self.sprite, self.x, self.y)
    end
}

function initial_variables()
    attacks = {}
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
    player:draw()
    for atk in all(attacks) do
        atk:draw()
    end
    print(#attacks)
end