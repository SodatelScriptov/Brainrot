-- Steal a Brainrot with Universal Drag System
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Определяем платформу
local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled
local isDesktop = UIS.MouseEnabled

-- Создаем GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "BrainrotHelper_" .. math.random(1000,9999)
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false
GUI.Enabled = true

-- Круглая кнопка активации
local CircleButton = Instance.new("ImageButton")
CircleButton.Name = "CircleButton"
CircleButton.Size = UDim2.new(0, isMobile and 80 or 60, 0, isMobile and 80 or 60)
CircleButton.Position = UDim2.new(1, isMobile and -90 or -70, 1, isMobile and -90 or -70)
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
icon.Image = "rbxassetid://7072725342"
icon.Parent = CircleButton

-- Анимация пульсации
spawn(function()
    while true do
        local tweenIn = TweenService:Create(CircleButton, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {Size = UDim2.new(0, isMobile and 85 or 65, 0, isMobile and 85 or 65)})
        local tweenOut = TweenService:Create(CircleButton, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {Size = UDim2.new(0, isMobile and 80 or 60, 0, isMobile and 80 or 60)})
        tweenIn:Play()
        tweenIn.Completed:Wait()
        tweenOut:Play()
        tweenOut.Completed:Wait()
        wait(3)
    end
end)

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, isMobile and 300 or 250, 0, isMobile and 300 or 250) -- Увеличен размер для новых элементов
MainFrame.Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, isMobile and -150 or -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = GUI

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, isMobile and 40 or 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "BRAINROT TOOLS"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 200, 220)
Title.Font = Enum.Font.GothamBold
Title.TextSize = isMobile and 16 or 14
Title.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "×"
CloseButton.Size = UDim2.new(0.3, 0, 1, 0)
CloseButton.Position = UDim2.new(0.7, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = isMobile and 24 or 18
CloseButton.Parent = TitleBar

-- Анимация закрытия
local function CloseGUI()
    CircleButton.Visible = true
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, isMobile and 300 or 250, 0, isMobile and 300 or 250)
    
    local returnTween = TweenService:Create(CircleButton, TweenInfo.new(0.5), {
        Position = UDim2.new(1, isMobile and -90 or -70, 1, isMobile and -90 or -70),
        Size = UDim2.new(0, isMobile and 80 or 60, 0, isMobile and 80 or 60)
    })
    returnTween:Play()
end

-- УНИВЕРСАЛЬНАЯ СИСТЕМА ПЕРЕТАСКИВАНИЯ (РАБОТАЕТ НА ВСЕХ УСТРОЙСТВАХ)
local dragging = false
local dragStart, startPos

-- Функция для начала перетаскивания
local function StartDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
    
    -- Захватываем событие окончания ввода
    local connection
    connection = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
            connection:Disconnect()
        end
    end)
end

-- Функция для обновления позиции при перетаскивании
local function UpdateDrag(input)
    if not dragging then return end
    
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- Обработчики событий
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        StartDrag(input)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        UpdateDrag(input)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateDrag(input)
    end
end)

-- Вкладки
local Tabs = {"Boost", "Movement", "Helper"}
local TabButtons = {}

for i, name in ipairs(Tabs) do
    local button = Instance.new("TextButton")
    button.Text = name
    button.Size = UDim2.new(0.33, -2, 0, isMobile and 30 or 25)
    button.Position = UDim2.new((i-1)*0.33, 0, 0, isMobile and 40 or 25)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    button.TextColor3 = Color3.fromRGB(180, 180, 200)
    button.Font = Enum.Font.Gotham
    button.TextSize = isMobile and 14 or 12
    button.Parent = MainFrame
    TabButtons[name] = button
end

-- Фреймы для вкладок
local Frames = {}
for i, name in ipairs(Tabs) do
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, -(isMobile and 70 or 50))
    frame.Position = UDim2.new(0, 0, 0, isMobile and 70 or 50)
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
    TpUp.Size = UDim2.new(0.9, 0, 0, isMobile and 50 or 40)
    TpUp.Position = UDim2.new(0.05, 0, 0.05, 0)
    TpUp.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
    TpUp.TextColor3 = Color3.fromRGB(220, 220, 255)
    TpUp.Font = Enum.Font.GothamMedium
    TpUp.TextSize = isMobile and 14 or 12
    TpUp.Parent = frame
    
    local TpDown = Instance.new("TextButton")
    TpDown.Text = "Tp to Down (105)"
    TpDown.Size = UDim2.new(0.9, 0, 0, isMobile and 50 or 40)
    TpDown.Position = UDim2.new(0.05, 0, 0.55, 0)
    TpDown.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
    TpDown.TextColor3 = Color3.fromRGB(220, 220, 255)
    TpDown.Font = Enum.Font.GothamMedium
    TpDown.TextSize = isMobile and 14 or 12
    TpDown.Parent = frame
    
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

-- Вкладка Movement (обновленная)
do
    local frame = Frames["Movement"]
    local speedEnabled = false
    local jumpEnabled = false
    
    local originalSpeed = 16
    local originalJump = 50
    
    -- Контейнеры для настроек
    local speedContainer = Instance.new("Frame")
    speedContainer.Size = UDim2.new(0.9, 0, 0, isMobile and 70 or 60)
    speedContainer.Position = UDim2.new(0.05, 0, 0.05, 0)
    speedContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    speedContainer.Parent = frame
    
    local jumpContainer = Instance.new("Frame")
    jumpContainer.Size = UDim2.new(0.9, 0, 0, isMobile and 70 or 60)
    jumpContainer.Position = UDim2.new(0.05, 0, 0.55, 0)
    jumpContainer.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
    jumpContainer.Parent = frame
    
    -- Элементы для скорости
    local speedTitle = Instance.new("TextLabel")
    speedTitle.Text = "SPEED (16-50)"
    speedTitle.Size = UDim2.new(1, 0, 0.3, 0)
    speedTitle.BackgroundTransparency = 1
    speedTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    speedTitle.Font = Enum.Font.GothamMedium
    speedTitle.TextSize = isMobile and 14 or 12
    speedTitle.Parent = speedContainer
    
    local speedValue = 30 -- Значение по умолчанию
    local speedDisplay = Instance.new("TextLabel")
    speedDisplay.Text = "Value: " .. speedValue
    speedDisplay.Size = UDim2.new(0.5, 0, 0.3, 0)
    speedDisplay.Position = UDim2.new(0, 0, 0.7, 0)
    speedDisplay.BackgroundTransparency = 1
    speedDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDisplay.Font = Enum.Font.GothamMedium
    speedDisplay.TextSize = isMobile and 14 or 12
    speedDisplay.TextXAlignment = Enum.TextXAlignment.Left
    speedDisplay.Parent = speedContainer
    
    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(0.5, 0, 0, 5)
    speedSlider.Position = UDim2.new(0.5, 0, 0.85, 0)
    speedSlider.AnchorPoint = Vector2.new(0, 0.5)
    speedSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
    speedSlider.BorderSizePixel = 0
    speedSlider.Parent = speedContainer
    
    local speedThumb = Instance.new("TextButton")
    speedThumb.Size = UDim2.new(0, 15, 0, 15)
    speedThumb.Position = UDim2.new(0.5, -7, 0.5, -7)
    speedThumb.AnchorPoint = Vector2.new(0.5, 0.5)
    speedThumb.BackgroundColor3 = Color3.new(1, 1, 1)
    speedThumb.Text = ""
    speedThumb.ZIndex = 2
    speedThumb.Parent = speedSlider
    
    -- Элементы для прыжка
    local jumpTitle = Instance.new("TextLabel")
    jumpTitle.Text = "JUMP (50-90)"
    jumpTitle.Size = UDim2.new(1, 0, 0.3, 0)
    jumpTitle.BackgroundTransparency = 1
    jumpTitle.TextColor3 = Color3.fromRGB(200, 255, 200)
    jumpTitle.Font = Enum.Font.GothamMedium
    jumpTitle.TextSize = isMobile and 14 or 12
    jumpTitle.Parent = jumpContainer
    
    local jumpValue = 70 -- Значение по умолчанию
    local jumpDisplay = Instance.new("TextLabel")
    jumpDisplay.Text = "Value: " .. jumpValue
    jumpDisplay.Size = UDim2.new(0.5, 0, 0.3, 0)
    jumpDisplay.Position = UDim2.new(0, 0, 0.7, 0)
    jumpDisplay.BackgroundTransparency = 1
    jumpDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpDisplay.Font = Enum.Font.GothamMedium
    jumpDisplay.TextSize = isMobile and 14 or 12
    jumpDisplay.TextXAlignment = Enum.TextXAlignment.Left
    jumpDisplay.Parent = jumpContainer
    
    local jumpSlider = Instance.new("Frame")
    jumpSlider.Size = UDim2.new(0.5, 0, 0, 5)
    jumpSlider.Position = UDim2.new(0.5, 0, 0.85, 0)
    jumpSlider.AnchorPoint = Vector2.new(0, 0.5)
    jumpSlider.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
    jumpSlider.BorderSizePixel = 0
    jumpSlider.Parent = jumpContainer
    
    local jumpThumb = Instance.new("TextButton")
    jumpThumb.Size = UDim2.new(0, 15, 0, 15)
    jumpThumb.Position = UDim2.new(0.5, -7, 0.5, -7)
    jumpThumb.AnchorPoint = Vector2.new(0.5, 0.5)
    jumpThumb.BackgroundColor3 = Color3.new(1, 1, 1)
    jumpThumb.Text = ""
    jumpThumb.ZIndex = 2
    jumpThumb.Parent = jumpSlider
    
    -- Кнопки активации
    local SpeedBtn = Instance.new("TextButton")
    SpeedBtn.Text = "BoostSpeed: OFF"
    SpeedBtn.Size = UDim2.new(0.3, 0, 0.3, 0)
    SpeedBtn.Position = UDim2.new(0.7, 0, 0.3, 0)
    SpeedBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBtn.Font = Enum.Font.GothamMedium
    SpeedBtn.TextSize = isMobile and 12 or 10
    SpeedBtn.Parent = speedContainer
    
    local JumpBtn = Instance.new("TextButton")
    JumpBtn.Text = "BoostJump: OFF"
    JumpBtn.Size = UDim2.new(0.3, 0, 0.3, 0)
    JumpBtn.Position = UDim2.new(0.7, 0, 0.3, 0)
    JumpBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    JumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpBtn.Font = Enum.Font.GothamMedium
    JumpBtn.TextSize = isMobile and 12 or 10
    JumpBtn.Parent = jumpContainer
    
    -- Функции для обновления значений
    local function UpdateSpeed()
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if speedEnabled then
                    humanoid.WalkSpeed = speedValue
                else
                    humanoid.WalkSpeed = originalSpeed
                end
            end
        end
    end
    
    local function UpdateJump()
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if jumpEnabled then
                    humanoid.JumpPower = jumpValue
                else
                    humanoid.JumpPower = originalJump
                end
            end
        end
    end
    
    -- Обработка слайдеров
    local function SetupSlider(slider, thumb, min, max, current, display)
        local dragging = false
        
        local function updateValue(x)
            local relative = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relative)
            current = value
            display.Text = "Value: " .. value
            thumb.Position = UDim2.new(relative, 0, 0.5, 0)
            return value
        end
        
        thumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        
        thumb.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                current = updateValue(input.Position.X)
                dragging = true
            end
        end)
        
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                current = updateValue(input.Position.X)
            end
        end)
        
        return current
    end
    
    -- Инициализация слайдеров
    speedValue = SetupSlider(speedSlider, speedThumb, 16, 50, speedValue, speedDisplay)
    jumpValue = SetupSlider(jumpSlider, jumpThumb, 50, 90, jumpValue, jumpDisplay)
    
    -- Обработка кнопок активации
    SpeedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        SpeedBtn.Text = "BoostSpeed: " .. (speedEnabled and "ON" or "OFF")
        SpeedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
        UpdateSpeed()
    end)
    
    JumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        JumpBtn.Text = "BoostJump: " .. (jumpEnabled and "ON" or "OFF")
        JumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
        UpdateJump()
    end)
    
    Player.CharacterAdded:Connect(function(character)
        wait(1)
        if speedEnabled then UpdateSpeed() end
        if jumpEnabled then UpdateJump() end
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
    EspBtn.Size = UDim2.new(0.9, 0, 0, isMobile and 50 or 40)
    EspBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
    EspBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
    EspBtn.TextColor3 = Color3.fromRGB(220, 255, 220)
    EspBtn.Font = Enum.Font.GothamMedium
    EspBtn.TextSize = isMobile and 14 or 12
    EspBtn.Parent = frame
    
    local function FindBases()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("base") then
                local timerValue = obj:FindFirstChild("Timer")
                if timerValue and timerValue:IsA("IntValue") then
                    table.insert(baseParts, obj)
                    baseTimers[obj] = timerValue
                end
            end
        end
    end

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

    EspBtn.MouseButton1Click:Connect(function()
        espActive = not espActive
        EspBtn.Text = "Base Timer: " .. (espActive and "ON" or "OFF")
        EspBtn.BackgroundColor3 = espActive and Color3.fromRGB(70, 100, 70) or Color3.fromRGB(60, 80, 60)
        
        if espActive then
            FindBases()
            CreateEsp()
            RunService:BindToRenderStep("BaseTimerUpdate", Enum.RenderPriority.Last.Value, UpdateTimers)
        else
            RunService:UnbindFromRenderStep("BaseTimerUpdate")
            for _, basePart in ipairs(baseParts) do
                local gui = basePart:FindFirstChild("BaseTimerGui")
                if gui then gui:Destroy() end
            end
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
    
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, isMobile and 300 or 250, 0, isMobile and 300 or 250)
    })
    openTween:Play()
    
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

-- Оптимизация для мобильных устройств
if isMobile then
    -- Увеличиваем зону нажатия
    for _, frame in pairs(Frames) do
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("TextButton") then
                local padding = Instance.new("UIPadding")
                padding.PaddingTop = UDim.new(0, 8)
                padding.PaddingBottom = UDim.new(0, 8)
                padding.PaddingLeft = UDim.new(0, 8)
                padding.PaddingRight = UDim.new(0, 8)
                padding.Parent = child
                
                child.TextScaled = true
            end
        end
    end
    
    -- Делаем заголовок больше для удобного перетаскивания
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    -- Увеличиваем область перетаскивания
    local dragArea = Instance.new("Frame")
    dragArea.Size = UDim2.new(1, 0, 0, 15)
    dragArea.Position = UDim2.new(0, 0, 0, -15)
    dragArea.BackgroundTransparency = 1
    dragArea.Parent = MainFrame
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            StartDrag(input)
        end
    end)
end

-- Фикс для перетаскивания на ноутбуках
if isDesktop then
    -- Добавляем возможность перетаскивания за пустые области
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            StartDrag(input)
        end
    end)
end

print("Brainrot GUI loaded! Click the circle button to open")
