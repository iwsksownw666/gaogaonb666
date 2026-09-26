local genv = getgenv()
local fenv = getfenv()

game:IsLoaded()

local _ = _G.SolsRngCancel

_G.SolsRngCancel = function(...) end

local _call8 = game:GetService('PathfindingService')

game:GetService('VirtualInputManager')
game:GetService('VirtualUser')
game:GetService('GuiService')

local _call18 = game:GetService('ReplicatedStorage')
local _call20 = game:GetService('CoreGui')
local _call22 = game:GetService('HttpService')

game:GetService('TeleportService')

local _LocalPlayer25 = game:GetService('Players').LocalPlayer

_LocalPlayer25:WaitForChild('PlayerGui', 30)
_call18:WaitForChild('ByteNetReliable')
task.spawn(function(...)
    _call20:WaitForChild('RobloxPromptGui', 10):WaitForChild('promptOverlay', 10).ChildAdded:Connect(function(...)
        local _40_vararg1 = ...
        local _ = _40_vararg1.Name
    end)
end)

local _ = fenv.syn

queue_on_teleport('repeat task.wait() until game:IsLoaded()')

local _call45 = _call22:JSONEncode({
    autoFarmEnabled = false,
    farmWatermelons = true,
    autoFishing = true,
})

writefile('sols_farm_config.json', _call45)

for _48, _48_2 in pairs(getconnections(_LocalPlayer25.Idled))do
    _48_2:Disable()
    _48_2:Disconnect()
end

_LocalPlayer25.Idled:Connect(function(...) end)
task.spawn(function(...) end)

for _64, _64_2 in ipairs(_call18:WaitForChild('Packets', 8):GetChildren())do
    _64_2:IsA('ModuleScript')
    require(_64_2)
end

local _req70 = require(_call18.Packets.Fishing)
local _ = genv.AutoFishState

genv.AutoFishState = {
    inventory = {},
    sellAcknowledged = false,
    fishingBegan = false,
}

local _ = genv.AutoFishState
local _ = genv.AutoFishHookedV6

genv.AutoFishHookedV6 = true

_req70.addFish.listen(function(...)
    local _77_vararg1 = ...
    local _ = _77_vararg1.uid
    local _ = _77_vararg1.id
end)
_req70.removeFish.listen(function(...) end)
_req70.sellAllFish.listen(function(...)
    _req70.sellAllFishConfirm.send(true)
end)
_req70.sellFish.listen(function(...)
    _req70.sellConfirm.send(true)
end)
_req70.sellAllFishConfirm.listen(function(...) end)
_req70.beginFishing.listen(function(...) end)
_req70.playGame.listen(function(...)
    local _109_vararg1 = ...
    local _ = _109_vararg1.endTimestamp
end)
Vector3.new(100.5, 107.5, -296.75)
task.spawn(function(...) end)

local _ = Enum.RaycastFilterType.Exclude
local _Exclude119 = Enum.RaycastFilterType.Exclude

Vector3.new(541, 134.000015, -204)
Vector3.new(20, 35, 5.4)
CFrame.new(278.136505, 106.000015, 9566.54785, 0.342042685, 0, -0.939684391, 0, 1, 0, 0.939684391, 0, 0.342042685)
Vector3.new(20, 60, 6.6)
CFrame.new(255.78595, 91.3500214, 9547.50586, 0.939700544, 0, -0.341998369, 0, 1, 0, 0.341998369, 0, 0.939700544)
Vector3.new(13.450897216796875, 5.594482421875, 11.373827934265137)
CFrame.new(237.393326, 94.7617188, 9544.90527, -1, 8.742277660000001e-8, 0, 8.2393431e-10, 0.00942470971, -0.999955595, -8.7418897e-8, -0.999955595, -0.00942470971)
Vector3.new(3, 16, 16)
CFrame.new(320.899963, 102.000038, 9600.07617, -1, 0, 0, 0, 1, 0, 0, 0, -1)
Vector3.new(3, 16, 16)
CFrame.new(321.400024, 100.000031, 9617.7002, -1, 0, 0, 0, 0, 1, 0, 1, 0)
Vector3.new(14, 20, 16)
CFrame.new(345, 97.5000153, 9669.00098, -1, 8.742277660000001e-8, 0, 8.742277660000001e-8, 1, 8.742277660000001e-8, 7.642741859999999e-15, 8.742277660000001e-8, -1)
Vector3.new(25, 16.5, 11)
CFrame.new(240.210144, 91.9284058, 9752.95996, -1, 0, 0, 0, 1, 0, 0, 0, -1)
Vector3.new(27, 15, 12)
CFrame.new(321.999969, 100.750015, 9764.50098, 0, 0, -1, 0, 1, 0, 1, 0, 0)
Vector3.new(12, 15, 15)
CFrame.new(308.5, 100.750015, 9772.00098, 0, 0, -1, 0, 1, 0, 1, 0, 0)
Vector3.new(35, 60, 25)
CFrame.new(485.5, 125.500015, 9596.50098, 1, 0, 0, 0, 1, 0, 0, 0, 1)
Vector3.new(6, 40, 9)
CFrame.new(353, 117.500015, 9506.50098, -1, 0, 0, 0, 1, 0, 0, 0, -1)

local _call167 = Instance.new('ScreenGui')

_call167.Name = 'SolsRngAutomationGui'
_call167.ResetOnSpawn = false

local _callgethui168 = gethui()

_callgethui168:FindFirstChild('SolsRngAutomationGui')
_callgethui168:FindFirstChild('SolsRngAutomationGui'):Destroy()

_call167.Parent = _callgethui168

local _call176 = Instance.new('Frame')

_call176.Name = 'MainFrame'
_call176.Size = UDim2.new(0, 280, 0, 275)
_call176.Position = UDim2.new(0.5, -140, 0.35, 0)
_call176.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
_call176.BorderSizePixel = 0
_call176.ClipsDescendants = true
_call176.Parent = _call167

local _call184 = Instance.new('UICorner')

_call184.CornerRadius = UDim.new(0, 10)
_call184.Parent = _call176

local _call188 = Instance.new('UIStroke')

_call188.Color = Color3.fromRGB(48, 52, 68)
_call188.Thickness = 1.2
_call188.Parent = _call176

local _call192 = Instance.new('Frame')

_call192.Name = 'TitleBar'
_call192.Size = UDim2.new(1, 0, 0, 38)
_call192.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
_call192.BorderSizePixel = 0
_call192.Parent = _call176

local _call198 = Instance.new('UICorner')

_call198.CornerRadius = UDim.new(0, 10)
_call198.Parent = _call192

local _call202 = Instance.new('TextLabel')

_call202.Size = UDim2.new(1, -75, 1, 0)
_call202.Position = UDim2.new(0, 12, 0, 0)
_call202.BackgroundTransparency = 1
_call202.Text = 'SOL\'S RNG <font color="#8C91A5">| MULTI-FARMER</font>'
_call202.TextColor3 = Color3.fromRGB(242, 244, 248)
_call202.TextSize = 13
_call202.RichText = true
_call202.Font = Enum.Font.GothamBold
_call202.TextXAlignment = Enum.TextXAlignment.Left
_call202.Parent = _call192

local _call214 = Instance.new('Frame')

_call214.Size = UDim2.new(0, 32, 0, 18)
_call214.Position = UDim2.new(1, -64, 0.5, -9)
_call214.BackgroundColor3 = Color3.fromRGB(36, 40, 54)
_call214.BorderSizePixel = 0
_call214.Parent = _call192

local _call222 = Instance.new('UICorner')

_call222.CornerRadius = UDim.new(0, 4)
_call222.Parent = _call214

local _call226 = Instance.new('TextLabel')

_call226.Size = UDim2.new(1, 0, 1, 0)
_call226.BackgroundTransparency = 1
_call226.Text = 'v3.3'
_call226.TextColor3 = Color3.fromRGB(150, 155, 175)
_call226.TextSize = 10
_call226.Font = Enum.Font.GothamBold
_call226.Parent = _call214

local _call234 = Instance.new('TextButton')

_call234.Name = 'MinimizeButton'
_call234.Size = UDim2.new(0, 24, 0, 24)
_call234.Position = UDim2.new(1, -28, 0.5, -12)
_call234.BackgroundTransparency = 1
_call234.Text = '-'
_call234.TextColor3 = Color3.fromRGB(170, 175, 195)
_call234.TextSize = 16
_call234.Font = Enum.Font.GothamBold
_call234.Parent = _call192

local _call244 = Instance.new('Frame')

_call244.Name = 'ContentFrame'
_call244.Size = UDim2.new(1, 0, 1, -38)
_call244.Position = UDim2.new(0, 0, 0, 38)
_call244.BackgroundTransparency = 1
_call244.Parent = _call176

local _call250 = Instance.new('Frame')

_call250.Name = 'StatusCard'
_call250.Size = UDim2.new(1, -24, 0, 46)
_call250.Position = UDim2.new(0, 12, 0, 10)
_call250.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
_call250.BorderSizePixel = 0
_call250.Parent = _call244

local _call258 = Instance.new('UICorner')

_call258.CornerRadius = UDim.new(0, 8)
_call258.Parent = _call250

local _call262 = Instance.new('UIStroke')

_call262.Color = Color3.fromRGB(38, 42, 56)
_call262.Thickness = 1
_call262.Parent = _call250

local _call266 = Instance.new('TextLabel')

_call266.Size = UDim2.new(1, -20, 0, 14)
_call266.Position = UDim2.new(0, 10, 0, 6)
_call266.BackgroundTransparency = 1
_call266.Text = 'SYSTEM STATUS'
_call266.TextColor3 = Color3.fromRGB(120, 126, 146)
_call266.TextSize = 9
_call266.Font = Enum.Font.GothamBold
_call266.TextXAlignment = Enum.TextXAlignment.Left
_call266.Parent = _call250

local _call278 = Instance.new('Frame')

_call278.Size = UDim2.new(0, 6, 0, 6)
_call278.Position = UDim2.new(0, 10, 0, 26)
_call278.BackgroundColor3 = Color3.fromRGB(140, 145, 160)
_call278.BorderSizePixel = 0
_call278.Parent = _call250

local _call286 = Instance.new('UICorner')

_call286.CornerRadius = UDim.new(1, 0)
_call286.Parent = _call278

local _call290 = Instance.new('TextLabel')

_call290.Name = 'StatusValue'
_call290.Size = UDim2.new(1, -30, 0, 16)
_call290.Position = UDim2.new(0, 22, 0, 21)
_call290.BackgroundTransparency = 1
_call290.Text = 'Idle'
_call290.TextColor3 = Color3.fromRGB(210, 214, 224)
_call290.TextSize = 11
_call290.Font = Enum.Font.GothamMedium
_call290.TextXAlignment = Enum.TextXAlignment.Left
_call290.Parent = _call250

local _call302 = Instance.new('Frame')

_call302.Name = 'CounterCard'
_call302.Size = UDim2.new(1, -24, 0, 46)
_call302.Position = UDim2.new(0, 12, 0, 62)
_call302.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
_call302.BorderSizePixel = 0
_call302.Parent = _call244

local _call310 = Instance.new('UICorner')

_call310.CornerRadius = UDim.new(0, 8)
_call310.Parent = _call302

local _call314 = Instance.new('UIStroke')

_call314.Color = Color3.fromRGB(38, 42, 56)
_call314.Thickness = 1
_call314.Parent = _call302

local _call318 = Instance.new('TextLabel')

_call318.Size = UDim2.new(1, -20, 0, 14)
_call318.Position = UDim2.new(0, 10, 0, 6)
_call318.BackgroundTransparency = 1
_call318.Text = 'WATERMELONS COLLECTED'
_call318.TextColor3 = Color3.fromRGB(120, 126, 146)
_call318.TextSize = 9
_call318.Font = Enum.Font.GothamBold
_call318.TextXAlignment = Enum.TextXAlignment.Left
_call318.Parent = _call302

local _call330 = Instance.new('TextLabel')

_call330.Name = 'CounterValue'
_call330.Size = UDim2.new(1, -20, 0, 20)
_call330.Position = UDim2.new(0, 10, 0, 20)
_call330.BackgroundTransparency = 1
_call330.Text = '0'
_call330.TextColor3 = Color3.fromRGB(52, 211, 153)
_call330.TextSize = 15
_call330.Font = Enum.Font.GothamBold
_call330.TextXAlignment = Enum.TextXAlignment.Left
_call330.Parent = _call302

local _call342 = Instance.new('Frame')

_call342.Name = 'TogglesRow'
_call342.Size = UDim2.new(1, -24, 0, 32)
_call342.Position = UDim2.new(0, 12, 0, 114)
_call342.BackgroundTransparency = 1
_call342.Parent = _call244

local _call348 = Instance.new('TextButton')

_call348.Name = 'MelonToggle'
_call348.Size = UDim2.new(0.5, -4, 1, 0)
_call348.Position = UDim2.new(0, 0, 0, 0)
_call348.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
_call348.BorderSizePixel = 0
_call348.Text = 'Melons: ON'
_call348.TextColor3 = Color3.fromRGB(52, 211, 153)
_call348.TextSize = 12
_call348.Font = Enum.Font.GothamMedium
_call348.AutoButtonColor = false
_call348.Parent = _call342

local _call360 = Instance.new('UICorner')

_call360.CornerRadius = UDim.new(0, 6)
_call360.Parent = _call348

local _call364 = Instance.new('UIStroke')

_call364.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_call364.Color = Color3.fromRGB(16, 185, 129)
_call364.Thickness = 1
_call364.Parent = _call348

local _call370 = Instance.new('TextButton')

_call370.Name = 'FishToggle'
_call370.Size = UDim2.new(0.5, -4, 1, 0)
_call370.Position = UDim2.new(0.5, 4, 0, 0)
_call370.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
_call370.BorderSizePixel = 0
_call370.Text = 'Fishing: ON'
_call370.TextColor3 = Color3.fromRGB(56, 189, 248)
_call370.TextSize = 12
_call370.Font = Enum.Font.GothamMedium
_call370.AutoButtonColor = false
_call370.Parent = _call342

local _call382 = Instance.new('UICorner')

_call382.CornerRadius = UDim.new(0, 6)
_call382.Parent = _call370

local _call386 = Instance.new('UIStroke')

_call386.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_call386.Color = Color3.fromRGB(56, 189, 248)
_call386.Thickness = 1
_call386.Parent = _call370

local _call392 = Instance.new('TextButton')

_call392.Name = 'ActionButton'
_call392.Size = UDim2.new(1, -24, 0, 38)
_call392.Position = UDim2.new(0, 12, 0, 152)
_call392.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
_call392.BorderSizePixel = 0
_call392.Text = 'START MULTI-FARM'
_call392.TextColor3 = Color3.fromRGB(255, 255, 255)
_call392.TextSize = 12
_call392.Font = Enum.Font.GothamBold
_call392.AutoButtonColor = false
_call392.Parent = _call244

local _call404 = Instance.new('UICorner')

_call404.CornerRadius = UDim.new(0, 8)
_call404.Parent = _call392

local _call408 = Instance.new('TextLabel')

_call408.Size = UDim2.new(1, -24, 0, 16)
_call408.Position = UDim2.new(0, 12, 0, 196)
_call408.BackgroundTransparency = 1
_call408.Text = 'Auto-Save Config | Auto-Reconnect | Anti-AFK'
_call408.TextColor3 = Color3.fromRGB(86, 92, 112)
_call408.TextSize = 10
_call408.Font = Enum.Font.Gotham
_call408.Parent = _call244

_call234.MouseButton1Click:Connect(function(...)
    _call244.Visible = false
    _call176.Size = UDim2.new(0, 280, 0, 38)
    _call234.Text = '+'
end)
_call192.InputBegan:Connect(function(...)
    local _426_vararg1 = ...
    local _ = _426_vararg1.UserInputType == Enum.UserInputType.MouseButton1
    local _ = _426_vararg1.UserInputType == Enum.UserInputType.Touch
end)
_call192.InputChanged:Connect(function(...)
    local _438_vararg1 = ...
    local _ = _438_vararg1.UserInputType == Enum.UserInputType.MouseMovement
    local _ = _438_vararg1.UserInputType == Enum.UserInputType.Touch
end)
game:GetService('UserInputService').InputChanged:Connect(function(...) end)
_call348.MouseButton1Click:Connect(function(...)
    local _call456 = _call22:JSONEncode({
        autoFarmEnabled = false,
        farmWatermelons = false,
        autoFishing = true,
    })

    writefile('sols_farm_config.json', _call456)

    _call348.Text = 'Melons: OFF'
    _call348.TextColor3 = Color3.fromRGB(120, 126, 146)
    _call364.Color = Color3.fromRGB(38, 42, 56)
end)
_call370.MouseButton1Click:Connect(function(...)
    _call370.Text = 'Fishing: OFF'
    _call370.TextColor3 = Color3.fromRGB(120, 126, 146)
    _call386.Color = Color3.fromRGB(38, 42, 56)
end)

local _call471 = RaycastParams.new()

_call471.FilterType = _Exclude119

local _call473 = RaycastParams.new()

_call473.FilterType = _Exclude119

_call8:CreatePath({
    AgentHeight = 5,
    AgentCanJump = true,
    WaypointSpacing = 3.5,
    AgentCanClimb = true,
    AgentRadius = 2,
})
_call392.MouseButton1Click:Connect(function(...) end)
