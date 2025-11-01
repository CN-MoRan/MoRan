--只有被开源才能成长 by 冷
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "恐鬼症 1.2.1  [停更]",
   Icon = 0,
   LoadingTitle = "恐鬼症 1.2.1  [停更]",
   LoadingSubtitle = "by 龙城",
   Theme = "DarkBlue",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   KeySystem = true,
   KeySettings = {
      Title = "恐鬼症 1.2.1  [停更]",
      Subtitle = "验证系统",
      Note = "加入群聊看公告获取卡密 企鹅交流群:751910733",
      FileName = "horror",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"LongCheng"}
   }
})

--函数
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace:GetDescendants()
local Workspace1 = game:GetService("Workspace")
--函数

--锁定函数
local GhostLock = true
--锁定函数

--初始化诅咒道具透视函数
local Cursed = {}
for _, CursedSpawns in ipairs(Workspace) do
	if CursedSpawns:IsA("Model") and CursedSpawns.Name == "Ouija Board" then
		Cursed = CursedSpawns
	end
	if CursedSpawns:IsA("Model") and CursedSpawns.Name == "SummoningCircle" then
		Cursed = CursedSpawns
	end
	if CursedSpawns:IsA("Tool") and CursedSpawns.Name == "Tarot Cards" then
		Cursed = CursedSpawns
	end
end
--初始化诅咒道具透视函数

--初始化互动透视
local EMFBillboardGuiDescendantAdded
function EMFBillboardGui(descendant)
	if descendant:IsA("Part") and descendant.Name == "EMFPart" then
		local BillboardGui = Instance.new("BillboardGui")
		local TextLabel = Instance.new("TextLabel")

        BillboardGui.Name = "EMFBillboardGui"
		BillboardGui.Parent = descendant
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 40, 0, 20)

        TextLabel.Parent = BillboardGui
		TextLabel.Text = "互动"
        TextLabel.BackgroundTransparency = 1
		TextLabel.Size = UDim2.new(0, 40, 0, 20)
        TextLabel.TextColor3 = Color3.fromRGB(70, 255, 0)
		TextLabel.TextSize = 10
	end
end
--初始化互动透视

local Function = Window:CreateTab("功能", "book-check")

--证据
local Section = Function:CreateSection("证据")
local EMFCountLabel = Function:CreateParagraph({Title = "互动(电磁场读取)", Content = "出现次数:未知"})
local Thermometer = Function:CreateParagraph({Title = "冻结温度(一直获取 = 没有冻结温度)", Content = "获取中..."})
local Ouijabox = Function:CreateParagraph({Title = "精灵盒(道具需要在鬼房)", Content = "捕捉中..."})
--证据

--玩家
local Section = Function:CreateSection("玩家")
local Collision = Function:CreateToggle({
    Name = "穿门",
    CurrentValue = false,
    Flag = "切换按钮",
    Callback = function(Value)
        for _, Doors in ipairs(Workspace) do
            if Doors:IsA("Folder") and Doors.Name == "Doors" then
            local ModelDoors = Doors:GetDescendants()
		        for _, ModelDoor in ipairs(ModelDoors) do
		            if ModelDoor:IsA("MeshPart") or ModelDoor:IsA("Part") then
			            if ModelDoor.Name == "RightDoor" or ModelDoor.Name == "LeftDoor" or ModelDoor.Name == "Door"  then
					        if ModelDoor.CanCollide then
						        ModelDoor.CanCollide = false
					        	else
					            ModelDoor.CanCollide = true
					        end
			        	end
		        	end
		        end
            end
        end
    end,
})
local Light = Function:CreateButton({
    Name = "夜视",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.Atmosphere:Destroy()
    end,
})
local SpeedPlayer = Function:CreateToggle({
   Name = "稳定速度+无限体力(BUG利用)",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        if Value then
            for _, LocalPlayer in ipairs(LocalPlayer:GetChildren()) do
	            if LocalPlayer.Name == "Dead" then
					LocalPlayer.Value = true
	            end
            end
            Rayfield:Notify({
               Title = "告知",
                Content = "开启后加速无法关闭，除非游戏重置移动数度",
                Duration = 5,
                Image = "triangle-alert",
            })
			else
            for _, LocalPlayer in ipairs(LocalPlayer:GetChildren()) do
	            if LocalPlayer.Name == "Dead" then
					LocalPlayer.Value = false
	            end
            end
		end
   end,
})
--玩家

--透视
local Section = Function:CreateSection("透视")
local Ghost = Function:CreateToggle({
   Name = "幽灵",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        if GhostLock then
            GhostLock = false
            GhostESP()
            else
            GhostLock = true
        end
   end,
})
local EMF = Function:CreateToggle({
   Name = "互动",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        if Value then
			EMFBillboardGuiDescendantAdded = workspace.Map.DescendantAdded:Connect(EMFBillboardGui)
			else
			EMFBillboardGuiDescendantAdded:Disconnect()
		end
   end,
})
local Cursed = Function:CreateToggle({
   Name = "诅咒道具",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        if Value then
			local CursedHighlight = Cursed:FindFirstChild("CursedESP")
            if not CursedHighlight then
	            local Highlight = Instance.new("Highlight")
                Highlight.Name = "CursedESP"
                Highlight.Parent = Cursed
                Highlight.FillTransparency = 1
                Highlight.OutlineColor = Color3.fromRGB(255, 170, 127)
                Highlight.OutlineTransparency = 0.2
            end
			else
			local CursedHighlightDestroy = Cursed:FindFirstChild("CursedESP")
            if CursedHighlightDestroy then
				CursedHighlightDestroy:Destroy()
			end
		end
   end,
})
local VoodooDoll = Function:CreateToggle({
   Name = "巫毒娃娃",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        if Value then
			local VoodooDoll = Workspace1.VoodooDoll
            local VoodooDollHighlightRepeat = VoodooDoll:FindFirstChild("VoodooDollESP")
            if not VoodooDollHighlightRepeat then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "VoodooDollESP"
                Highlight.Parent = VoodooDoll
                Highlight.FillTransparency = 1
                Highlight.OutlineColor = Color3.fromRGB(0,255,255)
                Highlight.OutlineTransparency = 0.5
            end
			else
			local VoodooDollDestroy = Workspace1.VoodooDoll
            local VoodooDollHighlightRepeatDestroy = VoodooDollDestroy:FindFirstChild("VoodooDollESP")
            if VoodooDollHighlightRepeatDestroy then
				VoodooDollHighlightRepeatDestroy:Destroy()
			end
		end
   end,
})
local Generators = Function:CreateToggle({
   Name = "发电机",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        if Value then
            local Generators = Workspace1.Map.Generators.GeneratorMesh
            local GeneratorsHighlightRepeat = Generators:FindFirstChild("GeneratorsESP")
            if not GeneratorsHighlightRepeat then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "GeneratorsESP"
                Highlight.Parent = Generators
                Highlight.FillTransparency = 1
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 127)
                Highlight.OutlineTransparency = 0.3
            end
			else
			local GeneratorsDestroy = Workspace1.Map.Generators.GeneratorMesh
            local GeneratorsHighlightRepeatDestroy = GeneratorsDestroy:FindFirstChild("GeneratorsESP")
            if GeneratorsHighlightRepeatDestroy then
				GeneratorsHighlightRepeatDestroy:Destroy()
			end
		end
   end,
})
--透视

--恶搞
local Section = Function:CreateSection("恶搞")
local Death = Function:CreateButton({
   Name = "自杀(确保自己没有带道具再使用)",
   Callback = function()
        local DeathLocalPlayer = Players.LocalPlayer
        local DeathCharacter = DeathLocalPlayer.Character
        local DeathHumanoid = DeathCharacter.Humanoid
		DeathHumanoid.Health = 0
   end,
})

--恶搞

local Announcement = Window:CreateTab("公告", "bell-ring")
--公告
local Paragraph = Announcement:CreateParagraph({Title = "[+]添加[卡密]功能", Content = "为了能更好的集中一个群内"})
local Paragraph = Announcement:CreateParagraph({Title = "[+]修复[穿门]功能", Content = "修复了无法穿其他地图的大门了"})
local Paragraph = Announcement:CreateParagraph({Title = "[+]添加[自杀]功能", Content = "可以让自己随时随地死亡了"})
local Paragraph = Announcement:CreateParagraph({Title = "[+]透视更改", Content = "可以关闭啦"})
local Paragraph = Announcement:CreateParagraph({Title = "[+]布局重组", Content = "更美观啦"})
local Paragraph = Announcement:CreateParagraph({Title = "[+]公告窗口", Content = "可以查看更详细的更新内容啦"})
--公告

local Player = Window:CreateTab("防巡查(玩家加入记录)", "triangle-alert")
--初始化防巡查
local function onPlayerJoin(player)
    local playerName = "Name:" .. player.Name
	local playerId = "ID:" .. player.UserId
    local PlayersTitie = Player:CreateParagraph({Title = playerName, Content = playerId})
	Rayfield:Notify({
        Title = "玩家加入记录",
        Content = "有新玩家加入了本局，疑似巡查请注意演戏",
        Duration = 5,
        Image = "triangle-alert",
    })
end
Players.PlayerAdded:Connect(onPlayerJoin)
--初始化防巡查

--初始化EMF出现次数
local EMFCount = 0
function MapDescendantAdded(descendant)
	if descendant:IsA("Part") and descendant.Name == "EMFPart" then
	    EMFCount = EMFCount + 1
		local EMFMerge = "出现次数:" .. EMFCount
        EMFCountLabel:Set({Title = "互动(电磁场读取)", Content = EMFMerge})
	end
end
workspace.Map.DescendantAdded:Connect(MapDescendantAdded)
--初始化EMF出现次数

--初始化幽灵透视
function GhostESP()
	repeat
		for _, Ghost in ipairs(Workspace1:GetChildren()) do
			if Ghost.Name == "Ghost" and Ghost:IsA("Model") then
			    local GhostParts = Ghost:GetChildren()
				for _, GhostPart in ipairs(GhostParts) do
					if GhostPart:IsA("MeshPart") then
						local New = GhostPart:FindFirstChild("GhostESP")
						if not New then
							local boxHandleAdornment = Instance.new("BoxHandleAdornment")
                            boxHandleAdornment.Name = "GhostESP"
							boxHandleAdornment.Size = Vector3.new(1, 1, 1)
							boxHandleAdornment.AlwaysOnTop = true
							boxHandleAdornment.ZIndex = 5
							boxHandleAdornment.Parent = GhostPart
                            boxHandleAdornment.Adornee = GhostPart
							boxHandleAdornment.Transparency = 0.4
						end
					end
				end
			end
		end
		wait(1)
	until GhostLock
end
--初始化幽灵透视
--初始化精灵盒功能
local Spirit = workspace:GetDescendants()
local Name = "Spirit Box"
local Lock2 = false

function onchildAdded(child)
	if child:IsA("Sound") then
		local childName = string.lower(child.Name)
        Ouijabox:Set({Title = "精灵盒(道具需要在鬼房)", Content = childName})
        if Lock2 == false then
            Rayfield:Notify({
                Title = "精灵盒",
                Content = "精灵盒获取成功，请在界面内查看",
                Duration = 5,
                Image = "check",
            })
        end
        Lock2 = true
	end
end

for _, SpiritName in ipairs(Spirit) do
    if SpiritName.Name == Name and SpiritName:IsA("Tool") then
        local Handle = SpiritName:GetChildren()
		for _, HandleName in ipairs(Handle) do
			if HandleName.Name == "Handle" then
				HandleName.ChildAdded:Connect(onchildAdded)
			end
		end
    end
end
--初始化精灵盒功能
Rayfield:LoadConfiguration()
--初始化冻结温度功能
local Lock = false
repeat
    for _, workspaces in ipairs(Workspace) do
	    if workspaces.Name == "_____Temperature" then
		    if workspaces.Value < 0 and workspaces.Value > -3 then
			    local WorkspaceValue = tonumber(workspaces.Value)
			    Thermometer:Set({Title = "冻结温度(一直获取 = 没有冻结温度)", Content = WorkspaceValue})
				Rayfield:Notify({
                    Title = "冻结温度",
                    Content = "冻结温度获取成功，请在界面内查看",
                    Duration = 5,
                    Image = "check",
                })
				Lock = true
		    end
	    end
    end
	wait(1)
until Lock
--初始化冻结温度功能