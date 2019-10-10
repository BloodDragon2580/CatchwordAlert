local L = LibStub("AceLocale-3.0"):GetLocale("CatchwordAlert", false)

CatchwordAlert.defaults = {
    profile = {
        enabled = true,
        soundOn = true,
        sound = "9379",
        printOn = true,
        channels = {},
        words = {},
    }
}

local channelToDelete, wordToDelete = nil, nil
local availableChannels = {}

CatchwordAlert.options = {
    name = L["CatchwordAlert"],
    handler = CatchwordAlert,
    type = "group",
    args = {
        enable = {
            name = L["Enable"],
            desc = L["Enable/disable the addon"],
            type = "toggle", order = 1, width = "half",
            get = function(info) return CatchwordAlert.db.profile.enabled end,
            set = function(info, val)
                CatchwordAlert.db.profile.enabled = val
                if val then CatchwordAlert:OnEnable()
                else CatchwordAlert:OnDisable() end
            end,
        },
        channels = {
            name = L["Channels"],
            type = "group", inline = true, order = 5,
            args = {
                pickChannel = {
                    name = L["Select New Channel"],
                    desc = L["Select a channel to watch"],
                    type = "select", order = 1, width = 1,
                    values = function()
                        availableChannels = {}
                        for i = 1, NUM_CHAT_WINDOWS do
                            local num, name = GetChannelName(i)
                            if num > 0 then
                                local channel = num .. ". " .. name
                                tinsert(availableChannels, channel)
                            else
                                tinsert(availableChannels, name)
                            end
                        end
                        return availableChannels
                    end,
                    set = function(info, val) tinsert(CatchwordAlert.db.profile.channels, availableChannels[val]) end,
                    disabled = function() return not CatchwordAlert.db.profile.enabled end,
                },
                removeChannel = {
                    name = L["Remove Channel"],
                    desc = L["Select a channel to remove from being watched"],
                    type = "select", order = 2, width = 1,
                    values = function() return CatchwordAlert.db.profile.channels end,
                    get = function(info) return channelToDelete end,
                    set = function(info, val) channelToDelete = val end,
                    disabled = function() return not CatchwordAlert.db.profile.enabled end,
                },
                removeChannelButton = {
                    name = L["Remove Channel"],
                    desc = L["Remove selected channel from being watched"],
                    type = "execute", order = 3, width = 0.8,
                    func = function()
                        if channelToDelete then
                            tremove(CatchwordAlert.db.profile.channels, channelToDelete)
                            channelToDelete = nil
                        end
                    end,
                    disabled = function() return not CatchwordAlert.db.profile.enabled end,
                },
                addChannel = {
                    name = L["Add Channel"],
                    desc = L["Add a channel to watch"],
                    type = "input", order = 4,
                    set = function(info, val) if val and val ~= "" then tinsert(CatchwordAlert.db.profile.channels, val) end end,
                    disabled = function() return not CatchwordAlert.db.profile.enabled end,
                },
            },
        },
        keywords = {
            name = L["catchwords"],
            type = "group", inline = true, order = 6,
            args = {
                addKeyword = {
                    name = L["Add catchword"],
                    desc = L["Add a catchword to watch for"],
                    type = "input", order = 5,
                    set = function(info, val) if val and val ~= "" then tinsert(CatchwordAlert.db.profile.words, val) end end,
                    disabled = function() return not CatchwordAlert.db.profile.enabled end,
                },
                removeKeyword = {
                    name = L["Remove catchword"],
                    desc = L["Select a catchword to remove from being watched for"],
                    type = "select", order = 6, width = 1,
                    values = function() return CatchwordAlert.db.profile.words end,
                    get = function(info) return wordToDelete end,
                    set = function(info, val) wordToDelete = val end,
                    disabled = function() return not CatchwordAlert.db.profile.enabled end,
                },
                removeKeywordButton = {
                    name = L["Remove catchword"],
                    desc = L["Remove selected catchword from being watched for"],
                    type = "execute", order = 7, width = 0.8,
                    func = function()
                        if wordToDelete then
                            tremove(CatchwordAlert.db.profile.words, wordToDelete)
                            wordToDelete = nil
                        end
                    end,
                    disabled = function() return not CatchwordAlert.db.profile.enabled end,
                },
            },
        },
    },
}
