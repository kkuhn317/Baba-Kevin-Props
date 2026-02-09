-- reason for overriding: make 3D view empty if object is blind
function extrarender()
	local cx,cy,cdir = spritedata.values[XCAMERA],spritedata.values[YCAMERA],spritedata.values[CAMDIR]
	local mx,my = screenw * 0.5,screenh * 0.5
	local mtx,mty = roomsizex * 0.5,roomsizey * 0.5
	local maxscale = 13
	
	cx = cx - mtx
	cy = cy - mty
	
	local exists = {}
	local renderthese = {}

    -- New: blind check
    local isblind = false
    local camtarget = spritedata.values[CAMTARGET]
	if (camtarget ~= 0) and (camtarget ~= 0.5) then
		local unitid = MF_getfixed(camtarget)
		if (unitid ~= nil) then
			local unit = mmf.newObject(unitid)
			local name = getname(unit)
			if (hasfeature(name, "is", "blind", unitid, unit.values[XPOS], unit.values[YPOS]) ~= nil) then
				isblind = true
			end
		end
	end
	
	for i,unit in ipairs(units) do
		if (unit.values[ZLAYER] < 21) then
			if unit.visible then
				if (unit.xpos == nil) then
					unit.xpos = unit.values[XPOS]
				end
				
				if (unit.ypos == nil) then
					unit.ypos = unit.values[YPOS]
				end
				
				if (unit.xpos ~= unit.values[XPOS]) then
					if (math.abs(unit.xpos - unit.values[XPOS]) > 2) then
						unit.xpos = unit.values[XPOS]
					else
						unit.xpos = unit.xpos + (unit.values[XPOS] - unit.xpos) * 0.4
					end
				end
				
				if (unit.ypos ~= unit.values[YPOS]) then
					if (math.abs(unit.ypos - unit.values[YPOS]) > 2) then
						unit.ypos = unit.values[YPOS]
					else
						unit.ypos = unit.ypos + (unit.values[YPOS] - unit.ypos) * 0.4
					end
				end
				
				local dothis = cullvision(unit.xpos - spritedata.values[XCAMERA],unit.ypos - spritedata.values[YCAMERA],cdir)

                if isblind then
                    dothis = false
                end
				
				if dothis then
					table.insert(renderthese, unit)
				else
					unit.x = -24
					unit.y = -24
					unit.scaleX = 1
					unit.scaleY = 1
				end
			end
			
			exists[unit.fixed] = 1
		end
	end
	
	for i,unitid in ipairs(edgetiles) do
		local unit = mmf.newObject(unitid)
		
		if (unit ~= nil) then
			if unit.visible then
				if (unit.xpos == nil) then
					unit.xpos = unit.values[XPOS]
				end
				
				if (unit.ypos == nil) then
					unit.ypos = unit.values[YPOS]
				end
				
				if (unit.xpos ~= unit.values[XPOS]) then
					if (math.abs(unit.xpos - unit.values[XPOS]) > 2) then
						unit.xpos = unit.values[XPOS]
					else
						unit.xpos = unit.xpos + (unit.values[XPOS] - unit.xpos) * 0.4
					end
				end
				
				if (unit.ypos ~= unit.values[YPOS]) then
					if (math.abs(unit.ypos - unit.values[YPOS]) > 2) then
						unit.ypos = unit.values[YPOS]
					else
						unit.ypos = unit.ypos + (unit.values[YPOS] - unit.ypos) * 0.4
					end
				end
				
				local dothis = cullvision(unit.xpos - spritedata.values[XCAMERA],unit.ypos - spritedata.values[YCAMERA],cdir)

                if isblind then
                    dothis = false
                end
				
				if dothis then
					table.insert(renderthese, unit)
				else
					unit.x = -24
					unit.y = -24
					unit.scaleX = 1
					unit.scaleY = 1
				end
			end
			
			exists[unit.fixed] = 1
		end
	end
	
	local renders = 0
	
	for i,unit in ipairs(renderthese) do
		local rendered = extrarender_do(unit,true,cx,cy,cdir,mx,my,mtx,mty,{maxscale})
		renders = renders + 1
		
		if rendered then
			exists[unit.fixed] = 2
		end
	end
	
	local removethese = {}
	
	for i,unit in ipairs(funnywalls) do
		local ownerid = unit.values[VISUALSTYLE]
		
		if (exists[ownerid] ~= nil) and (exists[ownerid] == 2) then
			local owner = mmf.newObject(ownerid)
			unit.visible = owner.visible
			
			if owner.visible and (owner.values[ID] ~= spritedata.values[CAMTARGET]) then
				unit.xpos = owner.xpos
				unit.ypos = owner.ypos
				unit.values[XPOS] = owner.values[XPOS]
				unit.values[YPOS] = owner.values[YPOS]
				unit.values[ZPOS] = owner.values[ZPOS]
				unit.values[ZLAYER] = owner.values[ZLAYER] + 0.5
				unit.values[FLOAT] = owner.values[FLOAT]
				
				unit.strings[COLOUR] = owner.strings[COLOUR]
				unit.strings[CLEARCOLOUR] = owner.strings[CLEARCOLOUR]
				
				unit.flags[PHANTOM] = owner.flags[PHANTOM]
				
				extrarender_do(unit,true,cx,cy,cdir,mx,my,mtx,mty,{maxscale})
				renders = renders + 1
			elseif (owner.values[ID] ~= spritedata.values[CAMTARGET]) then
				unit.visible = false
			end
		elseif (exists[ownerid] ~= nil) and (exists[ownerid] == 1) then
			unit.visible = false
		elseif (exists[ownerid] == nil) then
			unit.flags[DEAD] = true
			table.insert(removethese, {i, unit.fixed})
		end
	end
	
	-- MF_alert("Rendered: " .. tostring(renders))
	
	local offset = 0
	
	for i,v in ipairs(removethese) do
		table.remove(funnywalls, v[1] - offset)
		offset = offset + 1
		
		MF_cleanremove(v[2])
	end
end