-- Add to object list

table.insert(editor_objlist_order, "text_alone")
table.insert(editor_objlist_order, "text_friend")

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
editor_objlist["text_friend"] = 
{
	name = "text_friend",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_quality"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {5, 3},
	colour_active = {5, 4},
}

-- After adding new objects to the list, formatobjlist() must be run to setup everything correctly.

formatobjlist() -- (C)


-- Hooks here