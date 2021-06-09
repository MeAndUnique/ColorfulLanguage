-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local node = getDatabaseNode();
	local sName = ChatManagerCL.fontDisplayNames[node.getName()];
	name.setValue(sName);

	options.onSelect = onFontChanged;
	local sCurrent = node.getValue();
	for sDisplay,sFont in pairs(ChatManagerCL.availableFontNames) do
		options.add(sDisplay);
		if sFont == sCurrent then
			options.setListValue(sDisplay);
			onFontChanged(sDisplay);
		end
	end
end

function onFontChanged(sValue)
	local sFont = ChatManagerCL.availableFontNames[sValue];
	example.setFont(sFont);
	DB.setValue(getDatabaseNode().getPath(), "string", sFont);
end