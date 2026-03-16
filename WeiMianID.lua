-- 不显示位面ID的NPC
local NoID = {
    -- [NPCID] = true,
    [181059] = true, -- 波可波克
    [25146]  = true, -- 佩奇
    [62821]  = true, -- 秘法师鸟羽帽
    [62822]  = true, -- 表弟慢热手
    [142666] = true, -- 收集者温塔
    [142668] = true, -- 商人马库
    [231085] = true, -- 吉利亚
    [231086] = true, -- 梅兰妮·摩尔登
}

-- 位运算兼容
local band = bit and bit.band or (bit32 and bit32.band)
if not band then
    error("WeiMianID: bit.band / bit32.band 不可用")
end

local ADDON_NAME = ...
WeiMianIDDB = WeiMianIDDB or {}

local f = CreateFrame("Frame", nil, UIParent)
f:SetSize(95, 28)
f:SetScale(1.0)
f:SetClampedToScreen(true)
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:Show()

-- 默认位置
local DEFAULT_POINT = {
    point = "CENTER",
    relativePoint = "CENTER",
    x = 0,
    y = 0,
}

local function SaveFramePosition()
    local point, _, relativePoint, x, y = f:GetPoint()
    WeiMianIDDB.position = {
        point = point,
        relativePoint = relativePoint,
        x = x,
        y = y,
    }
end

local function LoadFramePosition()
    f:ClearAllPoints()

    if WeiMianIDDB.position then
        local p = WeiMianIDDB.position
        f:SetPoint(p.point or "CENTER", UIParent, p.relativePoint or "CENTER", p.x or 0, p.y or 0)
    else
        f:SetPoint(DEFAULT_POINT.point, UIParent, DEFAULT_POINT.relativePoint, DEFAULT_POINT.x, DEFAULT_POINT.y)
    end
end

f.Bg = f:CreateTexture(nil, "BACKGROUND")
f.Bg:SetTexture("interface\\framegeneral\\uiframeventhyr.blp")
f.Bg:SetPoint("CENTER")
f.Bg:SetSize(95, 28)
f.Bg:SetTexCoord(212/1024, 409/1024, 243/1024, 344/1024)
f.Bg:SetVertexColor(1, 1, 1, 1)

f.text = f:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
f.text:SetScale(1.2)
f.text:SetPoint("CENTER")

f:SetScript("OnMouseDown", function(self)
    self:StartMoving()
end)

f:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
    SaveFramePosition()
end)

local function IsWarModeActiveSafe()
    return C_PvP and C_PvP.IsWarModeActive and C_PvP.IsWarModeActive()
end

local function SetPhaseText(text)
    if IsWarModeActiveSafe() then
        -- PVP 红色
        f.text:SetText("|cffff4040" .. text .. "|r")
    else
        -- PVE 绿色
        f.text:SetText("|cff40ff40" .. text .. "|r")
    end
end

local function UpdateDisplay()
    if C_PetBattles and C_PetBattles.IsInBattle and C_PetBattles.IsInBattle() then
        f:Hide()
        return
    end

    f:Show()

    local _, unit = GameTooltip:GetUnit()
    local guid = UnitGUID(unit or "none")

    if not guid then
        SetPhaseText("----")
        return
    end

    local types, _, _, _, zoneID, unitID = strsplit("-", guid)
    local ids = tonumber(unitID)
    local id = tonumber(strsub(guid, -6), 16)

    if id then
        local serverTime = GetServerTime()
        local cycle = 2^23
        local spawnTime = (serverTime - (serverTime % cycle)) + band(id, 0x7fffff)

        if spawnTime > serverTime then
            spawnTime = spawnTime - (cycle - 1)
        end

        if types == "Creature" or types == "Vehicle" then
            GameTooltip:AddLine("存活：" .. SecondsToTime(serverTime - spawnTime), 0.6, 1, 0)
            GameTooltip:Show()
        end
    end

    if types == "Pet" then
        SetPhaseText("----")
        return
    end

    if zoneID == nil then
        SetPhaseText("----")
        return
    end

    if ids and NoID[ids] then
        SetPhaseText("----")
        return
    end

    SetPhaseText(zoneID)
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:RegisterEvent("PET_BATTLE_OPENING_START")
f:RegisterEvent("PET_BATTLE_CLOSE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            WeiMianIDDB = WeiMianIDDB or {}
            LoadFramePosition()
        end
        return
    end

    UpdateDisplay()
end)

SLASH_WEIMIANIDRESET1 = "/wmreset"

SlashCmdList["WEIMIANIDRESET"] = function()
    WeiMianIDDB = WeiMianIDDB or {}
    WeiMianIDDB.position = nil
    LoadFramePosition()
    print("|cff00ff00WeiMianID: 位置已重置到默认位置|r")
end