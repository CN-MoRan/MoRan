-- Ro市人生基础脚本（建议放在ServerScriptService）
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 创建远程事件（用于客户端与服务器交互）
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "RoCityEvents"
RemoteEvents.Parent = ReplicatedStorage

local EarnMoneyEvent = Instance.new("RemoteEvent")
EarnMoneyEvent.Name = "EarnMoney"
EarnMoneyEvent.Parent = RemoteEvents

local CompleteTaskEvent = Instance.new("RemoteEvent")
CompleteTaskEvent.Name = "CompleteTask"
CompleteTaskEvent.Parent = RemoteEvents

-- 玩家数据模板
local function getDefaultData()
    return {
        money = 0, -- 金钱
        level = 1, -- 等级
        exp = 0, -- 经验
        job = "无业", -- 职业
        tasks = { -- 任务列表
            {id = 1, name = "首次工作", description = "完成一次工作", completed = false, reward = 100},
            {id = 2, name = "积累财富", description = "拥有500金钱", completed = false, reward = 200}
        }
    }
end

-- 玩家加入时初始化数据
Players.PlayerAdded:Connect(function(player)
    -- 创建数据存储（实际项目建议用DataStoreService持久化）
    local playerData = Instance.new("Folder")
    playerData.Name = "PlayerData"
    playerData.Parent = player
    
    local data = getDefaultData()
    
    -- 保存数据到实例（便于读取）
    for key, value in pairs(data) do
        local valObj = Instance.new("StringValue") -- 用StringValue存储复杂数据，实际可细分类型
        valObj.Name = key
        valObj.Value = typeof(value) == "table" and game:GetService("HttpService"):JSONEncode(value) or tostring(value)
        valObj.Parent = playerData
    end
    
    -- 输出欢迎信息
    print(player.Name .. "进入Ro市，初始职业：" .. data.job)
end)

-- 赚钱逻辑（例如工作、摆摊等）
EarnMoneyEvent.OnServerEvent:Connect(function(player, amount, source)
    local dataFolder = player:FindFirstChild("PlayerData")
    if not dataFolder then return end
    
    local moneyObj = dataFolder:FindFirstChild("money")
    local expObj = dataFolder:FindFirstChild("exp")
    if not moneyObj or not expObj then return end
    
    -- 增加金钱和经验（根据来源不同可调整数值）
    local newMoney = tonumber(moneyObj.Value) + amount
    moneyObj.Value = tostring(newMoney)
    
    local newExp = tonumber(expObj.Value) + amount * 0.1 -- 经验为金钱的10%
    expObj.Value = tostring(newExp)
    
    -- 检查等级提升
    local levelObj = dataFolder:FindFirstChild("level")
    local level = tonumber(levelObj.Value)
    if newExp >= level * 100 then -- 每级需要100*等级的经验
        levelObj.Value = tostring(level + 1)
        print(player.Name .. "升级到" .. level + 1 .. "级！")
    end
    
    print(player.Name .. "通过" .. source .. "获得" .. amount .. "金钱，当前总金额：" .. newMoney)
end)

-- 任务完成逻辑
CompleteTaskEvent.OnServerEvent:Connect(function(player, taskId)
    local dataFolder = player:FindFirstChild("PlayerData")
    if not dataFolder then return end
    
    local tasksObj = dataFolder:FindFirstChild("tasks")
    if not tasksObj then return end
    
    local tasks = game:GetService("HttpService"):JSONDecode(tasksObj.Value)
    local moneyObj = dataFolder:FindFirstChild("money")
    if not moneyObj then return end
    
    -- 检查任务是否完成
    for i, task in ipairs(tasks) do
        if task.id == taskId and not task.completed then
            -- 标记任务完成并发放奖励
            task.completed = true
            local newMoney = tonumber(moneyObj.Value) + task.reward
            moneyObj.Value = tostring(newMoney)
            tasksObj.Value = game:GetService("HttpService"):JSONEncode(tasks)
            print(player.Name .. "完成任务【" .. task.name .. "】，获得奖励：" .. task.reward)
            break
        end
    end
end)

-- 玩家离开时清理（实际项目需保存数据到DataStore）
Players.PlayerRemoving:Connect(function(player)
    print(player.Name .. "离开Ro市，当前金钱：" .. player.PlayerData.money.Value)
end)
