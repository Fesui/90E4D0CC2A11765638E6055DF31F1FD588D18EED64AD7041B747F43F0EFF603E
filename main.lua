if game.PlaceId ~= 13342303743 and game.PlaceId ~= 7862839080 then warn("승리재단이 아닙니다.") end
-------------------------==Service==-------------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local lplr = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-------------------------------------------------------------

---------------------------==ACS==---------------------------
local evts = ReplicatedStorage.ACS_Engine.Events
local ACS_0 = evts.AcessId:InvokeServer(game:GetService("Players").LocalPlayer.UserId)
-------------------------------------------------------------

-------------------------==HDADMIN==-------------------------
local HDGUI = lplr.PlayerGui:FindFirstChild("HDAdminGUIs")
local HDREP = ReplicatedStorage:WaitForChild("HDAdminClient")
local pdata = HDREP.Signals.RetrieveData:InvokeServer()
-------------------------------------------------------------

------------------------==Variaveis==------------------------
local kexclude, conns = {}, {}
local ck, ACS, Place, ac
local Theme = "Darker"
local Version = "2.2523"
------------------------==Variaveis==------------------------

local function kill(hum)
	local gun = lplr:FindFirstChild("ACS_Settings" , true)
	if not gun then
		local chaos = game:GetService("Workspace").Maps.Spawns["Chaos - 반란군 스폰"]
		local temp = chaos.CFrame
		local humroot = lplr.Character.HumanoidRootPart
		chaos.CFrame = humroot.CFrame
		task.wait(.1)
		humroot.CFrame = CFrame.new(humroot.CFrame.X, humroot.CFrame.Y+1, humroot.CFrame.Z)
		chaos.CFrame = temp
		temp = humroot.CFrame
		lplr.Character.Head:Destroy()
		task.wait(Players.RespawnTime+1)
		lplr.Character.HumanoidRootPart.CFrame = temp
	end
	gun = gun.Parent
    if hum then
        evts.Damage:InvokeServer(gun, hum, 0, 1, require(gun.ACS_Settings), { minDamageMod=2009523, DamageMod=2009523 }, nil, nil, ACS_0..'-'..tostring(lplr.UserId), ACS_0, nil)
    end
end

pcall(function()
	local placeId = game.PlaceId
	local placeInfo = game:GetService("MarketplaceService"):GetProductInfo(placeId)
	Place = placeInfo.Name
end)

local Window = Fluent:CreateWindow({
	Title = "EUNGDI HUB " .. Version,
	SubTitle = "by Roh Moo Hyun",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = Theme,
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Current = Window:AddTab({ Title = "Current", Icon = "scan" })

Current:AddSection("게임")

Current:AddParagraph({
	Title = "Running in",
	Content = Place
})

Current:AddParagraph({
	Title = "Rank",
	Content = pdata["pdata"].Rank .. (pdata["pdata"].SaveRank and (", PermRanked by " .. Players:GetNameFromUserIdAsync(pdata["pdata"].PermRankedBy)) or "")
})

local WF = Window:AddTab({ Title = "승리재단", Icon = "locate" })

WF:AddSection("서버 테러")

local Slider = WF:AddSlider("Slider", {
	Title = "핑핵 파워",
	Description = "핑 파워를 조절합니다.",
	Default = 2,
	Min = 1,
	Max = 2009,
	Rounding = 1
})

Slider:OnChanged(function(Value)
	getfenv().PinghackPower = Value
end)

WF:AddToggle("핑핵 실행", {
	Title = "핑핵", 
	Description = "핑핵을 실행합니다.",
	Default = false,
	Callback = function(state)
		if state then
			conns[1] = game:GetService("RunService").RenderStepped:Connect(function()
				for i = 1, getfenv().PinghackPower do
					pcall(evts.Equip.FireServer, evts.Equip, {["Name"] = ReplicatedStorage.ACS_Engine.GunModels:FindFirstChildOfClass("Model").Name}, 1, ACS_0)
					pcall(evts.Drag.FireServer, evts.Drag, Players:FindFirstChildOfClass("Player"))
				end
			end)
		else
			if conns[1] then
				conns[1]:Disconnect()
				conns[1] = nil
			end
		end
	end
})

WF:AddInput("ACS_KillExclude", {
	Title = "킬올 제외",
	Description = "유저를 킬올 대상자에서 제외합니다.",
	Default = "",
	Placeholder = "PlozPain",
	Numeric = false,
	Finished = true,
	Callback = function(Value)
		if Value == "" then return end
		if Players:FindFirstChild(Value) then
			if kexclude[Value] then
				kexclude[Value] = nil
				Fluent:Notify({
				Title = "EUNGDI HUB",
				Content = Value.." 제거되었습니다.",
				SubContent = "good signal",
				Duration = 3
			})
			else
				kexclude[Value] = true
				Fluent:Notify({
				Title = "EUNGDI HUB",
				Content = Value.." 추가되었습니다.",
				SubContent = "good signal",
				Duration = 3
			})
			end
		else
			Fluent:Notify({
				Title = "EUNGDI HUB",
				Content = "닉네임이 정확한지 확인해 주세요.",
				SubContent = "bad signal",
				Duration = 5
			})
		end
	end
})

WF:AddButton({
	Title = "킬올",
	Description = "모든 유저를 죽입니다.",
	Callback = function()
		for _, plr in pairs(game.Players:GetPlayers()) do
			if kexclude[plr.Name] then continue end
			kill(plr.Character:FindFirstChildOfClass("Humanoid"))
		end
	end
})

WF:AddToggle("클릭 킬", {
	Title = "클릭 킬",
	Description = "클릭으로 유저를 죽입니다.",
	Default = false,
	Callback = function(state)
		if state then
			conns[2] = lplr:GetMouse().Button1Down:Connect(function()
				local target = lplr:GetMouse().Target
				if not target then return end

				local chr = target.Parent
				local plr = Players:GetPlayerFromCharacter(chr) or Players:GetPlayerFromCharacter(chr.Parent)
				if plr then
					kill(plr.Character:FindFirstChildOfClass("Humanoid"))
				end
			end)
		else
			if conns[2] then
				conns[2]:Disconnect()
				conns[2] = nil
			end
		end
	end
})

WF:AddToggle("클릭 킬(몹)", {
    Title = "클릭 킬(몹)",
    Description = "클릭으로 몹을 죽입니다.",
    Default = false,
    Callback = function(state)
        if state then
            conns[3] = lplr:GetMouse().Button1Down:Connect(function()
                local target = lplr:GetMouse().Target
                if not target then return end

                local chr = target.Parent
				local plr = Players:GetPlayerFromCharacter(chr) or Players:GetPlayerFromCharacter(chr.Parent)
				if not plr then
					kill(chr:FindFirstChildOfClass("Humanoid"))
				end
            end)
        else
            if conns[3] then
                conns[3]:Disconnect()
                conns[3] = nil
            end
        end
    end
})

WF:AddInput("ACS_Namekill", {
	Title = "닉네임 킬",
	Description = "닉네임으로 유저를 죽입니다.",
	Default = "",
	Placeholder = "GRTAgdgdgf",
	Numeric = false,
	Finished = true,
	Callback = function(Value)
		if Value == "" then return end
		local plr = Players:FindFirstChild(Value)
		if plr then
			kill(plr.Character:FindFirstChildOfClass("Humanoid"))
		else
			Fluent:Notify({
				Title = "EUNGDI HUB",
				Content = "닉네임이 정확한지 확인해 주세요.",
				SubContent = "bad signal",
				Duration = 5
			})
		end
	end
})

WF:AddSection("기능")

WF:AddToggle("카운트 제거", {
	Title = "카운트 제거",
	Description = "카운트를 제거합니다.",
	Default = false,
	Callback = function(state)
		if state then
			for _, hint in ipairs(HDGUI.MessageContainer.Hints:GetChildren()) do
				if hint:FindFirstChild("Desc") and tonumber(hint.Desc.Text) then hint:Destroy() end
			end
			for _, message in ipairs(HDGUI.MessageContainer.Messages:GetChildren()) do
				if message:FindFirstChild("Title") and message.Title.Text == "Countdown" then message:Destroy() end
			end
			ck = {HDGUI.MessageContainer.Hints.ChildAdded:Connect(function(hint)
				if hint:FindFirstChild("Desc") and tonumber(hint.Desc.Text) then hint:Destroy() end
			end), HDGUI.MessageContainer.Messages.ChildAdded:Connect(function(message)
				if message:FindFirstChild("Title") and message.Title.Text == "Countdown" then message:Destroy() end
			end)}
		else
			if ck then
				for _, conn in ipairs(ck) do conn:Disconnect() end
			end
		end
	end
})

WF:AddToggle("블루어 제거", {
	Title = "블루어 제거",
	Description = "흐림 효과를 제거합니다.",
	Callback = function(state)
		if state then
			conns[4] = game:GetService("RunService").Heartbeat:Connect(function()
				game:GetService("Workspace").CurrentCamera.Blur.Size = 0
			end)
		else
			if conns[4] then
				conns[4]:Disconnect()
				conns[4] = nil
			end
		end
	end
})

WF:AddToggle("강제 언뮤트", {
	Title = "강제 언뮤트",
	Description = "채팅창을 활성화시킵니다.",
	Callback = function(state)
		if state then
			conns[5] = game:GetService("RunService").Heartbeat:Connect(function()
				game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
			end)
		else
			if conns[5] then
				conns[5]:Disconnect()
				conns[5] = nil
			end
		end
	end
})

WF:AddButton({
	Title = "HD 복구",
	Description = "HD가 없다면 복구합니다.",
	Callback = function()
		if not game:GetService("Workspace"):FindFirstChild("HDAdminWorkspaceFolder") then
			local workspaceFolder = Instance.new("Folder")
			workspaceFolder.Name = "HDAdminWorkspaceFolder"
			workspaceFolder.Parent = game:GetService("Workspace")
		end
	end
})

WF:AddButton({
	Title = "재접",
	Description = "이 서버로 재접속합니다.",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, lplr)
	end
})

local Standard = Window:AddTab({ Title = "Standard", Icon = "loader" })

Standard:AddSection("스탠다드")

Standard:AddToggle("프리캠", {
	Title = "프리캠 - WIP",
	Description = "프리캠을 활성화시킵니다.",
	Callback = function(state)
		if state then
			
		else
			
		end
	end
})

Fluent:Notify({
	Title = "EUNGDI HUB",
	Content = "응디 허브가 정상적으로 실행됨",
	SubContent = "good signal",
	Duration = 5 
})
