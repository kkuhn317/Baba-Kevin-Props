-- Add to object list

table.insert(editor_objlist_order, "text_blind")

-- This defines the exact data for them (note that since the sprites are specific to this levelpack, sprite_in_root must be false!)

-- (B)

editor_objlist["text_blind"] = 
{
	name = "text_blind",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_quality"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 1},
	colour_active = {0, 1},
}

-- After adding new objects to the list, formatobjlist() must be run to setup everything correctly.

formatobjlist() -- (C)


-- Hooks here


table.insert(mod_hook_functions["effect_once"],
    function()
		-- TODO: make this work with undo and make it not as laggy
        -- for i,unit in ipairs(units) do
        --     local name = getname(unit)
		-- 	local blind = hasfeature(name,"is","blind",unit.fixed)
		-- 	if (blind ~= nil) then
		-- 		MF_changesprite(unit.fixed, name .."_blind", false)
		-- 	else
		-- 		MF_changesprite(unit.fixed, name, true)
		-- 	end
		-- end
    end
)