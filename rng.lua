--make by skiddd
--claude code
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Environment = getgenv()

if Environment.BonesWatermelon and Environment.BonesWatermelon.Stop then
    Environment.BonesWatermelon.Stop()
end

local Config = {
    Enabled = true,
    WalkSpeed = 16,
    MoveTimeout = 45,
    DialogTimeout = 12,
    StartTimeout = 15,
    RoundEndTimeout = 20,
    RetryDelay = 2.5,
    IdleWait = 0.25,

    StuckDistance = 0.6,
    StuckWindow = 0.8,
    WaypointSpacing = 4,
    DirectMoveRange = 14,
    JumpCooldown = 0.9,
    JumpRetryWindow = 1.15,
    JumpTriggerDistance = 5.5,
    ObstacleCheckDistance = 4.5,
    ObstacleJumpCooldown = 1.25,
    ApproachSampleRadius = 6,
    ApproachClearanceHeight = 5.5,
    ApproachSamples = 8,
    HeightJumpThreshold = 1.6,
    MaxHeightJump = 10,

    ShowPath = false,
    AssistRamps = false,

    EnterCooldown = 4,
    EnterBackoffBase = 8,
    EnterBackoffMax = 60,
    WatchdogTimeout = 150,
    VoidY = -80,
    VoidGrace = 6,
}

local State = {
    Stopped = false,
    Entering = false,
    Collecting = false,
    Sessions = 0,
    Collected = 0,
    RoundActive = false,
    RoundEnds = 0,
    NextEnterAt = 0,
    LastError = nil,
    ControlsCaptured = false,
    LoopTicks = 0,
    Phase = "idle",
    PhaseSince = os.clock(),
    EnterFails = 0,
}

Environment.BonesWatermelon = State
State.Config = Config

local function log(...)
    print("[bones watermelon]", ...)
end

local runLoop
local LoopRunning = false

local function setPhase(name)
    if State.Phase ~= name then
        State.Phase = name
        State.PhaseSince = os.clock()
    end
end

local function resetSticky(reason)
    State.Entering = false
    State.Collecting = false
    State.RoundActive = false
    State.NextEnterAt = 0
    setPhase("idle")
    if reason then
        log("state reset:", reason)
    end
end

local Controls = nil

local function buildAntiStuckParts()
    for _, name in ipairs({
        "SlopeSoNoStuckyPoo", "SlopeSoNoStuckyPoo2", "SlopeSoNoStuckyPoo3",
        "Anti-Stuck1", "Anti-Stuck2", "Anti-Stuck3", "Anti-Stuck4", "Anti-Stuck5",
    }) do
        local old = Workspace:FindFirstChild(name)
        if old then old:Destroy() end
    end

    local Slope1 = Instance.new("Part", Workspace)
    Slope1.Name = "SlopeSoNoStuckyPoo"
    Slope1.Size = Vector3.new(10, 15, 15)
    Slope1.Position = Vector3.new(448.75, 102.75, -406)
    Slope1.Rotation = Vector3.new(0, 90, 0)
    Slope1.Shape = Enum.PartType.Wedge
    Slope1.Anchored = true
    Slope1.Transparency = 0.5

    local Slope2 = Instance.new("Part", Workspace)
    Slope2.Name = "SlopeSoNoStuckyPoo2"
    Slope2.Size = Vector3.new(33, 20, 30)
    Slope2.Position = Vector3.new(-63, 85, -182)
    Slope2.Rotation = Vector3.new(0, 0, 0)
    Slope2.Shape = Enum.PartType.Wedge
    Slope2.Anchored = true
    Slope2.Transparency = 0.5

    local Slope3 = Instance.new("Part", Workspace)
    Slope3.Name = "SlopeSoNoStuckyPoo3"
    Slope3.Size = Vector3.new(20, 20, 19)
    Slope3.Position = Vector3.new(478.5477600097656, 102.00000762939453, -399.6143493652344)
    Slope3.Rotation = Vector3.new(0, 90, 0)
    Slope3.Shape = Enum.PartType.Wedge
    Slope3.Anchored = true
    Slope3.Transparency = 0.5

    local AntiSign1 = Instance.new("Part", Workspace)
    AntiSign1.Name = "Anti-Stuck1"
    AntiSign1.Anchored = true
    AntiSign1.Size = Vector3.new(2, 34, 21)
    AntiSign1.Position = Vector3.new(321, 100, -390)
    AntiSign1.Rotation = Vector3.new(-90, 0, 180)
    AntiSign1.Transparency = 0.5

    local AntiSign2 = Instance.new("Part", Workspace)
    AntiSign2.Name = "Anti-Stuck2"
    AntiSign2.Anchored = true
    AntiSign2.Size = Vector3.new(25, 40, 5)
    AntiSign2.Position = Vector3.new(278.137, 106, -433.454)
    AntiSign2.Rotation = Vector3.new(0, -69.999, 0)
    AntiSign2.Transparency = 0.5

    local AntiSign3 = Instance.new("Part", Workspace)
    AntiSign3.Name = "Anti-Stuck3"
    AntiSign3.Anchored = true
    AntiSign3.Size = Vector3.new(25, 40, 5)
    AntiSign3.Position = Vector3.new(255.786, 106, -452.495)
    AntiSign3.Rotation = Vector3.new(0, -19.999, 0)
    AntiSign3.Transparency = 0.5

    local AntiSign4 = Instance.new("Part", Workspace)
    AntiSign4.Name = "Anti-Stuck4"
    AntiSign4.Anchored = true
    AntiSign4.Size = Vector3.new(40, 50, 8)
    AntiSign4.Position = Vector3.new(113.875, 100, -444)
    AntiSign4.Rotation = Vector3.new(0, -90, 0)
    AntiSign4.Transparency = 0.5

    local AntiSign5 = Instance.new("Part", Workspace)
    AntiSign5.Name = "Anti-Stuck5"
    AntiSign5.Anchored = true
    AntiSign5.Size = Vector3.new(80, 2, 8)
    AntiSign5.Position = Vector3.new(400, 91, -316.5)
    AntiSign5.Rotation = Vector3.new(0, 0, 0)
    AntiSign5.Transparency = 0.5

    log("anti-stuck parts created")
end

local function clearPathVisual() end
local function clearAssistRamps() end
local function renderPathVisual(...) end
local function buildAssistRamps(...) end

local function createAssistRamp(...)
    return nil
end

local function getAssistRampFolder()
    return nil
end

local function captureControls(enabled)
    if not Controls then
        pcall(function()
            local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
            if playerModule then
                Controls = require(playerModule):GetControls()
            end
        end)
    end

    if Controls then
        pcall(function()
            if enabled then
                Controls:Disable()
                State.ControlsCaptured = true
            else
                Controls:Enable()
                State.ControlsCaptured = false
            end
        end)
    end
end

function State.Stop()
    State.Stopped = true
    Config.Enabled = false
    captureControls(false)
    pcall(function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid:Move(Vector3.zero)
        end
    end)
    setPhase("stopped")
    log("stopped")
end

function State.SetEnabled(enabled)
    Config.Enabled = enabled == true

    if Config.Enabled then
        State.Stopped = false
        captureControls(true)
        setPhase("idle")
        runLoop()
        log("enabled")
    else
        captureControls(false)
        pcall(function()
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid:Move(Vector3.zero)
            end
        end)
        setPhase("idle")
        log("disabled")
    end

    return Config.Enabled
end

function State.Toggle()
    return State.SetEnabled(not Config.Enabled)
end

function State.Stats()
    return string.format(
        "phase=%s sessions=%d collected=%d rounds=%d error=%s enabled=%s",
        State.Phase,
        State.Sessions,
        State.Collected,
        State.RoundEnds,
        tostring(State.LastError),
        tostring(Config.Enabled)
    )
end

local function getCharacter(timeout)
    local deadline = os.clock() + (timeout or 10)

    while true do
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if humanoid and root and humanoid.Health > 0 then
            return character, humanoid, root
        end

        if State.Stopped or os.clock() >= deadline then
            break
        end

        task.wait(0.2)
    end

    return nil, nil, nil
end

local function applySpeed(humanoid)
    if Config.WalkSpeed and humanoid and humanoid.WalkSpeed ~= Config.WalkSpeed then
        humanoid.WalkSpeed = Config.WalkSpeed
    end
end

local function getCurrentRoot()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart") or nil
end

local function getPromptPart(prompt)
    local current = prompt and prompt.Parent

    while current and current ~= Workspace do
        if current:IsA("BasePart") then
            return current
        end
        current = current.Parent
    end

    return nil
end

local ScanCache = { prompt = nil, at = 0, fullAt = 0 }

local function collectPromptCandidates(out)
    local container = Workspace:FindFirstChild("Watermelon")

    if container then
        for _, descendant in container:GetDescendants() do
            if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                out[#out + 1] = descendant
                if #out >= 6 then
                    return
                end
            end
        end
        return
    end

    local now = os.clock()
    if now - ScanCache.fullAt < 1 then
        return
    end
    ScanCache.fullAt = now

    for _, descendant in Workspace:GetDescendants() do
        if descendant:IsA("ProximityPrompt") and descendant.Enabled then
            local name = string.lower(descendant.Name)
            local object = string.lower(descendant.ObjectText or "")
            local action = string.lower(descendant.ActionText or "")

            if string.find(name, "melon", 1, true)
                or string.find(object, "melon", 1, true)
                or string.find(object, "西瓜", 1, true)
                or string.find(action, "smash", 1, true) then
                out[#out + 1] = descendant
                if #out >= 6 then
                    return
                end
            end
        end
    end
end

local function findWatermelonPrompt()
    local now = os.clock()
    local cached = ScanCache.prompt

    if cached
        and cached.Parent
        and cached.Enabled
        and now - ScanCache.at < 0.25 then
        return cached
    end

    local candidates = {}
    collectPromptCandidates(candidates)

    local root = getCurrentRoot()
    local best, bestDistance = nil, math.huge

    for _, prompt in candidates do
        if not root then
            best = prompt
            break
        end

        local part = getPromptPart(prompt)
        if part then
            local distance = (root.Position - part.Position).Magnitude
            if distance < bestDistance then
                best, bestDistance = prompt, distance
            end
        elseif not best then
            best = prompt
        end
    end

    ScanCache.prompt = best
    ScanCache.at = now
    return best
end

local function moveNear(getTargetPosition, stopDistance, timeout, options)
    options = options or {}
    local usePathfinding = options.UsePathfinding ~= false
    local allowJumps = options.AllowJumps ~= false
    local sampleApproaches = options.SampleApproaches == true
    local requireLineOfSight = options.RequireLineOfSight == true
    local ignoredTarget = options.IgnoreInstance

    local character, humanoid, root = getCharacter(10)
    if not character or not humanoid or not root then
        return false, "character unavailable"
    end

    local startedAt = os.clock()
    local waypoints = {}
    local index = 1
    local pathGoal = nil
    local nextPathAt = 0
    local lastGoal = nil
    local lastMoveAt = 0
    local lastJumpAt = 0
    local lastObstacleJumpAt = 0
    local jumpAttemptIndex = 0
    local jumpAttemptAt = 0
    local lastPos = root.Position
    local lastProgressAt = startedAt
    local fallbackGoal = nil
    local approachAttempt = 0

    local function horiz(a, b)
        local dx = a.X - b.X
        local dz = a.Z - b.Z
        return math.sqrt(dx * dx + dz * dz)
    end

    local function raycastFilter()
        local filter = { character }
        if ignoredTarget then
            filter[#filter + 1] = ignoredTarget
        end
        return filter
    end

    local function hasLineOfSight(target)
        if not requireLineOfSight then
            return true
        end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = raycastFilter()
        local origin = root.Position + Vector3.new(0, 1.25, 0)
        return Workspace:Raycast(origin, target - origin, params) == nil
    end

    local function projectToClearFloor(sample, target)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = raycastFilter()

        local origin = Vector3.new(sample.X, target.Y + 16, sample.Z)
        local floorHit = Workspace:Raycast(origin, Vector3.new(0, -64, 0), params)
        if not floorHit or floorHit.Normal.Y < 0.45 then
            return nil
        end

        local clearanceOrigin = floorHit.Position + Vector3.new(0, 0.25, 0)
        local ceiling = Workspace:Raycast(
            clearanceOrigin,
            Vector3.new(0, Config.ApproachClearanceHeight, 0),
            params
        )
        if ceiling then
            return nil
        end

        local expectedRoot = floorHit.Position + Vector3.new(0, 4, 0)
        if (expectedRoot - target).Magnitude > stopDistance + 0.75 then
            return nil
        end

        return floorHit.Position
    end

    local function getApproachGoals(target)
        if not sampleApproaches then
            return { target }
        end

        local goals = {}
        for i = 1, Config.ApproachSamples do
            local angle = ((i - 1) / Config.ApproachSamples) * math.pi * 2
            local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * Config.ApproachSampleRadius
            local projected = projectToClearFloor(target + offset, target)
            if projected then
                goals[#goals + 1] = projected
            end
        end

        local center = projectToClearFloor(target, target)
        if center then
            goals[#goals + 1] = center
        end

        if #goals == 0 then
            goals[1] = target
        end
        return goals
    end

    local function hasJumpableObstacle(goal)
        local flatDirection = Vector3.new(
            goal.X - root.Position.X,
            0,
            goal.Z - root.Position.Z
        )
        if flatDirection.Magnitude < 0.1 then
            return false
        end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = raycastFilter()

        local direction = flatDirection.Unit * Config.ObstacleCheckDistance
        local lowOrigin = root.Position - Vector3.new(0, 2.25, 0)
        local headOrigin = root.Position + Vector3.new(0, 1.75, 0)
        local lowHit = Workspace:Raycast(lowOrigin, direction, params)
        local headHit = Workspace:Raycast(headOrigin, direction, params)

        return lowHit ~= nil, lowHit, headHit
    end

    local function finish(ok, reason)
        if ok then
            pcall(function()
                humanoid:Move(Vector3.zero)
            end)
        end
        return ok, reason
    end

    local function computePath(target)
        local candidates = getApproachGoals(target)
        local validPaths = {}

        for candidateIndex, candidate in candidates do
            local path = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true,
                WaypointSpacing = Config.WaypointSpacing,
            })
            local computed = pcall(function()
                path:ComputeAsync(root.Position, candidate)
            end)

            if computed and path.Status == Enum.PathStatus.Success then
                local points = path:GetWaypoints()
                if #points > 0 then
                    local length = 0
                    local jumps = 0
                    local previous = root.Position
                    for _, waypoint in points do
                        length += (waypoint.Position - previous).Magnitude
                        previous = waypoint.Position
                        if waypoint.Action == Enum.PathWaypointAction.Jump then
                            jumps += 1
                        end
                    end
                    validPaths[#validPaths + 1] = {
                        goal = candidate,
                        points = points,
                        score = length + jumps * 3 + candidateIndex * 0.01,
                    }
                end
            end
        end

        table.sort(validPaths, function(a, b)
            return a.score < b.score
        end)

        if #validPaths > 0 then
            local selectedIndex = (approachAttempt % #validPaths) + 1
            local selected = validPaths[selectedIndex]
            waypoints = selected.points
            fallbackGoal = selected.goal
            index = 1
            pathGoal = target
            jumpAttemptIndex = 0
            jumpAttemptAt = 0
            return true
        end

        waypoints = {}
        index = 1
        nextPathAt = os.clock() + 1
        fallbackGoal = candidates[(approachAttempt % #candidates) + 1]
        return false
    end

    while not State.Stopped and os.clock() - startedAt < timeout do
        local target = getTargetPosition()
        if not target then
            return finish(false, "target disappeared")
        end
        if not root.Parent or humanoid.Health <= 0 then
            local newCharacter, newHumanoid, newRoot = getCharacter(10)
            if not newCharacter or not newHumanoid or not newRoot then
                return finish(false, "character respawn failed")
            end

            character, humanoid, root = newCharacter, newHumanoid, newRoot
            waypoints = {}
            index = 1
            nextPathAt = 0
            lastGoal = nil
            lastPos = root.Position
            lastProgressAt = os.clock()
        end

        if root.Position.Y < Config.VoidY then
            pcall(function() humanoid:Move(Vector3.zero) end)
            return finish(false, "fell out of the map")
        end

        local now = os.clock()
        local flat = horiz(root.Position, target)
        local deltaY = target.Y - root.Position.Y

        if (root.Position - target).Magnitude <= stopDistance and hasLineOfSight(target) then
            return finish(true)
        end

        local goal
        local activeWaypoint

        if not sampleApproaches and flat <= Config.DirectMoveRange and math.abs(deltaY) <= 2.5 then
            waypoints = {}
            index = 1
            goal = target
        else
            if usePathfinding then
                local stale = #waypoints > 0 and pathGoal and (pathGoal - target).Magnitude > 8
                local exhausted = index > #waypoints

                if #waypoints == 0 or stale or exhausted then
                    if now >= nextPathAt then
                        if exhausted and #waypoints > 0 then
                            approachAttempt += 1
                        end
                        computePath(target)
                        nextPathAt = os.clock() + 0.5
                    end
                end
            end

            activeWaypoint = (index <= #waypoints) and waypoints[index] or nil

            if activeWaypoint and horiz(root.Position, activeWaypoint.Position) <= Config.WaypointSpacing * 0.9 then
                if activeWaypoint.Action ~= Enum.PathWaypointAction.Jump then
                    index += 1
                    jumpAttemptIndex = 0
                    jumpAttemptAt = 0
                elseif jumpAttemptIndex == index and humanoid.FloorMaterial == Enum.Material.Air then
                    index += 1
                    jumpAttemptIndex = 0
                    jumpAttemptAt = 0
                elseif jumpAttemptIndex == index
                    and jumpAttemptAt > 0
                    and now - jumpAttemptAt >= Config.JumpRetryWindow then
                        lastJumpAt = 0
                        jumpAttemptAt = 0
                end

                activeWaypoint = (index <= #waypoints) and waypoints[index] or nil
            end

            goal = activeWaypoint and activeWaypoint.Position or fallbackGoal or target
        end

        local moved = (root.Position - lastPos).Magnitude

        if moved >= Config.StuckDistance then
            lastPos = root.Position
            lastProgressAt = now
        elseif now - lastProgressAt >= Config.StuckWindow then
            lastProgressAt = now

            if usePathfinding then
                approachAttempt += 1
                waypoints = {}
                index = 1
                nextPathAt = 0
                jumpAttemptIndex = 0
                jumpAttemptAt = 0
                lastJumpAt = 0
            end

            lastGoal = nil
        end

        local moveGoal = goal
        local grounded = humanoid.FloorMaterial ~= Enum.Material.Air
        local wantsJump = false
        local obstacleJump = false

        if allowJumps and grounded then
            if activeWaypoint
                and activeWaypoint.Action == Enum.PathWaypointAction.Jump
                and horiz(root.Position, activeWaypoint.Position) <= Config.JumpTriggerDistance then
                wantsJump = true
            elseif deltaY >= Config.HeightJumpThreshold and deltaY <= Config.MaxHeightJump and flat <= 16 then
                wantsJump = true
            elseif now - lastObstacleJumpAt >= Config.ObstacleJumpCooldown then
                local jumpable, obstacleHit, headHit = hasJumpableObstacle(moveGoal)
                if jumpable then
                    wantsJump = headHit == nil
                    obstacleJump = wantsJump
                end
            end
        end

        if wantsJump and now - lastJumpAt >= Config.JumpCooldown then
            lastJumpAt = now
            if obstacleJump then
                lastObstacleJumpAt = now
            end
            if activeWaypoint and activeWaypoint.Action == Enum.PathWaypointAction.Jump then
                jumpAttemptIndex = index
                jumpAttemptAt = now
                local afterJump = waypoints[index + 1]
                if afterJump then
                    moveGoal = afterJump.Position
                end
            end
            pcall(function()
                humanoid.Jump = true
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end

        if not lastGoal or (lastGoal - moveGoal).Magnitude > 1.25 or now - lastMoveAt >= 1.5 then
            humanoid:MoveTo(moveGoal)
            lastGoal = moveGoal
            lastMoveAt = now
        end

        task.wait(0.04)
    end

    pcall(function() humanoid:Move(Vector3.zero) end)
    return finish(false, "move timeout")
end

local function waitForChild(parent, name, timeout)
    local child = parent:FindFirstChild(name)
    if child then
        return child
    end

    local deadline = os.clock() + (timeout or 10)
    repeat
        task.wait(0.2)
        child = parent:FindFirstChild(name)
    until child or os.clock() >= deadline

    return child
end

local DialogPackets = nil
local StartMinigame = nil
local DialogUI = nil

local function loadDependencies()
    local packets = waitForChild(ReplicatedStorage, "Packets", 10)
    local dialog = packets and waitForChild(packets, "Dialog", 10)

    if dialog then
        local ok, module = pcall(function()
            return require(dialog)
        end)
        if ok then
            DialogPackets = module
        end
    end

    local remote = waitForChild(ReplicatedStorage, "Remote", 10)
    local summer = remote and waitForChild(remote, "SummerEvent2026", 10)
    local minigame = summer and waitForChild(summer, "Minigame", 10)

    StartMinigame = minigame and waitForChild(minigame, "StartMinigame", 10)
end

loadDependencies()

buildAntiStuckParts()

if not DialogPackets or not StartMinigame then
    State.MissingDependencies = true
    log("dependency missing - summer event remotes not found")
end

local StoreCache = { loaded = false, value = nil }

local function getStore()
    if StoreCache.loaded then
        return StoreCache.value
    end

    local ok, store = pcall(function()
        return require(ReplicatedStorage.Modules.UI.SummerEventMinigame.Store)
    end)

    StoreCache.loaded = true
    StoreCache.value = ok and store or nil
    return StoreCache.value
end

local function getDialog()
    local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not gui then
        return nil
    end

    local main = gui:FindFirstChild("MainInterface")
    local dialog = main and main:FindFirstChild("Dialog")
    if dialog and dialog.Visible then
        return dialog
    end

    return nil
end

local function getChoices()
    local dialog = getDialog()
    local choices = dialog and dialog:FindFirstChild("Choices")
    if not choices then
        return nil
    end

    local out = {}
    for _, child in choices:GetChildren() do
        if child:IsA("TextButton") and child.Visible then
            local text = child.Text or ""
            if text ~= "" then
                out[#out + 1] = text
            end
        end
    end

    return out
end

local MinigameKeywords = { "minigame", "mini game", "mini-game", "小游戏", "遊戲" }

local function findChoice(keywords)
    local choices = getChoices()
    if not choices then
        return nil
    end

    for _, text in choices do
        if not keywords then
            return text
        end

        local lowered = string.lower(text)
        for _, keyword in keywords do
            if string.find(lowered, keyword, 1, true) then
                return text
            end
        end
    end

    return nil
end

local function cancelDialog()
    if not DialogPackets then
        return
    end

    if getDialog() then
        task.spawn(function()
            pcall(function()
                if not DialogUI then
                    DialogUI = require(ReplicatedStorage.Modules.UI.DialogUI)
                end
                if DialogUI and type(DialogUI.CancelDialog) == "function" then
                    DialogUI.CancelDialog("bones-watermelon")
                end
            end)
        end)
    end

    pcall(function()
        DialogPackets.DialogCanceled.send()
    end)
end

local function resetDialog(timeout)
    cancelDialog()

    local deadline = os.clock() + (timeout or 2)
    while not State.Stopped and getDialog() and os.clock() < deadline do
        task.wait(0.1)
    end

    if getDialog() then
        cancelDialog()
        task.wait(0.2)
    end
end

local function triggerPrompt(prompt)
    if fireproximityprompt then
        pcall(function()
            fireproximityprompt(prompt, math.max(prompt.HoldDuration, 0))
        end)
        return
    end

    pcall(function()
        prompt:InputHoldBegin()
    end)
    task.wait(math.max(prompt.HoldDuration, 0) + 0.05)
    pcall(function()
        prompt:InputHoldEnd()
    end)
end

local function findLime()
    local map = Workspace:FindFirstChild("Map")
    local lime = map and map:FindFirstChild("Lime")

    if not lime then
        for _, descendant in Workspace:GetDescendants() do
            if descendant.Name == "Lime" and descendant:IsA("Model") then
                lime = descendant
                break
            end
        end
    end

    if not lime then
        return nil, nil
    end

    return lime, lime:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local function waitForLime(timeout)
    local deadline = os.clock() + (timeout or 15)

    while not State.Stopped and os.clock() < deadline do
        local lime, prompt = findLime()
        if lime and prompt then
            local root = getCurrentRoot()
            if root then
                local part = getPromptPart(prompt)
                if not part or (root.Position - part.Position).Magnitude < 4000 then
                    return lime, prompt
                end
            else
                return lime, prompt
            end
        end
        task.wait(0.25)
    end

    return nil, nil
end

local function startMinigameDialog(prompt)
    local choice = nil
    local dialogDeadline = os.clock() + Config.DialogTimeout
    local attempts = 0

    while not State.Stopped and not choice and os.clock() < dialogDeadline do
        attempts += 1

        if attempts > 1 then
            resetDialog(0.6)
            task.wait(0.2)
        end

        triggerPrompt(prompt)

        local windowEnd = os.clock() + 3
        while not State.Stopped and not choice and os.clock() < windowEnd do
            task.wait(0.05)
            choice = findChoice(MinigameKeywords)
        end
    end

    if not choice then
        return false, "dialog never opened"
    end

    setPhase("selecting_minigame")

    if not DialogPackets then
        return false, "dialog packets unavailable"
    end

    pcall(function()
        DialogPackets.DialogResult.send("Minigame")
    end)

    setPhase("confirming_ticket")
    local secondChoiceDeadline = os.clock() + 2.5
    repeat
        task.wait(0.05)
        local visibleChoice = tostring(findChoice() or "")
        if string.find(visibleChoice, "-1", 1, true) then
            break
        end
    until State.Stopped or os.clock() >= secondChoiceDeadline

    if State.Stopped then
        return false, "stopped"
    end

    pcall(function()
        DialogPackets.DialogResult.send("Minigame")
    end)

    task.wait(0.05)
    setPhase("closing_dialog")
    cancelDialog()

    return true
end

local function enterRoutine()
    resetDialog(1.5)
    setPhase("returning_to_lime")

    local lime, prompt = waitForLime(15)
    if not lime or not prompt then
        return false, "Lime prompt unavailable"
    end

    local promptPart = getPromptPart(prompt)
    if not promptPart then
        return false, "Lime prompt part unavailable"
    end

    local stopDistance = math.max(2.5, prompt.MaxActivationDistance - 1.5)
    local moved, moveError = moveNear(function()
        return promptPart.Parent and promptPart.Position or nil
    end, stopDistance, Config.MoveTimeout)

    if not moved then
        return false, moveError or "move failed"
    end

    local _, _, root = getCharacter(3)
    if not root then
        return false, "character unavailable at Lime"
    end

    local distance = (root.Position - promptPart.Position).Magnitude
    if distance > prompt.MaxActivationDistance then
        local retryMoved = moveNear(function()
            return promptPart.Parent and promptPart.Position or nil
        end, math.max(2, stopDistance - 1), 12)

        if not retryMoved then
            return false, "not close enough to Lime"
        end
    end

    local startPayload = nil
    local startConnection = StartMinigame and StartMinigame.OnClientEvent:Connect(function(payload)
        startPayload = payload
    end)

    setPhase("opening_dialog")
    local dialogOk, dialogError = startMinigameDialog(prompt)

    setPhase("waiting_for_round")
    local startDeadline = os.clock() + Config.StartTimeout

    while not State.Stopped
        and not startPayload
        and not findWatermelonPrompt()
        and os.clock() < startDeadline do
        task.wait(0.1)
    end

    if startConnection then
        startConnection:Disconnect()
    end

    if startPayload or findWatermelonPrompt() then
        State.Sessions += 1
        State.RoundActive = true
        State.EnterFails = 0
        State.NextEnterAt = 0
        setPhase("round_started")
        resetDialog(0.5)
        log("minigame started", startPayload and startPayload.sessionKey or "watermelon detected")
        return true
    end

    resetDialog(0.5)
    setPhase("enter_failed")

    if not dialogOk then
        return false, dialogError
    end

    return false, "server did not start minigame"
end

local function enterMinigame()
    if State.Entering then
        return false, "enter already in progress"
    end

    if findWatermelonPrompt() then
        return true
    end

    if os.clock() < State.NextEnterAt then
        return false, "enter cooldown"
    end

    State.Entering = true
    local ok, result, reason = pcall(enterRoutine)
    State.Entering = false

    if not ok then
        return false, "enter error: " .. tostring(result)
    end

    return result, reason
end

local function waitForRoundEnd()
    setPhase("round_ending")

    local store = getStore()
    local deadline = os.clock() + Config.RoundEndTimeout
    local clearSince = nil

    while not State.Stopped and os.clock() < deadline do
        local prompt = findWatermelonPrompt()
        local enabled = store and store.enabled

        if not prompt and not enabled then
            clearSince = clearSince or os.clock()
            if os.clock() - clearSince >= 0.8 then
                break
            end
        else
            clearSince = nil
        end

        task.wait(0.1)
    end

    State.RoundActive = false
    State.RoundEnds += 1
    State.NextEnterAt = os.clock() + Config.EnterCooldown
    setPhase("idle")
    resetDialog(1)
end

local function collectRoutine(prompt)
    setPhase("moving_to_watermelon")

    local targetPart = getPromptPart(prompt)
    if not targetPart then
        return false, "watermelon part unavailable"
    end

    local stopDistance = math.max(3.5, prompt.MaxActivationDistance - 1.25)
    local targetContainer = targetPart:FindFirstAncestor("Watermelon") or targetPart.Parent
    local moved, moveError = moveNear(function()
        return targetPart.Parent and targetPart.Position or nil
    end, stopDistance, Config.MoveTimeout, {
        UsePathfinding = true,
        AllowJumps = true,
        SampleApproaches = true,
        RequireLineOfSight = prompt.RequiresLineOfSight,
        IgnoreInstance = targetContainer,
    })

    if not moved then
        return false, moveError or "move failed"
    end

    if not prompt.Parent or not prompt.Enabled then
        return false, "watermelon disappeared"
    end

    setPhase("smashing_watermelon")
    triggerPrompt(prompt)

    local smashDeadline = os.clock() + 6
    while not State.Stopped and prompt.Parent and prompt.Enabled and os.clock() < smashDeadline do
        task.wait(0.08)
    end

    if prompt.Parent and prompt.Enabled then
        return false, "smash was not acknowledged"
    end

    State.Collected += 1
    setPhase("watermelon_collected")
    log("watermelon smashed", State.Collected)
    waitForRoundEnd()
    return true
end

local function collectWatermelon(prompt)
    if State.Collecting then
        return false, "collect already in progress"
    end

    if not prompt or not prompt.Parent or not prompt.Enabled then
        return false, "watermelon unavailable"
    end

    State.Collecting = true
    local ok, result, reason = pcall(collectRoutine, prompt)
    State.Collecting = false

    if not ok then
        return false, "collect error: " .. tostring(result)
    end

    return result, reason
end

local VoidSince = nil

local function ensureAlive()
    local _, humanoid, root = getCharacter(0)

    if not humanoid or not root then
        setPhase("respawning")
        local _, newHumanoid = getCharacter(30)
        if newHumanoid then
            applySpeed(newHumanoid)
            resetSticky("respawned")
        end
        return false
    end

    applySpeed(humanoid)

    if root.Position.Y < Config.VoidY then
        VoidSince = VoidSince or os.clock()
        if os.clock() - VoidSince >= Config.VoidGrace then
            log("stuck below the map, forcing respawn")
            pcall(function()
                humanoid.Health = 0
            end)
            task.wait(1)
            resetSticky("void recovery")
            VoidSince = nil
        end
        return false
    end

    VoidSince = nil
    return true
end

local function scheduleEnterRetry()
    State.EnterFails += 1
    local delay = Config.EnterBackoffBase * (2 ^ (State.EnterFails - 1))
    if delay > Config.EnterBackoffMax then
        delay = Config.EnterBackoffMax
    end
    State.NextEnterAt = os.clock() + delay
end

local DepRetryAt = 0

local function step()
    if not Config.Enabled then
        return
    end

    if not DialogPackets or not StartMinigame then
        local now = os.clock()
        if now >= DepRetryAt then
            DepRetryAt = now + 20
            loadDependencies()
            if DialogPackets and StartMinigame then
                State.MissingDependencies = nil
                log("dependencies recovered")
            end
        end
        return
    end

    if State.Phase ~= "idle" and os.clock() - State.PhaseSince > Config.WatchdogTimeout then
        resetSticky("watchdog stuck in " .. State.Phase)
        return
    end

    if not ensureAlive() then
        return
    end

    local prompt = findWatermelonPrompt()

    if prompt then
        if State.Collecting then
            if os.clock() - State.PhaseSince > Config.MoveTimeout + 15 then
                resetSticky("collect watchdog")
            end
            return
        end

        local ok, reason = collectWatermelon(prompt)
        if not ok then
            State.LastError = reason
            log(reason)
            task.wait(Config.RetryDelay)
        else
            State.LastError = nil
        end
        return
    end

    if State.Collecting then
        State.Collecting = false
    end

    if State.RoundActive then
        waitForRoundEnd()
        return
    end

    if os.clock() < State.NextEnterAt then
        setPhase("idle")
        return
    end

    local ok, reason = enterMinigame()
    if not ok then
        State.LastError = reason
        log(reason)
        scheduleEnterRetry()
        task.wait(Config.RetryDelay)
    else
        State.LastError = nil
        State.EnterFails = 0
        resetDialog(0.5)
    end
end

runLoop = function()
    if LoopRunning then
        return
    end

    LoopRunning = true

    task.spawn(function()
        log("started", "PlaceVersion", game.PlaceVersion)

        pcall(function()
            LocalPlayer.Idled:Connect(function()
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end)
        end)

        captureControls(true)

        while not State.Stopped do
            State.LoopTicks += 1

            local ok, err = pcall(step)
            if not ok then
                State.LastError = tostring(err)
                log("loop error", err)
                resetSticky("loop error")
                task.wait(Config.RetryDelay)
            end

            task.wait(Config.IdleWait)
        end

        LoopRunning = false
        log("loop exited")
    end)
end

runLoop()

return State
