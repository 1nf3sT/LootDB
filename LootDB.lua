-- Name: LootDB
-- Revision: $Revision: 69709 $
-- Developed by: Filiassin - mlu@azerothischer-bote.de (http://www.azerothischer-bote.de)
-- Description: Shows loot information in item tooltips

---------------
-- Libraries --
---------------
local L = AceLibrary("AceLocale-2.2"):new("LootDB")
local TipHooker = AceLibrary("TipHooker-1.0")

--------------------
-- AceAddon Setup --
--------------------
-- AceAddon Initialization
LootDB = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDebug-2.0")
LootDB.title = "LootDB"
LootDB.version = "1.0"
LootDB.date = "2008-04-14"

-------------------
-- Set Debugging --
-------------------
LootDB:SetDebugging(false)

---------------------
-- Initializations --
---------------------
function LootDB:OnInitialize()
  self:RegisterChatCommand("/lootdb", "/ldb", consoleOptions, "LOOTDB")
end

-- OnEnable() called at PLAYER_LOGIN
function LootDB:OnEnable()
  -- Hook item tooltips
  TipHooker:Hook(self.ProcessTooltip, "item")
end

function LootDB:OnDisable()
  -- Unhook item tooltips
  TipHooker:Unhook(self.ProcessTooltip, "item")
end

--------------------------
-- Process Tooltip Core --
--------------------------

function LootDB.explode(delimiter, text)
  local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

function LootDB.ProcessTooltip(tooltip, name, link)
  -------------
  -- Item ID --
  -------------
  if link then
    _, _, itemID = strfind(link, "item:(%d+)")

    ---------------------
    -- Print lootinfo  --
    ---------------------
    if itemID ~= nil then
      if LILootTable[itemID] then

        itemdata = LootDB.explode(":",LILootTable[itemID])

        tooltip:AddLine(" ")

        tooltip:AddLine("|cffFFCC33"..L["Source"]..": |r"..L[LILootTableAreas[itemdata[1]]],1.0,1.0,1.0)
        if not(itemdata[3] == "0") then
          tooltip:AddLine("|cffFFCC33"..L["Boss"]..": |r"..L[LILootTableBoss[itemdata[3]]],1.0,1.0,1.0)
        else
          tooltip:AddLine("|cffFFCC33"..L["Boss"]..": |r"..L["Chest Drop"],1.0,1.0,1.0)
        end

        if not (itemdata[2] == "") then
          tooltip:AddLine("|cffFFCC33"..L["Difficulty"]..": |r"..L["heroic"],1.0,1.0,1.0)
        end

        if itemdata[1] == "badgeofjustice" then
          if tonumber(itemdata[4]) > 0 then
            tooltip:AddLine("|cffFFCC33"..L["Count"]..": |r"..itemdata[4],1.0,1.0,1.0)
          end
        elseif itemdata[1] == "spiritshard" then
          if tonumber(itemdata[4]) > 0 then
            tooltip:AddLine("|cffFFCC33"..L["Count"]..": |r"..itemdata[4],1.0,1.0,1.0)
          end
        else
          if not (itemdata[4] == "") then
            if itemdata[4]     == "0" then
              tooltip:AddLine("|cffFFCC33"..L["Droprate"]..": |r"..L["unknown"],1.0,1.0,1.0)
            elseif itemdata[4] == "1" then
              tooltip:AddLine("|cffFFCC33"..L["Droprate"]..": |r"..L["extremely low"].." (1% - 2%)",1.0,1.0,1.0)
            elseif itemdata[4] == "2" then
              tooltip:AddLine("|cffFFCC33"..L["Droprate"]..": |r"..L["very low"].." (3% - 14%)",1.0,1.0,1.0)
            elseif itemdata[4] == "3" then
              tooltip:AddLine("|cffFFCC33"..L["Droprate"]..": |r"..L["low"].." (15% - 24%)",1.0,1.0,1.0)
            elseif itemdata[4] == "4" then
              tooltip:AddLine("|cffFFCC33"..L["Droprate"]..": |r"..L["medium"].." (25% - 49%)",1.0,1.0,1.0)
            elseif itemdata[4] == "5" then
              tooltip:AddLine("|cffFFCC33"..L["Droprate"]..": |r"..L["high"].." (50% - 99%)",1.0,1.0,1.0)
            elseif itemdata[4] == "6" then
              tooltip:AddLine("|cffFFCC33"..L["Droprate"]..": |r"..L["guaranteed"].." (100%)",1.0,1.0,1.0)
            end
          end
        end
      end

      if LIPvpLootTable then
        if LIPvpLootTable[itemID] then
          tooltip:AddLine(" ")

          loottext = L["PvP reward"]
          if not(LILootTablePvpFaction[LIPvpLootTable[itemID]] == "") then
            loottext = loottext.." ("..LILootTablePvpFaction[LIPvpLootTable[itemID]]..")"
          end

          tooltip:AddLine("|cffFFCC33"..L["Source"]..": |r"..loottext,1.0,1.0,1.0)
        end
      end
      
      ---------------------
      -- Repaint tooltip --
      ---------------------
      tooltip:Show()
      
    end
  end
end
