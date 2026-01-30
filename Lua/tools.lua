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