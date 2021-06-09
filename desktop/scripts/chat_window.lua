-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end

	if Session.IsHost then
		registerMenuItem(Interface.getString("chat_menu_set_color"), "radial_font", 5);
	end
end

function onMenuSelection(selection, subselection)
	if super and super.onMenuSelection then
		super.onMenuSelection(selection, subselection);
	end

	if selection == 5 then
		ChatManagerCL.initializeGeneralFontNodes();
		Interface.openWindow("chat_font_selection", "");
	end
end
