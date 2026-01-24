-- my own documentation:
-- hmlist and hms are lists of integers
-- 
-- specials is a list of objects, that define special attributes that it has like weak, eat, etc

-- reason for overriding: ALONE movement check
function check(unitid,x,y,dir,pulling_,reason)
	local pulling = false
	if (pulling_ ~= nil) then
		pulling = pulling_
	end
	
	local dir_ = dir
	if pulling then
		dir_ = rotate(dir)
	end
	
	local ndrs = ndirs[dir_ + 1]
	local ox,oy = ndrs[1],ndrs[2]
	
	local result = {}
	local results = {}
	local specials = {}
	local unit = {}
	local name = ""
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		name = getname(unit)
	else
		name = "empty"
	end
	
	local lockpartner = ""
	local open = hasfeature(name,"is","open",unitid,x,y)
	local shut = hasfeature(name,"is","shut",unitid,x,y)
	local eat = hasfeature(name,"eat",nil,unitid,x,y)
	local phantom = hasfeature(name,"is","phantom",unitid,x,y)
	
	if pulling then
		phantom = nil
	end
	
	if (open ~= nil) then
		lockpartner = "shut"
	elseif (shut ~= nil) then
		lockpartner = "open"
	end
	
	local obs = findobstacle(x+ox,y+oy)
	
	if (#obs > 0) and (phantom == nil) then
		for i,id in ipairs(obs) do
			if (id == -1) then
				table.insert(result, -1)
				table.insert(results, -1)
			else
				local obsunit = mmf.newObject(id)
				local obsname = getname(obsunit)
				
				local alreadymoving = findupdate(id,"update")
				local valid = true
				
				local localresult = 0
				
				if (#alreadymoving > 0) then
					for a,b in ipairs(alreadymoving) do
						local nx,ny = b[3],b[4]
						
						if ((nx ~= x) and (ny ~= y)) and ((reason == "shift") and (pulling == false)) then
							valid = false
						end
						
						if ((nx == x) and (ny == y + oy * 2)) or ((ny == y) and (nx == x + ox * 2)) then
							valid = false
						end
					end
				end
				
				if (lockpartner ~= "") and (pulling == false) then
					local partner = hasfeature(obsname,"is",lockpartner,id,x+ox,y+oy)
					
					if (partner ~= nil) and ((issafe(id,x+ox,y+oy) == false) or (issafe(unitid,x,y) == false)) and floating(id,unitid,x+ox,y+oy) then
						valid = false
						table.insert(specials, {id, "lock"})
					end
				end
				
				if (eat ~= nil) and (pulling == false) then
					local eats = hasfeature(name,"eat",obsname,unitid,x+ox,y+oy)
					
					if (eats ~= nil) and (issafe(id,x+ox,y+oy) == false) and floating(id,unitid,x+ox,y+oy) then
						valid = false
						table.insert(specials, {id, "eat"})
					end
				end
				
				local weak = hasfeature(obsname,"is","weak",id,x+ox,y+oy)
				if (weak ~= nil) and (pulling == false) then
					if (issafe(id,x+ox,y+oy) == false) and floating(id,unitid,x+ox,y+oy) then
						--valid = false
						table.insert(specials, {id, "weak"})
					end
				end
				
				local added = false
				
				if valid then
					--MF_alert("checking for solidity for " .. obsname .. " by " .. name .. " at " .. tostring(x) .. ", " .. tostring(y))
					
					local isstop = hasfeature(obsname,"is","stop",id,x+ox,y+oy)
					local ispush = hasfeature(obsname,"is","push",id,x+ox,y+oy)
					local ispull = hasfeature(obsname,"is","pull",id,x+ox,y+oy)
					local isswap = hasfeature(obsname,"is","swap",id,x+ox,y+oy)
					local isstill = cantmove(obsname,id,dir,x+ox,y+oy)
					
					--MF_alert(obsname .. " -- stop: " .. tostring(isstop) .. ", push: " .. tostring(ispush))
					
					if (ispush ~= nil) and isstill then
						ispush = nil
						isstop = true
					end
					
					if (ispull ~= nil) and isstill then
						ispull = nil
						isstop = true
					end

					-- NEW PART, act like the obstacle is STOP if we are ALONE
					local wearealone = hasfeature(name,"is","alone",unitid,x,y)
					if (wearealone ~= nil) then
						isstop = true
					end
					-- END OF NEW PART
					
					if (isswap ~= nil) and isstill then
						isswap = nil
					end
					
					if (isstop ~= nil) and (obsname == "level") and (obsunit.visible == false) then
						isstop = nil
					end
					
					if (((isstop ~= nil) and (ispush == nil) and ((ispull == nil) or ((ispull ~= nil) and (pulling == false)))) or ((ispull ~= nil) and (pulling == false) and (ispush == nil))) and (isswap == nil) then
						if (weak == nil) or ((weak ~= nil) and (floating(id,unitid,x+ox,y+oy) == false)) then
							table.insert(result, 1)
							table.insert(results, id)
							localresult = 1
							added = true
						end
					end
					
					if (localresult ~= 1) and (localresult ~= -1) then
						if (ispush ~= nil) and (pulling == false) and (isswap == nil) then
							--MF_alert(obsname .. " added to push list")
							table.insert(result, id)
							table.insert(results, id)
							added = true
						end
						
						if (ispull ~= nil) and pulling then
							table.insert(result, id)
							table.insert(results, id)
							added = true
						end
					end
				end
				
				if (added == false) then
					table.insert(result, 0)
					table.insert(results, id)
				end
			end
		end
	elseif (phantom == nil) then
		local emptystop = hasfeature("empty","is","stop",2,x+ox,y+oy)
		local emptypush = hasfeature("empty","is","push",2,x+ox,y+oy)
		local emptypull = hasfeature("empty","is","pull",2,x+ox,y+oy)
		local emptyswap = hasfeature("empty","is","swap",2,x+ox,y+oy)
		local emptystill = cantmove("empty",2,dir_,x+ox,y+oy)
		
		local localresult = 0
		local valid = true
		local bname = "empty"
		
		if (eat ~= nil) and (pulling == false) then
			local eats = hasfeature(name,"eat","empty",unitid,x+ox,y+oy)
			
			if (eats ~= nil) and (issafe(2,x+ox,y+oy) == false) and floating(unitid,2,x+ox,y+oy) then
				valid = false
				table.insert(specials, {2, "eat"})
			end
		end
		
		if (lockpartner ~= "") and (pulling == false) then
			local partner = hasfeature("empty","is",lockpartner,2,x+ox,y+oy)
			
			if (partner ~= nil) and ((issafe(2,x+ox,y+oy) == false) or (issafe(unitid,x,y) == false)) and floating(unitid,2,x+ox,y+oy) then
				valid = false
				table.insert(specials, {2, "lock"})
			end
		end
		
		local weak = hasfeature("empty","is","weak",2,x+ox,y+oy)
		if (weak ~= nil) and (pulling == false) then
			if (issafe(2,x+ox,y+oy) == false) and floating(unitid,2,x+ox,y+oy) then
				valid = false
				table.insert(specials, {2, "weak"})
			end
		end
		
		local added = false
		
		if valid then
			local estop = 0
			
			if (emptyswap ~= nil) and emptystill then
				emptyswap = nil
			end
			
			if (emptypush == nil) and (emptyswap == nil) then
				if (emptypull ~= nil) and (pulling == false) then
					estop = 1
				elseif (emptypull ~= nil) and pulling and emptystill then
					estop = 1
				elseif (emptypull == nil) and (emptystop ~= nil) then
					estop = 1
				end
			elseif emptystill then
				estop = 1
			end
			
			if (estop == 1) then
				localresult = 1
				table.insert(result, 1)
				table.insert(results, 2)
				added = true
			end
			
			if (localresult ~= 1) then
				if (emptypush ~= nil) and (pulling == false) and (emptyswap == nil) then
					table.insert(result, 2)
					table.insert(results, 2)
					added = true
				end
				
				if (emptypull ~= nil) and pulling then
					table.insert(result, 2)
					table.insert(results, 2)
					added = true
				end
			end
		end
		
		if (added == false) then
			table.insert(result, 0)
			table.insert(results, 2)
		end
	end
	
	if (#results == 0) then
		result = {0}
		results = {0}
	end
	
	return result,results,specials
end

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