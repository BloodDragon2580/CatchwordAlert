CatchwordAlert = LibStub("AceAddon-3.0"):NewAddon("CatchwordAlert", "AceConsole-3.0", "AceEvent-3.0")

local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("CatchwordAlert")

function CatchwordAlert:OnInitialize()

    self.db = LibStub("AceDB-3.0"):New("CatchwordAlertDB", self.defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("CatchwordAlert", self.options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CatchwordAlert", "CatchwordAlert")

    self:RegisterChatCommand("CatchwordAlert", "ChatCommand")
end

function CatchwordAlert:OnEnable()
    if self.db.profile.enabled then self:RegisterEvent("CHAT_MSG_CHANNEL") end
end

function CatchwordAlert:OnDisable()
    self:UnregisterEvent("CHAT_MSG_CHANNEL")
end

function CatchwordAlert:CHAT_MSG_CHANNEL(event, message, author, _, channel)
    if TrimRealmName(author) == UnitName("player") then return end

    for k, ch in pairs(self.db.profile.channels) do
        if event == "CHAT_MSG_CHANNEL" and channel:lower() == ch:lower() then
            for k2, word in pairs(self.db.profile.words) do
                if message:lower():find(word:lower()) then
                    if self.db.profile.soundOn then PlaySound(self.db.profile.sound) end
                    if self.db.profile.printOn then
                        LibStub("AceConsole-3.0"):Print(format(L["Printed CatchwordAlert"], word, TrimRealmName(author), message))
                    end
                    break
                end
            end
            break
        end
    end
end

function CatchwordAlert:ChatCommand(arg)
    if arg == "CatchwordAlerts" then
        self:ShowCatchwordAlertFrame()
    else
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end
end

function TrimRealmName(author)
    local name = author
    local realmDelim = name:find("-")
    if realmDelim ~= nil then
        name = name:sub(1, realmDelim - 1)
    end
    return name
end
