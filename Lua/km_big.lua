-- Add to object list

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

table.insert(mod_hook_functions["effect_always"],
    function()

        -- set scale for all units based on big prop
        for i,unit in ipairs(units) do
            local name = getname(unit)
			local newscale = hasfeature_count(name,"is","big",unit.fixed) + 1
            unit.scaleX = newscale * generaldata2.values[ZOOM] * spritedata.values[TILEMULT]
            unit.scaleY = newscale * generaldata2.values[ZOOM] * spritedata.values[TILEMULT]
		end
    end
)