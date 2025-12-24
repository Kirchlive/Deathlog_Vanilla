-- Deathlog.lua
-- Deathlog for Vanilla WoW
-- Death heatmap overlay for the world map with danger indicator
-- Based on aaronma37/Deathlog (WoW Classic) and DaniilSokolyuk/RipMap

-- Main addon initialization
local indicatorFrame = nil
local indicatorTexture = nil
local updateTimer = 0
local UPDATE_INTERVAL = 1.0  -- Update every second

-- Function to create or update the danger indicator
function CreateDangerIndicator()
    if not indicatorFrame then
        -- Create the indicator frame (50x20 pixels, 30px from top)
        indicatorFrame = CreateFrame("Frame", "DeathlogIndicator", UIParent)
        indicatorFrame:SetWidth(50)
        indicatorFrame:SetHeight(20)
        indicatorFrame:SetFrameStrata("HIGH")
        indicatorFrame:SetFrameLevel(100)

        -- Position at top center (30px from top)
        indicatorFrame:SetPoint("TOP", UIParent, "TOP", 0, -30)

        -- Use backdrop for solid color (works better in 1.12)
        indicatorFrame:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        -- Set initial color to bright green
        indicatorFrame:SetBackdropColor(0, 1, 0, 1)
        indicatorFrame:SetBackdropBorderColor(0, 0, 0, 1)

        -- Make frame movable with Shift + Left Mouse
        indicatorFrame:SetMovable(true)
        indicatorFrame:EnableMouse(true)
        indicatorFrame:RegisterForDrag("LeftButton")

        indicatorFrame:SetScript("OnDragStart", function()
            if IsShiftKeyDown() then
                indicatorFrame:StartMoving()
            end
        end)

        indicatorFrame:SetScript("OnDragStop", function()
            indicatorFrame:StopMovingOrSizing()
        end)

        -- Indicator created
    end

    -- Show the frame
    indicatorFrame:Show()
end

-- Track last zone to avoid spam
local lastZoneName = nil
local lastDangerLevel = nil

-- Function to update indicator color based on location
function UpdateIndicatorColor()
    if not indicatorFrame then return end

    -- Get zone name and try to find map ID
    local zoneName = GetRealZoneText()
    local mapId = nil

    if zoneName then
        mapId = ZoneIDs[zoneName]
    end

    local playerX, playerY = GetPlayerMapPosition("player")

    -- Track zone changes (no message, just update tracking)
    if zoneName and zoneName ~= lastZoneName then
        lastZoneName = zoneName
        lastDangerLevel = nil  -- Reset danger level on zone change
    end

    if not mapId or not playerX or not playerY or (playerX == 0 and playerY == 0) then
        -- No position data, set to gray
        indicatorFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.8)
        return
    end

    -- Convert to map coordinates (0-1000 range)
    local mapX = playerX * 1000
    local mapY = playerY * 1000

    -- Get death count at this location
    local deathCount = GetDeathCountAt(mapId, mapX, mapY)
    local maxDeaths = GetMaxDeaths(mapId)

    -- Calculate color based on death density
    local ratio = 0
    if maxDeaths > 0 then
        ratio = deathCount / maxDeaths
    end

    -- Determine danger level
    local dangerLevel = "Safe"
    if ratio <= 0.01 then
        -- Safe (green)
        indicatorFrame:SetBackdropColor(0, 1, 0, 0.9)
        dangerLevel = "Safe"
    elseif ratio <= 0.25 then
        -- Caution (yellow)
        indicatorFrame:SetBackdropColor(1, 1, 0, 0.9)
        dangerLevel = "Caution"
    elseif ratio <= 0.5 then
        -- Dangerous (orange)
        indicatorFrame:SetBackdropColor(1, 0.5, 0, 0.9)
        dangerLevel = "Dangerous"
    else
        -- Very dangerous (red)
        indicatorFrame:SetBackdropColor(1, 0, 0, 0.9)
        dangerLevel = "VERY DANGEROUS"
    end

    -- Only warn when entering dangerous areas (orange/red)
    if dangerLevel ~= lastDangerLevel then
        lastDangerLevel = dangerLevel
        -- Only show message for Dangerous and VERY DANGEROUS
        if dangerLevel == "Dangerous" then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff8000Deathlog:|r Dangerous area!")
        elseif dangerLevel == "VERY DANGEROUS" then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Deathlog:|r VERY DANGEROUS!")
        end
    end
end

-- Function to handle addon load
function Deathlog_OnLoad()
    -- Create the danger indicator
    CreateDangerIndicator()

    -- Preload common maps for faster loading
    PreloadCommonMaps()

    -- Print short welcome message
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Deathlog|r for Vanilla WoW loaded. /dl = indicator, /hm = heatmap")
end

-- Function to update on each frame
function Deathlog_OnUpdate()
    -- In WoW 1.12, elapsed time is passed via arg1, not as a parameter
    if not arg1 then return end
    updateTimer = updateTimer + arg1

    if updateTimer >= UPDATE_INTERVAL then
        UpdateIndicatorColor()
        updateTimer = 0
    end
end

-- Slash command handler
SLASH_DEATHLOG1 = "/deathlog"
SLASH_DEATHLOG2 = "/dl"
SlashCmdList["DEATHLOG"] = function(msg)
    if not msg then msg = "" end

    msg = string.lower(msg)

    if msg == "off" or msg == "hide" then
        if indicatorFrame then
            indicatorFrame:Hide()
        end
        DEFAULT_CHAT_FRAME:AddMessage("Deathlog: Indicator hidden")
    elseif msg == "on" or msg == "show" then
        if indicatorFrame then
            indicatorFrame:Show()
        end
        DEFAULT_CHAT_FRAME:AddMessage("Deathlog: Indicator shown")
    else
        -- Toggle visibility
        if indicatorFrame and indicatorFrame:IsShown() then
            indicatorFrame:Hide()
            DEFAULT_CHAT_FRAME:AddMessage("Deathlog: Indicator hidden")
        else
            if indicatorFrame then
                indicatorFrame:Show()
            end
            DEFAULT_CHAT_FRAME:AddMessage("Deathlog: Indicator shown")
        end
    end
end

-- Heatmap toggle command
SLASH_HEATMAP1 = "/heatmap"
SLASH_HEATMAP2 = "/hm"
SlashCmdList["HEATMAP"] = function(msg)
    ToggleHeatmap()
end

-- Map selector toggle command (placeholder - feature not yet implemented)
SLASH_MAPSELECTOR1 = "/mapselect"
SLASH_MAPSELECTOR2 = "/browse"
SlashCmdList["MAPSELECTOR"] = function(msg)
    DEFAULT_CHAT_FRAME:AddMessage("Deathlog: Map selector not yet implemented")
end

-- Create update frame
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", Deathlog_OnUpdate)

-- Combine all event handlers into one function
-- In WoW 1.12, event handlers use global variables: event, arg1, arg2, etc.
local function OnEvent()
    if event == "ADDON_LOADED" and arg1 == "Deathlog_Vanilla" then
        Deathlog_OnLoad()
    elseif event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
        UpdateIndicatorColor()
        -- Auto-show heatmap for current zone if not already showing
        if Deathlog_HeatVisible and WorldMapFrame and WorldMapFrame:IsShown() then
            UpdateHeatmap(GetCurrentMapZone())
        end
    end
end

-- Register events and set handler
updateFrame:RegisterEvent("ADDON_LOADED")
updateFrame:RegisterEvent("ZONE_CHANGED")
updateFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
updateFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
updateFrame:SetScript("OnEvent", OnEvent)

-- Create indicator immediately on file load
CreateDangerIndicator()