-- new helper function for no u
function findwhodies(victimUID, attackerUID, ignoresafe)
	if (ignoresafe == nil) then
		ignoresafe = false
	end
	local todestroy = nil
	-- CHANGED SECTION: check No U property logic

	local hasnou = false
	-- victim is empty
	if (victimUID == 2) then
		hasnou = hasfeature("empty","is","nou",victimUID)
	else 
		local vUnit = mmf.newObject(victimUID)
		local vName = vUnit.strings[UNITNAME]
		hasnou = hasfeature(vName,"is","nou",victimUID)
	end

	if (hasnou ~= nil) then
		-- check for safe on attacker
		if (issafe(attackerUID) == false or ignoresafe == true) then
			todestroy = attackerUID
		else
			todestroy = nil
		end
	else
		todestroy = victimUID
	end

	return todestroy
end

-- Reason for overriding: blind stopping fear from working
function findfears(unitid,feartargets,x_,y_)
	local result,resultdir = false,4
	local amount = 0
	
	local ox,oy = 0,0
	local x,y = 0,0
	local name = ""
	local dir = 4
	
	if (unitid ~= 2) then
		local unit = mmf.newObject(unitid)
		x,y = unit.values[XPOS],unit.values[YPOS]
		name = getname(unit)
		dir = unit.values[DIR]
	else
		x,y = x_,y_
		name = "empty"
		dir = emptydir(x,y)
	end

	-- New: blind stops fear
	local blind = hasfeature(name,"is","blind",unitid)
	if (blind ~= nil) then
		return false, 4, 0
	end

	
	local feardirs = {}
	local maxfear = 0
	
	for j=0,3 do
		local i = (((dir + 2) + j) % 4) + 1
		local ndrs = ndirs[i]
		ox = ndrs[1]
		oy = ndrs[2]
		
		local dirfound = false
		local diramount = 0
		
		if (#feartargets > 0) then
			for a,v in ipairs(feartargets) do
				local foundfears = {}
				
				if (v ~= "empty") then
					foundfears = findtype({v, nil},x+ox,y+oy,unitid)
				else
					local tileid = (x + ox) + (y + oy) * roomsizex
					if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then
						foundfears = {"a","b"}
					end
				end
				
				if (#foundfears > 0) then
					dirfound = true
					result = true
					resultdir = rotate(i-1)
					diramount = diramount + 1
				end
			end
		end
		
		if dirfound then
			feardirs[i] = diramount
			maxfear = math.max(maxfear, diramount)
		else
			feardirs[i] = 0
		end
	end
	
	local totalfeardirs = 0
	
	for i,v in ipairs(feardirs) do
		if (v >= maxfear) then
			totalfeardirs = totalfeardirs + 1
		else
			feardirs[i] = 0
		end
	end
	
	if (totalfeardirs > 0) then
		amount = maxfear
	end
	
	if (totalfeardirs > 1) then
		resultdir = dir
		local searching = true
		local tests = 0
		
		while searching do
			local problems = false
			
			if (feardirs[resultdir+1] == 1) then
				problems = true
			else
				local ndrs = ndirs[resultdir+1]
				local ox,oy = ndrs[1],ndrs[2]
				
				local obs = check(unitid,x,y,resultdir)
				
				local obsresult = 0
				for i,v in ipairs(obs) do
					if (v == 1) or (v == -1) then
						obsresult = 1
						break
					elseif (v ~= 0) and (obsresult == 0) then
						obsresult = v
					end
				end
				
				if (obsresult == 1) then
					problems = true
				elseif (obsresult ~= 0) then
					local ndrs = ndirs[resultdir+1]
					local ox,oy = ndrs[1],ndrs[2]
					
					local obsresult_ = trypush(obsresult,ox,oy,resultdir,false,x,y,"fear",unitid)
					
					if (obsresult_ ~= 0) then
						problems = true
					end
				end
			end
			
			if (problems == false) then
				searching = false
			else
				if (tests == 0) then
					resultdir = (resultdir - 1 + 4) % 4
				elseif (tests == 1) then
					resultdir = (resultdir + 2 + 4) % 4
				elseif (tests == 2) then
					resultdir = (resultdir + 1 + 4) % 4
				elseif (tests == 3) then
					resultdir = (resultdir - 2 + 4) % 4
				end
				
				tests = tests + 1
			end
			
			if (tests >= 4) then
				searching = false
				result = false
				resultdir = 4
			end
		end
	end
	
	return result,resultdir,amount
end