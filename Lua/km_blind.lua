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

blindobjs = {}


table.insert(mod_hook_functions["level_start"],
	function()
        blindobjs = {}
		local blind = getunitswitheffect("blind",false)

		local blinds = {}
			
		-- add initial blindobjs
		for id,unit in ipairs(blind) do
			if (blinds[unit.fixed] == nil) then
				-- change sprite
				local name = getname(unit)
				MF_changesprite(unit.fixed, name .."_blind", false)
				blinds[unit.fixed] = true
			end
		end
        table.insert(blindobjs, blinds)
	end
)

table.insert(mod_hook_functions["effect_once"],
    function()
 		-- Copy the last entry in blindobjs
        local last = blindobjs[#blindobjs]
        local copy = {}
        if last then
            for k, v in pairs(last) do
                copy[k] = v
            end
        end
        table.insert(blindobjs, copy)

		local blinds = blindobjs[#blindobjs]

		local removeblind = {}
		for unitid, real in pairs(blinds) do
			print("blind obj")
			removeblind[unitid] = true
		end
		
		local blind = getunitswitheffect("blind",false)
			
		for id,unit in ipairs(blind) do
			removeblind[unit.fixed] = nil
			if (blinds[unit.fixed] == nil) then
				-- change sprite
				local name = getname(unit)
				MF_changesprite(unit.fixed, name .."_blind", false)
				blinds[unit.fixed] = true
			end
		end

		for unitid, real in pairs(removeblind) do
			if (real == true) then
				local unit = mmf.newObject(unitid)
				local name = getname(unit)
				MF_changesprite(unitid, name, true)
				blinds[unitid] = nil
			end
		end
    end
)

table.insert(mod_hook_functions["undoed_after"],
    function ()
		if (#blindobjs <= 1) then
			return
		end

		local blinds = blindobjs[#blindobjs]
		local prevblinds = blindobjs[#blindobjs - 1]


		for unitid, real in pairs(prevblinds) do
			-- if not in blinds, add blind sprites back
			if (blinds[unitid] == nil) then
				local unit = mmf.newObject(unitid)
				local name = getname(unit)
				MF_changesprite(unit.fixed, name .."_blind", false)
			end
		end

		for unitid, real in pairs(blinds) do
			-- if not in prevblinds, remove blind sprites
			if (prevblinds[unitid] == nil) then
				local unit = mmf.newObject(unitid)
				local name = getname(unit)
				MF_changesprite(unitid, name, true)
			end
		end

		-- remove last entry
		table.remove(blindobjs)
    end
)