-- Add Big to object list

table.insert(editor_objlist_order, "text_big")

-- This defines the exact data for them (note that since the sprites are specific to this levelpack, sprite_in_root must be false!)

-- (B)

editor_objlist["text_big"] = 
{
	name = "text_big",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_quality"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {4, 0},
	colour_active = {4, 1},
}

-- After adding new objects to the list, formatobjlist() must be run to setup everything correctly.

formatobjlist() -- (C)


-- Hooks here

table.insert(mod_hook_functions["effect_once"],
    function()
        -- Find all "big" objects
        local objects = findallfeature(nil, "is", "big", true)
            
        -- v is unitid
        for i,v in ipairs(objects) do
            local obj = mmf.newObject(v)
            obj.scaleX = 4
            obj.scaleY = 4
        end
    end
)