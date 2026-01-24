-- my own documentation:
-- hmlist and hms are lists of integers
-- 
-- specials is a list of objects, that define special attributes that it has like weak, eat, etc


-- reason for overriding: heavy property
function trypush(unitid,ox,oy,dir,pulling_,x_,y_,reason,pusherid)
	local x,y = 0,0
	local unit = {}
	local name = ""
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		x,y = unit.values[XPOS],unit.values[YPOS]
		name = getname(unit)
	else
		x = x_
		y = y_
		name = "empty"
	end
	
	local tileid = x + y * roomsizex
	local moveid = tostring(tileid) .. name .. tostring(dir)
	
	if (movemap[moveid] == nil) then
		movemap[moveid] = {}
	end
	
	if (movemap[moveid]["tryresult"] == nil) then
		movemap[moveid]["tryresult"] = 0
	end
	
	local movedata = movemap[moveid]
	
	local pulling = pulling_ or false
	
	local weak = hasfeature(name,"is","weak",unitid,x_,y_)

	if (weak == nil) or pulling or ((weak ~= nil) and issafe(unitid,x_,y_)) then
		local result = 0
		
		if (movedata.tryresult == 0) then

            -- NEW PART: CHECK FOR HEAVY OBJECTS
            local heavinesses = findallfeature(name, "is", "heavy", true)
            local heavystack = 0
				
            for i,v in ipairs(heavinesses) do
                -- print("heavinesses[" .. i .. "]: " .. tostring(v))
                if (v == unitid) then
                    heavystack = heavystack + 1
                end
            end

            --print("heaviness: " .. heavystack)

            if (heavystack > 0) ~= nil then
                local pushes = heavy_objects[#heavy_objects][unitid] or 0

                -- Increment the pushes for the heavy object
                pushes = pushes + 1

                --print("pushes: " .. pushes)
                --print("unitid: " .. unitid)

                -- if it has been pushed, check if it meets the heavy requirement
                -- for now its just 1 push
                if (pushes > heavystack) then
                    --print("heavy object can move")
                    -- if it meets the requirement, set pushes to 0
                    heavy_objects[#heavy_objects][unitid] = 0
                    -- can move
                else
                    --print("heavy object can't move")
                    heavy_objects[#heavy_objects][unitid] = pushes
                    -- if it has not met the requirement, can't move
                    return 2 -- can't move
                end
            end
            -- END OF NEW PART

			local hmlist,hms,specials = check(unitid,x,y,dir,false,reason)
			
			for i,hm in pairs(hmlist) do
				local done = false
				
				while (done == false) do
					if (hm == 0) then
						result = math.max(0, result)
						done = true
					elseif (hm == 1) or (hm == -1) then
						if (pulling == false) or (pulling and (hms[i] ~= pusherid)) then
							result = math.max(1, result)
							done = true
						else
							result = math.max(0, result)
							done = true
						end
					else
						if (pulling == false) then
							hm = trypush(hm,ox,oy,dir,pulling,x+ox,y+oy,reason,unitid)
						else
							result = math.max(0, result)
							done = true
						end
					end
				end
			end
			
			movedata.tryresult = result + 1
		else
			result = movedata.tryresult - 1
		end
		
		return result
	else
		return 0
	end
end