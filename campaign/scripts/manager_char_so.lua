-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local addClassRefOriginal;

local bAddingClass;

function onInit()
	addClassRefOriginal = CharManager.addClassRef;
	CharManager.addClassRef = addClassRef;

	DB.addHandler("charsheet.*.classes.*.hddie", "onUpdate", onHitDieUpdated)
end

function onClose()
	DB.removeHandler("charsheet.*.classes.*.hddie", "onUpdate", onHitDieUpdated)
end

function addClassRef(nodeChar, sClass, sRecord)
	bAddingClass = true;
	addClassRefOriginal(nodeChar, sClass, sRecord);
	bAddingClass = false;
end

function onHitDieUpdated(nodeHitDie)
	if not bAddingClass then
		return;
	end

	local aHitDie = nodeHitDie.getValue();
	Debug.chat(#aHitDie, aHitDie);
	if aHitDie and (#aHitDie == 1) then
		Debug.chat("calc");
		local nodeClass = nodeHitDie.getChild("..");
		local sSides = aHitDie[1]:match("d(%d+)");
		local nHDSides = tonumber(sSides);
		local aStressDie = {};
		table.insert(aStressDie, "d" .. 18-nHDSides);
		Debug.chat(aStressDie);
		DB.setValue(nodeClass, "sddie", "dice", aStressDie);
	end
end
