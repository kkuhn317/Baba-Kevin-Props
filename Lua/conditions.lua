
-- Reason for overriding: blind prop preventing seeing from working
condlist.seeing = function(params,checkedconds,checkedconds_,cdata)
    local allfound = 0
    local alreadyfound = {}
    local targets = {}
    
    local unitid,x,y,dir,conds,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.dir,tostring(cdata.conds),cdata.surrounds
    
    if (unitid == 2) then
        dir = emptydir(x,y)
    end
    
    local ndrs = ndirs[dir+1]
    local ox = ndrs[1]
    local oy = ndrs[2]
    
    local nx,ny = x,y
    local tileid = (x + ox) + (y + oy) * roomsizex
    local solid = 0
    
    if (checkedconds_ ~= nil) and (checkedconds_[tostring(conds) .. "_s_"] ~= nil) then
        return false,checkedconds,true
    end

    -- New: check for blind property
    local name = cdata.name
    if (hasfeature(name, "is", "blind", unitid, x, y, checkedconds) ~= nil) then
        return false,checkedconds,true
    end
    
    if (#params > 0) and (dir ~= 4) then
        while (solid == 0) and inbounds(nx,ny,1) do
            nx = nx + ox
            ny = ny + oy
            
            tileid = nx + ny * roomsizex
            
            if inbounds(nx,ny,1) then
                if (unitmap[tileid] ~= nil) then
                    if (#unitmap[tileid] > 0) then
                        local detected = false
                        
                        for a,b in ipairs(unitmap[tileid]) do
                            local unit = mmf.newObject(b)
                            local name_ = getname(unit)
                            
                            if (hasfeature(name_,"is","hide",b,nx,ny,checkedconds) == nil) then
                                table.insert(targets, {b, name_})
                                detected = true
                            end
                        end
                        
                        if (detected == false) then
                            table.insert(targets, {2, "empty"})
                        end
                    else
                        table.insert(targets, {2, "empty"})
                    end
                else
                    table.insert(targets, {2, "empty"})
                end
                
                solid = simplecheck(nx,ny,true,checkedconds)
            else
                solid = 1
            end
        end
        
        for a,b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end
            
            local bcode = b .. "_" .. tostring(a)
            
            if (string.sub(pname, 1, 5) == "group") then
                return false,checkedconds
            end
            
            if (unitid ~= 1) then
                if ((pname ~= "empty") and (b ~= "level")) or ((b == "level") and (alreadyfound[1] ~= nil)) then
                    for c,d_ in ipairs(targets) do
                        local d = d_[1]
                        
                        if (d ~= unitid) and (alreadyfound[d] == nil) and (d ~= 2) then
                            local name_ = d_[2]
                            
                            if (pnot == false) then
                                if (name_ == pname) and (alreadyfound[bcode] == nil) then
                                    alreadyfound[bcode] = 1
                                    alreadyfound[d] = 1
                                    allfound = allfound + 1
                                end
                            else
                                if (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
                                    alreadyfound[bcode] = 1
                                    alreadyfound[d] = 1
                                    allfound = allfound + 1
                                end
                            end
                        end
                    end
                elseif (pname == "empty") then
                    for c,d_ in ipairs(targets) do
                        local d = d_[1]
                        
                        if (d == 2) then
                            if (pnot == false) then
                                if (alreadyfound[bcode] == nil) then
                                    alreadyfound[bcode] = 1
                                    alreadyfound[d] = 1
                                    allfound = allfound + 1
                                end
                            else
                                if (alreadyfound[bcode] == nil) then
                                    alreadyfound[bcode] = 1
                                    alreadyfound[d] = 1
                                    allfound = allfound + 1
                                end
                            end
                        end
                    end
                elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
                    alreadyfound[bcode] = 1
                    alreadyfound[1] = 1
                    allfound = allfound + 1
                end
            else
                local dirids = {"r","u","l","d"}
                local dirid = dirids[dir + 1]
                
                if (surrounds[dirid] ~= nil) then
                    for c,d in ipairs(surrounds[dirid]) do
                        if (pnot == false) then
                            if (d == pname) and (alreadyfound[bcode] == nil) then
                                alreadyfound[bcode] = 1
                                allfound = allfound + 1
                            end
                        else
                            if (d ~= pname) and (alreadyfound[bcode] == nil) then
                                alreadyfound[bcode] = 1
                                allfound = allfound + 1
                            end
                        end
                    end
                end
            end
        end
    elseif (#params == 0) then
        print("no parameters given!")
        return false,checkedconds,true
    else
        return false,checkedconds,true
    end
    
    return (allfound == #params),checkedconds,true
end