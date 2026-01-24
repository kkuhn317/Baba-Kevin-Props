-- Add Fast to object list

table.insert(editor_objlist_order, "text_fast")

-- This defines the exact data for them (note that since the sprites are specific to this levelpack, sprite_in_root must be false!)

-- (B)

editor_objlist["text_fast"] = 
{
	name = "text_fast",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_quality"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {2, 1},
	colour_active = {2, 2},
}

-- After adding new objects to the list, formatobjlist() must be run to setup everything correctly.

formatobjlist() -- (C)


-- table to hold what objects we need to make fast when they move
fastobjsleft = {}

-- Hooks here

table.insert(mod_hook_functions["command_given"],
	function ()
        fastobjsleft = findallfeature(nil, "is", "fast")
    end
)

table.insert(mod_hook_functions["turn_auto"],
    function ()
        fastobjsleft = findallfeature(nil, "is", "fast")
    end
)

table.insert(mod_hook_functions["movement_take"],
    function(args)
        local moving_units, take = args[1], args[2]
        for i,data in ipairs(moving_units) do
            local fastness = 0
            for j = #fastobjsleft, 1, -1 do
                local v = fastobjsleft[j]
                if (v == data.unitid) then
                    fastness = fastness + 1
                    table.remove(fastobjsleft, j)
                end
            end
            print("fastness: " .. tostring(fastness))
            print("movingdata: " .. tostring(data))
            print("moving: " .. tostring(i))
            print("moves left: " .. tostring(data.moves))
            data.moves = data.moves * (fastness + 1)
        end
    end
)