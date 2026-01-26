-- Add to object list

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

-- table of pairs of objects and reasons that we did the fast change on
fastdone = {}

-- Hooks here

table.insert(mod_hook_functions["turn_auto"],
    function()
        fastdone = {}
    end
)

table.insert(mod_hook_functions["command_given"],
    function()
        fastdone = {}
    end
)

table.insert(mod_hook_functions["movement_take"],
    function(args)
        local moving_units, take = args[1], args[2]
        for i,data in ipairs(moving_units) do
            -- if unitid and reason is in list of fastdone, skip
            local done = false
            for j = #fastdone, 1, -1 do
                if (fastdone[j].unitid == data.unitid) and (fastdone[j].reason == data.reason) then
                    done = true
                end
            end

            if done == false then
                table.insert(fastdone, {unitid = data.unitid, reason = data.reason})

                -- figure out how fast it is
                local fastness = 0
                fastobjs = findallfeature(nil, "is", "fast")
                for j = #fastobjs, 1, -1 do
                    if (fastobjs[j] == data.unitid) then
                        fastness = fastness + 1
                    end
                end
                -- print("fastness: " .. tostring(fastness))
                -- print("movingdata: " .. tostring(data))
                -- print("moving: " .. tostring(i))
                -- print("moves left: " .. tostring(data.moves))
                data.moves = data.moves * (fastness + 1)
            end
        end
    end
)