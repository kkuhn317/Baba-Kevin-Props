-- Add Heavy to object list

table.insert(editor_objlist_order, "text_heavy")

-- This defines the exact data for them (note that since the sprites are specific to this levelpack, sprite_in_root must be false!)

-- (B)

editor_objlist["text_heavy"] = 
{
	name = "text_heavy",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_quality"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {6, 0},
	colour_active = {6, 1},
}

-- After adding new objects to the list, formatobjlist() must be run to setup everything correctly.

formatobjlist() -- (C)

-- Make a table to hold the objects that are heavy for each timestep
heavy_objects = {}
-- Each entry in heavy_objects will be a list (table) of dictionaries for that timestep


-- Hooks here
table.insert(mod_hook_functions["level_start"],
	function()
		--timedmessage("Starting a new level!")
        print("Level Started!")

        heavy_objects = {}
        table.insert(heavy_objects, {})
	end
)

table.insert(mod_hook_functions["effect_once"],
    function()
        print("effect once")
        -- Copy the last entry in heavy_objects (shallow copy)
        local last = heavy_objects[#heavy_objects]
        local copy = {}
        if last then
            for k, v in pairs(last) do
                copy[k] = v
            end
        end
        table.insert(heavy_objects, copy)
    end
)

table.insert(mod_hook_functions["undoed_after"],
    function ()
        print("undoed after")
        for i = 1, 2 do
            table.remove(heavy_objects)
        end
        -- Copy the last entry in heavy_objects (shallow copy)
        local last = heavy_objects[#heavy_objects]
        local copy = {}
        if last then
            for k, v in pairs(last) do
                copy[k] = v
            end
        end
        table.insert(heavy_objects, copy)
    end
)