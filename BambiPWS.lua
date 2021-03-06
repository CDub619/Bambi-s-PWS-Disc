--added to github

local target
local player
local targetAnchor = ActionButton4
local playerAnchor = MultiBarBottomLeftButton4

local hieght = 40
local width = 40

local spellIds = {
		[6788] = "True", -- Weakened Soul
	}


local PWS = CreateFrame('Frame')
PWS:SetScript("OnEvent", function(frame, event, unit, arg1)
	local x, y
	local currentSpec = GetSpecialization()
		if currentSpec == 1 then x =2 y=1 end
		if currentSpec == 2 then x =2 y=2 end
		if currentSpec == 3 then x =2 y=1 end
	local talentID, name, texture, selected, available, spellID, unknown, row, column, known, grantedByAura = GetTalentInfoBySpecialization(currentSpec, x, y)
			if event == "PLAYER_TARGET_CHANGED" then
				PWS:UpdateShield("target")
				if known then
				PWS:BodyAndSoulUpdateShield("player")
				end
      elseif event == "PLAYER_ENTERING_WORLD" then
        PWS:UpdateShield("target")
				if known then
				PWS:BodyAndSoulUpdateShield("player")
				end
      elseif event == "PLAYER_LOGIN" then
        PWS:UpdateShield("target")
				if known then
				PWS:BodyAndSoulUpdateShield("player")
				end
      elseif event == "UNIT_AURA" and unit == "target" or unit =="player" then
				PWS:UpdateShield("target")
				if known then
				PWS:BodyAndSoulUpdateShield("player")
				end
      end
    end)
  PWS:RegisterUnitEvent('UNIT_AURA', "target", "player")
  PWS:RegisterEvent("PLAYER_ENTERING_WORLD")
  PWS:RegisterEvent("PLAYER_LOGIN")
  PWS:RegisterEvent("PLAYER_TARGET_CHANGED")

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Power Word: Shield Target
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function PWS:UpdateShield(unit)
	local Shield, ExpirationTime, Duration
	for i = 1, 40 do
		local name, icon, count, _, duration, expirationTime, source, _, _, spellId = UnitAura("player", i,  "HELPFUL")
		if spellId == 47536 then
			if target then
				target:ClearAllPoints()
				target:Hide()
				target.cooldown:Hide()
				target = nil
			end
			return
		end
	end
	for i = 1, 40 do
		local name, icon, count, _, duration, expirationTime, source, _, _, spellId = UnitAura(unit, i,  "HARMFUL")
		if not spellId then break end -- no more debuffs, terminate the loop
		if spellIds[spellId] and source == "player" then
			Shield = true
			ExpirationTime = expirationTime
			Duration = duration
		end
	end
	if Shield then
		PWS:ShowShield(ExpirationTime, Duration)
	else
		if target then
			target:ClearAllPoints()
			target:Hide()
			target.cooldown:Hide()
			target = nil
		end
	end
end


function PWS:ShowShield(expirationTime, duration)
	if target then
		target:ClearAllPoints()
		target:Hide()
		target.cooldown:Hide()
		target = nil
	end
	target = CreateFrame("Frame", "PWStarget")
	target:SetHeight(hieght)
	target:SetWidth(width)
	target.texture = target:CreateTexture(target, 'BACKGROUND')
	target.cooldown = CreateFrame("Cooldown", nil, target, 'CooldownFrameTemplate')
	target.cooldown:SetCooldown( expirationTime - duration, duration)
	target.cooldown:SetAllPoints(target)
	target.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")    --("Interface\\Cooldown\\edge-LoC") Blizz LC CD
	target.cooldown:SetDrawSwipe(true)
	target.cooldown:SetDrawEdge(false)
	target.cooldown:SetSwipeColor(0, 0, 0, .75)
	target.cooldown:SetReverse(false) --will reverse the swipe if actionbars or debuff, by default bliz sets the swipe to actionbars if this = true it will be set to debuffs
	target.cooldown:SetDrawBling(false)
	target:ClearAllPoints()
	target:SetParent(targetAnchor)
	target:SetPoint("CENTER", targetAnchor, "CENTER", 0, 0)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Body & Soul
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function PWS:BodyAndSoulUpdateShield(unit)
	local Shield, ExpirationTime, Duration
	for i = 1, 40 do
		local name, icon, count, _, duration, expirationTime, source, _, _, spellId = UnitAura("player", i,  "HELPFUL")
		if spellId == 47536 then
			if player then
				player:ClearAllPoints()
				player:Hide()
				player.cooldown:Hide()
				player = nil
			end
			return
		end
	end
	for i = 1, 40 do
		local name, icon, count, _, duration, expirationTime, source, _, _, spellId = UnitAura(unit, i,  "HARMFUL")
		if not spellId then break end -- no more debuffs, terminate the loop
		if spellIds[spellId] and source == "player" then
			Shield = true
			ExpirationTime = expirationTime
			Duration = duration
		end
	end
	if Shield then
		PWS:BodyAndSoulShowShield(ExpirationTime, Duration)
	else
		if player then
			player:ClearAllPoints()
			player:Hide()
			player.cooldown:Hide()
			player = nil
		end
	end
end

function PWS:BodyAndSoulShowShield(expirationTime, duration)
	if player then
		player:ClearAllPoints()
		player:Hide()
		player.cooldown:Hide()
		player = nil
	end
	player = CreateFrame("Frame", "PWSplayer")
	player:SetHeight(hieght)
	player:SetWidth(width)
	player.texture = player:CreateTexture(player, 'BACKGROUND')
	player.cooldown = CreateFrame("Cooldown", nil, player, 'CooldownFrameTemplate')
	player.cooldown:SetCooldown( expirationTime - duration, duration)
	player.cooldown:SetAllPoints(player)
	player.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")    --("Interface\\Cooldown\\edge-LoC") Blizz LC CD
	player.cooldown:SetDrawSwipe(true)
	player.cooldown:SetDrawEdge(false)
	player.cooldown:SetSwipeColor(0, 0, 0, .75)
	player.cooldown:SetReverse(false) --will reverse the swipe if actionbars or debuff, by default bliz sets the swipe to actionbars if this = true it will be set to debuffs
	player.cooldown:SetDrawBling(false)
	player:ClearAllPoints()
	player:SetParent(playerAnchor)
	player:SetPoint("CENTER", playerAnchor, "CENTER", 0, 0)
end
