-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onDeliverMessage(messagedata, mode)
	if super and super.onDeliverMessage then
		local messagedata = super.onDeliverMessage(messagedata, mode);
		if messagedata then
			ChatManagerCL.resolveFont(messagedata);
		end
		return messagedata;
	end
end