-- Add to object list

table.insert(editor_objlist_order, "text_alone")

-- This defines the exact data for them (note that since the sprites are specific to this levelpack, sprite_in_root must be false!)

-- (B)

editor_objlist["text_alone"] = 
{
	name = "text_alone",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_quality"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
}

-- After adding new objects to the list, formatobjlist() must be run to setup everything correctly.

formatobjlist() -- (C)


-- Hooks here

table.insert(mod_hook_functions["block"],
    function()
        -- Find all "alone" objects
        local lonelyobjs = getunitswitheffect("alone", false)

        for id,unit in ipairs(lonelyobjs) do
            local x,y,dir = unit.values[XPOS],unit.values[YPOS], unit.values[DIR]
            local stuff = findallhere(x,y)

            -- find everything on same spot
            if (#stuff > 0) then
                local moved = false
                for i,v in pairs(stuff) do
                    if (v ~= unit.fixed) and (not moved) then
                        local ndirs = {
                            [0] = {1, 0},
                            [1] = {0, -1},
                            [2] = {-1, 0},
                            [3] = {0, 1}
                        }

                        -- check in front of the object for any object, then to the right, then to the left, then behind
                        local check_order = {
                            dir,                -- Front
                            (dir + 3) % 4,      -- Right
                            (dir + 1) % 4,      -- Left
                            (dir + 2) % 4,      -- Behind
                        }

                        for _, check_dir in ipairs(check_order) do
                            local dx, dy = ndirs[check_dir][1], ndirs[check_dir][2]
                            local tx, ty = x + dx, y + dy
                            
                            local obst = findallhere(tx, ty)
                            if (#obst == 0) then
                                -- move to the first empty space found like this
                                move(unit.fixed, dx, dy, check_dir, {})
                                moved = true
                                break
                            end
                        end
                    end
                end
            end

        end
            
    
    end
)