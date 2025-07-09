-- Steal a Brainrot with Circle Menu
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Создаем GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "BrainrotHelper_" .. math.random(1000,9999)
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false
GUI.Enabled = true

-- Круглая кнопка активации
local CircleButton = Instance.new("ImageButton")
CircleButton.Name = "CircleButton"
CircleButton.Size = UDim2.new(0, 60, 0, 60)
CircleButton.Position = UDim2.new(1, -70, 1, -70)
CircleButton.AnchorPoint = Vector2.new(1, 1)
CircleButton.BackgroundColor3 = Color3.fromRGB(100, 70, 180)
CircleButton.BackgroundTransparency = 0.3
CircleButton.ZIndex = 10
CircleButton.Parent = GUI

-- Делаем кнопку круглой
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = CircleButton

-- Иконка на кнопке
local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.Size = UDim2.new(0.7, 0, 0.7, 0)
icon.Position = UDim2.new(0.15, 0, 0.15, 0)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://7072725342" -- Иконка шестеренки
icon.Parent = CircleButton

-- Анимация пульсации
spawn(function()
    while true do
        local tweenIn = TweenService:Create(CircleButton, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 65, 0, 65)})
        local tweenOut = TweenService:Create(CircleButton, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 60, 0, 60)})
        tweenIn:Play()
        tweenIn.Completed:Wait()
        tweenOut:Play()
        tweenOut.Completed:Wait()
        wait(3)
    end
end)

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = GUI

-- Заголовок с возможностью перетаскивания
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "BRAINROT TOOLS"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 200, 220)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "×"
CloseButton.Size = UDim2.new(0.3, 0, 1, 0)
CloseButton.Position = UDim2.new(0.7, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

-- Анимация закрытия
local function CloseGUI()
    CircleButton.Visible = true
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 250, 0, 200)
    
    -- Возвращаем кнопку на место
    local returnTween = TweenService:Create(CircleButton, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -70, 1, -70),
        Size = UDim2.new(0, 60, 0, 60)
    })
    returnTween:Play()
end

-- Система перетаскивания
local dragging, dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        UpdateInput(input)
    end
end)

-- Вкладки
local Tabs = {"Boost", "Movement", "Helper"}
local TabButtons = {}

for i, name in ipairs(Tabs) do
    local button = Instance.new("TextButton")
    button.Text = name
    button.Size = UDim2.new(0.33, -2, 0, 25)
    button.Position = UDim2.new((i-1)*0.33, 0, 0, 25)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    button.TextColor3 = Color3.fromRGB(180, 180, 200)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.Parent = MainFrame
    TabButtons[name] = button
end

-- Фреймы для вкладок
local Frames = {}
for i, name in ipairs(Tabs) do
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, -50)
    frame.Position = UDim2.new(0, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = MainFrame
    Frames[name] = frame
end

-- Активация вкладок
for name, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        for _, frame in pairs(Frames) do
            frame.Visible = false
        end
        Frames[name].Visible = true
    end)
end

-- Вкладка Boost
do
    local frame = Frames["Boost"]
    
    local TpUp = Instance.new("TextButton")
    TpUp.Text = "Tp to UP (105)"
    TpUp.Size = UDim2.new(0.9, 0, 0, 40)
    TpUp.Position = UDim2.new(0.05, 0, 0.05, 0)
    TpUp.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
    TpUp.TextColor3 = Color3.fromRGB(220, 220, 255)
    TpUp.Font = Enum.Font.GothamMedium
    TpUp.Parent = frame
    
    local TpDown = Instance.new("TextButton")
    TpDown.Text = "Tp to Down (105)"
    TpDown.Size = UDim2.new(0.9, 0, 0, 40)
    TpDown.Position = UDim2.new(0.05, 0, 0.55, 0)
    TpDown.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
    TpDown.TextColor3 = Color3.fromRGB(220, 220, 255)
    TpDown.Font = Enum.Font.GothamMedium
    TpDown.Parent = frame
    
    -- Телепортация на 105 блоков вверх
    TpUp.MouseButton1Click:Connect(function()
        local character = Player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local currentCFrame = humanoidRootPart.CFrame
                character:SetPrimaryPartCFrame(currentCFrame + Vector3.new(0, 105, 0))
            end
        end
    end)
    
    -- Телепортация на 105 блоков вниз
    TpDown.MouseButton1Click:Connect(function()
        local character = Player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local currentCFrame = humanoidRootPart.CFrame
                character:SetPrimaryPartCFrame(currentCFrame - Vector3.new(0, 105, 0))
            end
        end
    end)
end

-- Вкладка Movement
do
    local frame = Frames["Movement"]
    local speedEnabled = false
    local jumpEnabled = false
    
    local SpeedBtn = Instance.new("TextButton")
    SpeedBtn.Text = "BoostSpeed: OFF"
    SpeedBtn.Size = UDim2.new(0.9, 0, 0, 40)
    SpeedBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
    SpeedBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 70)
    SpeedBtn.TextColor3 = Color3.fromRGB(255, 220, 230)
    SpeedBtn.Font = Enum.Font.GothamMedium
    SpeedBtn.Parent = frame
    
    local JumpBtn = Instance.new("TextButton")
    JumpBtn.Text = "BoostJump: OFF"
    JumpBtn.Size = UDim2.new(0.9, 0, 0, 40)
    JumpBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
    JumpBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 70)
    JumpBtn.TextColor3 = Color3.fromRGB(255, 220, 230)
    JumpBtn.Font = Enum.Font.GothamMedium
    JumpBtn.Parent = frame
    
    -- Функция скорости
    SpeedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        SpeedBtn.Text = "BoostSpeed: " .. (speedEnabled and "ON" or "OFF")
        SpeedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(90, 70, 80) or Color3.fromRGB(80, 60, 70)
        
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedEnabled and math.random(30, 40) or 16
            end
        end
    end)
    
    -- Функция прыжка
    JumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        JumpBtn.Text = "BoostJump: " .. (jumpEnabled and "ON" or "OFF")
        JumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(90, 70, 80) or Color3.fromRGB(80, 60, 70)
        
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = jumpEnabled and math.random(70, 80) or 50
            end
        end
    end)
end

-- Вкладка Helper
do
    local frame = Frames["Helper"]
    local espActive = false
    local baseParts = {}
    local baseTimers = {}
    
    local EspBtn = Instance.new("TextButton")
    EspBtn.Text = "Base Timer: OFF"
    EspBtn.Size = UDim2.new(0.9, 0, 0, 40)
    EspBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
    EspBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
    EspBtn.TextColor3 = Color3.fromRGB(220, 255, 220)
    EspBtn.Font = Enum.Font.GothamMedium
    EspBtn.Parent = frame
    
    -- Поиск баз
    local function FindBases()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("base") then
                -- Проверяем наличие таймера
                local timerValue = obj:FindFirstChild("Timer")
                if timerValue and timerValue:IsA("IntValue") then
                    table.insert(baseParts, obj)
                    baseTimers[obj] = timerValue
                end
            end
        end
    end

    -- Создание ESP
    local function CreateEsp()
        for _, basePart in ipairs(baseParts) do
            if not basePart:FindFirstChild("BaseTimerGui") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "BaseTimerGui"
                billboard.Size = UDim2.new(5, 0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = basePart
                billboard.MaxDistance = 200
                billboard.Parent = basePart
                
                local timerLabel = Instance.new("TextLabel")
                timerLabel.Text = "00:00"
                timerLabel.Size = UDim2.new(1, 0, 1, 0)
                timerLabel.BackgroundTransparency = 1
                timerLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                timerLabel.TextScaled = true
                timerLabel.Font = Enum.Font.GothamBold
                timerLabel.Parent = billboard
            end
        end
    end

    -- Обновление таймеров
    local function UpdateTimers()
        for basePart, timerValue in pairs(baseTimers) do
            local gui = basePart:FindFirstChild("BaseTimerGui")
            if gui then
                local label = gui:FindFirstChild("TextLabel")
                if label then
                    local seconds = timerValue.Value
                    local minutes = math.floor(seconds / 60)
                    local secondsLeft = seconds % 60
                    
                    if seconds <= 0 then
                        label.Text = "OPEN!"
                        label.TextColor3 = Color3.fromRGB(50, 255, 50)
                    else
                        label.Text = string.format("%02d:%02d", minutes, secondsLeft)
                        label.TextColor3 = seconds < 30 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 50)
                    end
                end
            end
        end
    end

    -- Кнопка переключения ESP
    EspBtn.MouseButton1Click:Connect(function()
        espActive = not espActive
        EspBtn.Text = "Base Timer: " .. (espActive and "ON" or "OFF")
        EspBtn.BackgroundColor3 = espActive and Color3.fromRGB(70, 100, 70) or Color3.fromRGB(60, 80, 60)
        
        if espActive then
            -- Находим базы и создаем ESP
            FindBases()
            CreateEsp()
            
            -- Запускаем обновление таймеров
            RunService:BindToRenderStep("BaseTimerUpdate", Enum.RenderPriority.Last.Value, function()
                UpdateTimers()
            end)
        else
            -- Останавливаем обновление
            RunService:UnbindFromRenderStep("BaseTimerUpdate")
            
            -- Удаляем ESP
            for _, basePart in ipairs(baseParts) do
                local gui = basePart:FindFirstChild("BaseTimerGui")
                if gui then
                    gui:Destroy()
                end
            end
            
            -- Очищаем данные
            baseParts = {}
            baseTimers = {}
        end
    end)
end

-- Функция открытия GUI
local function OpenGUI()
    CircleButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    -- Анимация открытия
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 250, 0, 200)
    })
    openTween:Play()
    
    -- Анимация перемещения кнопки к центру
    local buttonTween = TweenService:Create(CircleButton, TweenInfo.new(0.5), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0)
    })
    buttonTween:Play()
end

-- Обработчик нажатия на круглую кнопку
CircleButton.MouseButton1Click:Connect(function()
    if not MainFrame.Visible then
        OpenGUI()
    end
end)

-- Закрытие по кнопке
CloseButton.MouseButton1Click:Connect(CloseGUI)

-- Активация первой вкладки
Frames["Boost"].Visible = true

-- Защита от обнаружения
spawn(function()
    while true do
        wait(math.random(25, 45))
        if MainFrame.Visible then
            -- Случайное смещение окна
            local newPos = UDim2.new(
                math.random(20,80)/100, 
                math.random(-50,50), 
                math.random(20,80)/100, 
                math.random(-50,50)
            )
            local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5), {Position = newPos})
            tween:Play()
        end
    end
end)

print("Brainrot GUI loaded! Click the circle button to open")
