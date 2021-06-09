-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local addIdentityOriginal;
local removeIdentityOriginal;
local getCurrentOriginal;

local tIdentityActors = {};

function onInit()
	addIdentityOriginal = GmIdentityManager.addIdentity;
	GmIdentityManager.addIdentity = addIdentity;
	removeIdentityOriginal = GmIdentityManager.removeIdentity;
	GmIdentityManager.removeIdentity = removeIdentity;
	getCurrentOriginal = GmIdentityManager.getCurrent;
	GmIdentityManager.getCurrent = getCurrent;
end

function addIdentity(sName, bIsGM, nodeActor)
	addIdentityOriginal(sName, bIsGM);
	if nodeActor then
		tIdentityActors[sName] = nodeActor.getPath();
	end
end

function removeIdentity(sName)
	tIdentityActors[sName] = nil;
	removeIdentityOriginal(sName);
end

function getCurrent()
	local sName, bIsGM = getCurrentOriginal();
	local sActor = nil;
	if sName then
		sActor = tIdentityActors[sName];
	end
	return sName, bIsGM, sActor;
end