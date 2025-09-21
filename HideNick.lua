--// DXPLOIT - Hide Nickname (Respawn Fix + Draggable Toggle Box)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CUSTOM_NAME = "DXPLOIT MEMBER"
local CUSTOM_TAG = "@DXPLOITGG"

local selfEnabled = false
local globalEnabled = false

-- RGB name loop
local function startRGBLoop(textLabel)
    if not textLabel or not textLabel.Parent then return end
    if textLabel:GetAttribute("dxp_rgb_running") then return end
    textLabel:SetAttribute("dxp_rgb_running", true)
    textLabel:SetAttribute("dxp_rgb", true)
    task.spawn(function()
        local t = 0
        while textLabel.Parent and textLabel:GetAttribute("dxp_rgb") do
            local r = math.floor((math.sin(t) * 0.5 + 0.5) * 255)
            local g = math.floor((math.sin(t + 2) * 0.5 + 0.5) * 255)
            local b = math.floor((math.sin(t + 4) * 0.5 + 0.5) * 255)
            pcall(function() textLabel.TextColor3 = Color3.fromRGB(r,g,b) end)
            t = t + 0.12
            task.wait(0.08)
        end
        textLabel:SetAttribute("dxp_rgb_running", false)
    end)
end

local function stopRGB(textLabel)
    if textLabel then
        textLabel:SetAttribute("dxp_rgb", false)
    end
end

local function replaceLabelText(textLabel, newText, applyRGBFlag)
    if not textLabel then return end
    if not textLabel:GetAttribute("dxp_orig_text") then
        textLabel:SetAttribute("dxp_orig_text", textLabel.Text)
    end
    textLabel.Text = newText
    if applyRGBFlag then
        startRGBLoop(textLabel)
    else
        stopRGB(textLabel)
        textLabel.TextColor3 = Color3.fromRGB(255,255,255)
    end
end

local function restoreLabelText(textLabel)
    if not textLabel then return end
    local orig = textLabel:GetAttribute("dxp_orig_text")
    if orig then
        textLabel.Text = orig
        textLabel:SetAttribute("dxp_orig_text", nil)
    end
    stopRGB(textLabel)
end

-- Spoof hanya DisplayName dan @username
local function spoofCharacterForPlayer(char, player, doName, doTag)
    if not char or not char.Parent then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    for _, gui in pairs(head:GetChildren()) do
        if gui:IsA("BillboardGui") then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") then
                    local txt = string.lower(obj.Text)

                    -- DisplayName / Name
                    if doName and (txt == string.lower(player.DisplayName) or txt == string.lower(player.Name)) then
                        replaceLabelText(obj, CUSTOM_NAME, true)
                    end

                    -- @Username
                    if doTag and (txt == "@"..string.lower(player.Name)) then
                        replaceLabelText(obj, CUSTOM_TAG, false)
                        pcall(function() obj.TextColor3 = Color3.fromRGB(255,255,255) end)
                    end
                end
            end
        end
    end
end

local function restoreCharacterLabels(char, player)
    if not char or not char.Parent then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, gui in pairs(head:GetChildren()) do
        if gui:IsA("BillboardGui") then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") then
                    restoreLabelText(obj)
                end
            end
        end
    end
end

-- Terapkan state global ke semua player
local function applyGlobalState()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            if globalEnabled then
                spoofCharacterForPlayer(player.Character, player, true, true)
            else
                restoreCharacterLabels(player.Character, player)
            end
        end
    end
end

-- Terapkan state ke self
local function applySelfState()
    if LocalPlayer.Character then
        if selfEnabled then
            spoofCharacterForPlayer(LocalPlayer.Character, LocalPlayer, true, true)
        else
            restoreCharacterLabels(LocalPlayer.Character, LocalPlayer)
        end
    end
end

-- Saat player join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        if globalEnabled then spoofCharacterForPlayer(char, player, true, true) end
        if player == LocalPlayer and selfEnabled then spoofCharacterForPlayer(char, player, true, true) end
    end)
end)

-- Saat sudah ada player
for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        if globalEnabled then spoofCharacterForPlayer(char, player, true, true) end
        if player == LocalPlayer and selfEnabled then spoofCharacterForPlayer(char, player, true, true) end
    end)
end

--// GUI Toggle (Draggable)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DX_HideNick"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 100)
Frame.Position = UDim2.new(0.5, -120, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- <-- bikin bisa dipindah-pindah

local UIList = Instance.new("UIListLayout", Frame)
UIList.FillDirection = Enum.FillDirection.Vertical

local btnSelf = Instance.new("TextButton", Frame)
btnSelf.Size = UDim2.new(1,0,0,40)
btnSelf.Text = "Self Spoof: OFF"
btnSelf.MouseButton1Click:Connect(function()
    selfEnabled = not selfEnabled
    btnSelf.Text = "Self Spoof: " .. (selfEnabled and "ON" or "OFF")
    applySelfState()
end)

local btnGlobal = Instance.new("TextButton", Frame)
btnGlobal.Size = UDim2.new(1,0,0,40)
btnGlobal.Text = "Global Spoof: OFF"
btnGlobal.MouseButton1Click:Connect(function()
    globalEnabled = not globalEnabled
    btnGlobal.Text = "Global Spoof: " .. (globalEnabled and "ON" or "OFF")
    applyGlobalState()
end)
