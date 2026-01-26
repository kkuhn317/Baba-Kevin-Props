-- Add to object list

table.insert(editor_objlist_order, "text_helt")

-- This defines the exact data for them (note that since the sprites are specific to this levelpack, sprite_in_root must be false!)

-- (B)

editor_objlist["text_helt"] = 
{
	name = "text_helt",
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

