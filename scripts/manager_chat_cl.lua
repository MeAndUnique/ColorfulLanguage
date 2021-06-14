-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local addChatMessageOriginal;
local deliverChatMessageOriginal;

generalFonts =
{
	"emotefont",
	"chatgmfont",
	"msgfont",
	"narratorfont",
	"chatnpcfont",
	"oocfont",
	"chatfont",
	"systemfont",
	"whisperfont",
};
characterFonts =
{
	{ font = "chatfont", actorType = "charsheet" },
	{ font = "chatnpcfont", actorType = "npc" },
	{ font = "emotefont" },
	{ font = "whisperfont" },
};

fontDisplayNames = {};
availableFontNames = {};

function onInit()
	if Session.IsHost and not DB.findNode("chat.fonts") then
		initializeGeneralFontNodes();
	end

	fontDisplayNames =
	{
		["chat"] = Interface.getString("chatname"),
		["emotefont"] = Interface.getString("emotename"),
		["chatgmfont"] = Interface.getString("chatgmname"),
		["msgfont"] = Interface.getString("msgname"),
		["narratorfont"] = Interface.getString("narratorname"),
		["chatnpcfont"] = Interface.getString("chatnpcname"),
		["oocfont"] = Interface.getString("oocname"),
		["chatfont"] = Interface.getString("playerchatname"),
		["systemfont"] = Interface.getString("systemname"),
		["whisperfont"] = Interface.getString("whispername"),
	};
	availableFontNames =
	{
		[Interface.getString("chatfontname")] = "chatfont",
		[Interface.getString("chatgmfontname")] = "chatgmfont",
		[Interface.getString("chatnpcfontname")] = "chatnpcfont",
		[Interface.getString("emotefontname")] = "emotefont",
		[Interface.getString("msgfontname")] = "msgfont",
		[Interface.getString("narratorfontname")] = "narratorfont",
		[Interface.getString("oocfontname")] = "oocfont",
		[Interface.getString("systemfontname")] = "systemfont",
		[Interface.getString("whisperfontname")] = "whisperfont",
	};

	addChatMessageOriginal = Comm.addChatMessage;
	Comm.addChatMessage = addChatMessage;
	deliverChatMessageOriginal = Comm.deliverChatMessage;
	Comm.deliverChatMessage = deliverChatMessage;
end

function initializeGeneralFontNodes()
	local nCount = DB.getChildCount("chat.fonts");
	if nCount >= #generalFonts then
		return;
	end

	local nodeChat = DB.createNode("chat");
	nodeChat.setPublic(true);
	local nodeFonts = nodeChat.createChild("fonts");
	nodeFonts.setPublic(true);
	for _,sFont in ipairs(generalFonts) do
		DB.setValue(nodeFonts, sFont, "string", sFont);
	end
end

function initializeCharacterFonts(nodeActor)
	local nodeChat = nodeActor.createChild("chat");
	local nodeFonts = nodeChat.createChild("fonts");
	local sActorType = ActorManager.getRecordType(nodeActor);
	for _,rFontInfo in ipairs(characterFonts) do
		if ((not rFontInfo.actorType) or (rFontInfo.actorType == sActorType)) and
			(DB.getChild(nodeFonts, rFontInfo.font) == nil) then
			DB.setValue(nodeFonts, rFontInfo.font, "string", rFontInfo.font);
		end
	end
end

function addChatMessage(messagedata)
	resolveFont(messagedata);
	addChatMessageOriginal(messagedata);
end

function deliverChatMessage(messagedata, recipients)
	resolveFont(messagedata);
	deliverChatMessageOriginal(messagedata, recipients);
end

function resolveFont(messagedata)
	local bResolved;
	if isCharacterFont(messagedata) then
		 bResolved = resolveCharacterFont(messagedata);
	end

	if not bResolved then
		resolveGeneralFont(messagedata);
	end
end

function isCharacterFont(messagedata)
	return messagedata.font == "chatfont" or
	messagedata.font == "chatnpcfont" or
	messagedata.font == "emotefont" or
	messagedata.font == "whisperfont";
end

function resolveCharacterFont(messagedata)
	local _,_,sActor = GmIdentityManager.getCurrent();
	if not sActor then
		return false;
	end

	local sMessageFont = messagedata.font;
	if Session.IsHost and sMessageFont == "chatnpcfont" and ActorManager.getRecordType(sActor) == "charsheet" then
		-- Normally when the GM speaks as a player character the npc font is used instead of the character font.
		sMessageFont = "chatfont";
	end

	local sChatFont = DB.getValue(sActor .. ".chat.fonts." .. sMessageFont, "");
	if sChatFont ~= "" then
		messagedata.font = sChatFont;
		return true;
	end
	return false;
end

function resolveGeneralFont(messagedata)
	if not messagedata.font then
		messagedata.font = "msgfont";
	end
	messagedata.font = DB.getValue("chat.fonts." .. messagedata.font, messagedata.font);
end