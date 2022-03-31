dropobar = {}
dropobar["Name"] = "Dropobar"
dropobar["Version"] = 1
dropobar["Color"]="AA60FF"
dropobar["Maxlevel"]=60

dropobar["init"] = nil
dropobar["Bubble_Number"] = 20

dropobar["enabled"] = 1

dropobar["xp_gain"] = 0
dropobar["xp_gain_max"] = 800
dropobar["xp_gain_burst"] = 0

dropobar["xp_color_r"] = nil
dropobar["xp_color_g"] = nil
dropobar["xp_color_b"] = nil

function Dropobar_OnLoad()
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	DEFAULT_CHAT_FRAME:AddMessage("|cFF"..dropobar["Color"]..dropobar["Name"].." loaded. Version "..dropobar["Version"]..". Type \"/dropohelp\" for help.|r");
	if UnitLevel("player")==dropobar["Maxlevel"] then
		DEFAULT_CHAT_FRAME:AddMessage("|cFF"..dropobar["Color"]..dropobar["Name"]..": character is max level, addon disabled.|r");
		dropobar["enabled"] = 0
		DropobarFrame:Hide()
	end
end

function Dropobar_OnEvent(event,arg1)
	if dropobar["enabled"] > 0 then
		if event == "ADDON_LOADED" and arg1==dropobar["Name"] then
	        MainMenuExpBar:SetAlpha(0)
	        dropobar["xp_color_r"],dropobar["xp_color_g"],dropobar["xp_color_b"] = XP_Foreground:GetBackdropColor()
	        XP_Midground:SetBackdropColor(dropobar["xp_color_r"],dropobar["xp_color_g"],dropobar["xp_color_b"])
		elseif event == "PLAYER_XP_UPDATE" then
			dropobar["xp_gain"]=dropobar["xp_gain_max"]
			local bubble_cur_new = math.floor(dropobar["Bubble_Number"]*UnitXP("player")/UnitXPMax("player"))
			if bubble_cur_new~=dropobar["bubble_cur"] then
				XP_Foreground:SetWidth(XP_Background:GetWidth())
				dropobar["xp_gain_burst"]=1
				if bubble_cur_new>dropobar["bubble_cur"] then
					if bubble_cur_new-dropobar["bubble_cur"]==1 then
						DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00Congratulations, you have reached sublevel "..(bubble_cur_new+1).." out of "..dropobar["Bubble_Number"].."!|r")
					else
						DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00Congratulations, you have reached sublevel "..(bubble_cur_new+1).." out of "..dropobar["Bubble_Number"].." (jumped from sublevel "..(dropobar["bubble_cur"]+1)..")!|r")
					end
				end
			end
	    	dropobar["bubble_cur"] = math.floor(dropobar["Bubble_Number"]*UnitXP("player")/UnitXPMax("player"))
	    	dropobar["bubble_progress"] = dropobar["Bubble_Number"]*UnitXP("player")/UnitXPMax("player")-dropobar["bubble_cur"]
	    	if dropobar["bubble_progress"]==0 then
	    		XP_Midground:SetWidth(XP_Background:GetWidth()*(dropobar["bubble_progress"]+0.001))
	    	else
	    		XP_Midground:SetWidth(XP_Background:GetWidth()*dropobar["bubble_progress"])
	    	end
	    	local xp_rested = GetXPExhaustion()
	    	if xp_rested==nil then
	    		XP_Text:SetText(math.floor(100*dropobar["bubble_progress"]).."% ("..dropobar["bubble_cur"].."/"..dropobar["Bubble_Number"]..")")
	    	else
	    		xp_rested = dropobar["Bubble_Number"]*xp_rested/UnitXPMax("player")
		    	XP_Text:SetText(math.floor(100*dropobar["bubble_progress"]).."% ("..dropobar["bubble_cur"].."/"..dropobar["Bubble_Number"]..") |cFF80C0FF[Rested: "..math.floor(100*xp_rested).."%]|r")
	    	end
		elseif ( event == "PLAYER_LEVEL_UP" ) then
			Screenshot()
		end
	end
end

function Dropobar_Update()
	if dropobar["enabled"] > 0 then
	    MainMenuExpBar:SetAlpha(0)
	    if dropobar["init"] == nil then
	    	dropobar["init"] = 1
	    	dropobar["bubble_cur"] = math.floor(dropobar["Bubble_Number"]*UnitXP("player")/UnitXPMax("player"))
	    	dropobar["bubble_progress"] = dropobar["Bubble_Number"]*UnitXP("player")/UnitXPMax("player")-dropobar["bubble_cur"]
	    	if dropobar["bubble_progress"]>0 then
		    	XP_Foreground:SetWidth(XP_Background:GetWidth()*dropobar["bubble_progress"])
		    	XP_Midground:SetWidth(XP_Background:GetWidth()*dropobar["bubble_progress"])
		    else
		    	XP_Foreground:SetWidth(XP_Background:GetWidth()*(0.001+dropobar["bubble_progress"]))
		    	XP_Midground:SetWidth(XP_Background:GetWidth()*(0.001+dropobar["bubble_progress"]))
		    end
	    	local xp_rested = GetXPExhaustion()
	    	if xp_rested==nil then
	    		XP_Text:SetText(math.floor(100*dropobar["bubble_progress"]).."% ("..dropobar["bubble_cur"].."/"..dropobar["Bubble_Number"]..")")
	    	else
	    		xp_rested = dropobar["Bubble_Number"]*xp_rested/UnitXPMax("player")
		    	XP_Text:SetText(math.floor(100*dropobar["bubble_progress"]).."% ("..dropobar["bubble_cur"].."/"..dropobar["Bubble_Number"]..") |cFF80C0FF[Rested: "..math.floor(100*xp_rested).."%]|r")
	    	end
	    	ExhaustionTick:SetAlpha(0.0)
	    end
	    if IsResting() then
	    	local xp_rested = GetXPExhaustion()
	    	if xp_rested~=nil then
		    	dropobar["bubble_cur"] = math.floor(dropobar["Bubble_Number"]*UnitXP("player")/UnitXPMax("player"))
		    	dropobar["bubble_progress"] = dropobar["Bubble_Number"]*UnitXP("player")/UnitXPMax("player")-dropobar["bubble_cur"]
		    	if dropobar["bubble_progress"]>0 then
			    	XP_Foreground:SetWidth(XP_Background:GetWidth()*dropobar["bubble_progress"])
			    	XP_Midground:SetWidth(XP_Background:GetWidth()*dropobar["bubble_progress"])
			    else
			    	XP_Foreground:SetWidth(XP_Background:GetWidth()*(0.001+dropobar["bubble_progress"]))
			    	XP_Midground:SetWidth(XP_Background:GetWidth()*(0.001+dropobar["bubble_progress"]))
			    end
		    	xp_rested = dropobar["Bubble_Number"]*xp_rested/UnitXPMax("player")
		    	XP_Text:SetText(math.floor(100*dropobar["bubble_progress"]).."% ("..dropobar["bubble_cur"].."/"..dropobar["Bubble_Number"]..") |cFF80C0FF[Rested: "..math.floor(100*xp_rested).."%]|r")
	    	end
	    end
	    if dropobar["xp_gain"]>0 then
	    	local t = dropobar["xp_gain"]/dropobar["xp_gain_max"]
	    	t = t*t
	    	XP_Midground:SetBackdropColor(t+(1-t)*dropobar["xp_color_r"],t+(1-t)*dropobar["xp_color_g"],t+(1-t)*dropobar["xp_color_b"])
	    	if dropobar["xp_gain_burst"]~=0 then
	    		XP_Foreground:SetBackdropColor(t+(1-t)*dropobar["xp_color_r"],t+(1-t)*dropobar["xp_color_g"],t+(1-t)*dropobar["xp_color_b"])
	    		XP_Foreground:SetWidth(t*XP_Background:GetWidth()+(1-t)*XP_Midground:GetWidth())
	    	end
	    	dropobar["xp_gain"] = dropobar["xp_gain"] - 1
	    	if dropobar["xp_gain"] <= 0 then
	    		dropobar["xp_gain"] = 0
	    		dropobar["xp_gain_burst"] = 0
	    		XP_Midground:SetBackdropColor(dropobar["xp_color_r"],dropobar["xp_color_g"],dropobar["xp_color_b"])
	    		XP_Foreground:Show()
	    		XP_Foreground:SetWidth(XP_Midground:GetWidth())
	    	end
	    end
	else
		if UnitLevel("player")==dropobar["Maxlevel"] then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF"..dropobar["Color"]..dropobar["Name"]..": character is max level, addon disabled.|r");
			dropobar["enabled"] = 0
			DropobarFrame:Hide()
		end
	end
end

SLASH_DROPOHELP1 = '/dropohelp'
SlashCmdList['DROPOHELP'] = function(msg)
    DEFAULT_CHAT_FRAME:AddMessage(dropobar["Name"]..' version '..dropobar["Version"]..'.')
    DEFAULT_CHAT_FRAME:AddMessage('List of commands:')
    DEFAULT_CHAT_FRAME:AddMessage('/dropohelp - this help')
    DEFAULT_CHAT_FRAME:AddMessage('/dropotoggle - toggles the addon on and off')
end

SlashCmdList['DROPOTOGGLE'] = function(msg)
    if UnitLevel("player")==dropobar["Maxlevel"] then
    	DEFAULT_CHAT_FRAME:AddMessage("|cFF"..dropobar["Color"]..dropobar["Name"]..": Cannot enable addon: addon is forced disabled for characters who have reached max level ("..dropobar["Maxlevel"]..").|r");
    else
	    dropobar["enabled"] = 1 - dropobar["enabled"]
	    if dropobar["enabled"] == 0 then
	    	DropobarFrame:Hide()
	    	MainMenuExpBar:SetAlpha(1)
	    	ExhaustionTick:SetAlpha(1)
	    	DEFAULT_CHAT_FRAME:AddMessage("|cFF"..dropobar["Color"]..dropobar["Name"]..": addon disabled by the player. Type \"/dropotoggle\" to reenable it.|r");
	    else
	    	DropobarFrame:Show()
	    	MainMenuExpBar:SetAlpha(0)
	    	ExhaustionTick:SetAlpha(0)
	    	DEFAULT_CHAT_FRAME:AddMessage("|cFF"..dropobar["Color"]..dropobar["Name"]..": addon enabled by the player.|r");
	    end
	end
end
SLASH_DROPOTOGGLE1 = '/dropotoggle'