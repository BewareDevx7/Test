local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Themes
local themes = {
    Default = {
        name = "Default",
        background = Color3.fromRGB(30, 30, 35),
        sidebar = Color3.fromRGB(25, 25, 30),
        button = Color3.fromRGB(45, 45, 50),
        buttonHover = Color3.fromRGB(65, 105, 225),
        text = Color3.fromRGB(255, 255, 255),
        subtext = Color3.fromRGB(200, 200, 200)
    },
    Dark = {
        name = "Dark",
        background = Color3.fromRGB(20, 20, 25),
        sidebar = Color3.fromRGB(15, 15, 20),
        button = Color3.fromRGB(35, 35, 40),
        buttonHover = Color3.fromRGB(45, 45, 135),
        text = Color3.fromRGB(255, 255, 255),
        subtext = Color3.fromRGB(180, 180, 180)
    },
    Light = {
        name = "Light",
        background = Color3.fromRGB(240, 240, 245),
        sidebar = Color3.fromRGB(230, 230, 235),
        button = Color3.fromRGB(220, 220, 225),
        buttonHover = Color3.fromRGB(65, 105, 225),
        text = Color3.fromRGB(30, 30, 35),
        subtext = Color3.fromRGB(60, 60, 65)
    }
}

local currentTheme = "Default"

local function applyThemeToElements(mainFrame, sidebar, theme, instant)
    if not mainFrame or not sidebar then
        warn("Missing required UI elements for theme application")
        return false
    end
    
    local function createSafeTween(instance, properties)
        if not instance then return end
        
        local tweenInfo = instant and TweenInfo.new(0) or TweenInfo.new(0.5)
        local success, tween = pcall(function()
            return TweenService:Create(instance, tweenInfo, properties)
        end)
        
        if success and tween then
            tween:Play()
        else
            for property, value in pairs(properties) do
                pcall(function()
                    instance[property] = value
                end)
            end
        end
    end

    createSafeTween(mainFrame, {
        BackgroundColor3 = theme.background
    })

    createSafeTween(sidebar, {
        BackgroundColor3 = theme.sidebar
    })
    
    local titleLabel = sidebar:FindFirstChild("TextLabel")
    if titleLabel then
        createSafeTween(titleLabel, {
            TextColor3 = theme.text
        })
    end
    
    for _, button in pairs(sidebar:GetChildren()) do
        if button:IsA("TextButton") then
            local isSelected = button.BackgroundColor3 == themes[currentTheme].buttonHover
            
            createSafeTween(button, {
                BackgroundColor3 = isSelected and theme.buttonHover or theme.button,
                TextColor3 = theme.text
            })
        end
    end

    local contentFrame = mainFrame:FindFirstChild("ScrollingFrame")
    if contentFrame then
        for _, child in pairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                pcall(function()
                    createSafeTween(child, {
                        BackgroundColor3 = theme.button,
                        TextColor3 = theme.text
                    })
                end)
            end
        end
    end
    
    return true
end

local function createStyledButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.BackgroundColor3 = themes[currentTheme].button
    button.Text = text
    button.TextColor3 = themes[currentTheme].text
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = themes[currentTheme].buttonHover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = themes[currentTheme].button
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

local function createAnimatedDropdown(parent, position)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0, 200, 0, 300)
    dropdown.Position = position
    dropdown.BackgroundColor3 = themes[currentTheme].button
    dropdown.BorderSizePixel = 0
    dropdown.Visible = false
    dropdown.ZIndex = 10
    dropdown.Parent = parent
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 8)
    dropdownCorner.Parent = dropdown
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = themes[currentTheme].button
    titleLabel.TextColor3 = themes[currentTheme].text
    titleLabel.TextSize = 14
    titleLabel.Text = "Search"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.ZIndex = 10
    titleLabel.Parent = dropdown
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleLabel
    
    local searchBar = Instance.new("TextBox")
    searchBar.Size = UDim2.new(0.9, 0, 0, 30)
    searchBar.Position = UDim2.new(0.05, 0, 0, 40)
    searchBar.BackgroundColor3 = themes[currentTheme].button
    searchBar.TextColor3 = themes[currentTheme].text
    searchBar.PlaceholderText = "Search..."
    searchBar.Text = ""
    searchBar.PlaceholderColor3 = themes[currentTheme].subtext
    searchBar.TextSize = 14
    searchBar.Font = Enum.Font.Gotham
    searchBar.ZIndex = 10
    searchBar.Parent = dropdown
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = searchBar
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0.9, 0, 0.75, -40)
    scrollFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scrollFrame.ZIndex = 10
    scrollFrame.Parent = dropdown
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    local isOpen = false
    
    local function animateDropdown(opening)
        if opening then
            dropdown.Position = UDim2.new(1, 20, position.Y.Scale, position.Y.Offset)
            dropdown.Visible = true
            TweenService:Create(dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = position,
                BackgroundTransparency = 0
            }):Play()
        else
            TweenService:Create(dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, 20, position.Y.Scale, position.Y.Offset),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.3)
            dropdown.Visible = false
        end
    end
    
    searchBar.Changed:Connect(function(prop)
        if prop == "Text" then
            local searchText = searchBar.Text:lower()
            for _, button in ipairs(scrollFrame:GetChildren()) do
                if button:IsA("TextButton") then
                    button.Visible = button.Text:lower():find(searchText, 1, true) ~= nil
                end
            end
        end
    end)
    
    local function toggleDropdown(show)
        isOpen = show ~= nil and show or not isOpen
        animateDropdown(isOpen)
    end
    
    return dropdown, scrollFrame, titleLabel, toggleDropdown
end

local function showNotification(message, type, screenGui)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.Position = UDim2.new(1, -270, 0.9, -70)
    notif.BackgroundColor3 = type == "success" and Color3.fromRGB(35, 165, 85) or Color3.fromRGB(225, 45, 45)
    notif.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = themes[currentTheme].text
    notifText.TextSize = 16
    notifText.Font = Enum.Font.GothamBold
    notifText.TextWrapped = true
    notifText.Parent = notif
    
    notif.Position = UDim2.new(1, 20, 0.9, -70)
    TweenService:Create(notif, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -270, 0.9, -70)
    }):Play()
    
    task.wait(2)
    
    TweenService:Create(notif, TweenInfo.new(0.5), {
        Position = UDim2.new(1, 20, 0.9, -70)
    }):Play()
    
    task.wait(0.5)
    notif:Destroy()
end

local function createModernUI(title, categories)
    categories = categories or {
        {name = "Home", icon = "🏠"},
        {name = "Settings", icon = "⚙️"}
    }

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernUI"
    screenGui.Parent = game.CoreGui
    
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 10
    blurEffect.Parent = game.Lighting
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 800, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    mainFrame.BackgroundColor3 = themes[currentTheme].background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local dragging = false
    local dragStart
    local startPos

    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            local targetPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            
            TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = targetPosition
            }):Play()
        end
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = themes[currentTheme].sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent = sidebar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 60)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Modern UI"
    titleLabel.TextColor3 = themes[currentTheme].text
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = sidebar

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -220, 1, -20)
    contentFrame.Position = UDim2.new(0, 210, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    contentFrame.Parent = mainFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = contentFrame

    local selectedCategory = categories[1].name
    local categoryButtons = {}
    
    for i, category in ipairs(categories) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, 40)
        button.Position = UDim2.new(0.05, 0, 0, 70 + (i-1) * 50)
        button.BackgroundColor3 = themes[currentTheme].button
        button.Text = category.icon .. " " .. category.name
        button.TextColor3 = themes[currentTheme].text
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        button.Parent = sidebar
        button.AutoButtonColor = false
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        
        categoryButtons[category.name] = button
        
        button.MouseButton1Click:Connect(function()
            if selectedCategory == category.name then return end
            
            selectedCategory = category.name
            for catName, btn in pairs(categoryButtons) do
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = catName == selectedCategory 
                        and themes[currentTheme].buttonHover 
                        or themes[currentTheme].button
                }):Play()
            end

            if ui and ui.OnCategoryChanged then
                ui.OnCategoryChanged(category.name)
            end
        end)
    end

    categoryButtons[selectedCategory].BackgroundColor3 = themes[currentTheme].buttonHover

    local dropdowns = {}
    
    local function createDropdownSystem()
        for i = 1, 3 do  
            local dropdown, scrollFrame, titleLabel, toggleDropdown = createAnimatedDropdown(
                mainFrame, 
                UDim2.new(1, 10, 0.2 * (i-1), 0)
            )
            
            table.insert(dropdowns, {
                frame = dropdown,
                scroll = scrollFrame,
                title = titleLabel,
                toggle = toggleDropdown
            })
        end
    end
    
    createDropdownSystem()

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            
            for _, dropdown in ipairs(dropdowns) do
                if dropdown.frame.Visible then
                    local dropdownPos = dropdown.frame.AbsolutePosition
                    local dropdownSize = dropdown.frame.AbsoluteSize
                    
                    if mousePos.X < dropdownPos.X or 
                       mousePos.X > dropdownPos.X + dropdownSize.X or
                       mousePos.Y < dropdownPos.Y or 
                       mousePos.Y > dropdownPos.Y + dropdownSize.Y then
                        dropdown.toggle(false)
                    end
                end
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            mainFrame.Visible = not mainFrame.Visible
            blurEffect.Enabled = mainFrame.Visible
        end
    end)

    local ui = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Sidebar = sidebar,
        ContentFrame = contentFrame,
        BlurEffect = blurEffect,
        Dropdowns = dropdowns,
        CurrentCategory = function()
            return selectedCategory
        end,
        CreateButton = createStyledButton,
        ShowNotification = function(message, type)
            showNotification(message, type, screenGui)
        end,
        ApplyTheme = function(themeName, instant)
            local theme = themes[themeName]
            if theme then
                currentTheme = themeName
                applyThemeToElements(mainFrame, sidebar, theme, instant)
                return true
            end
            return false
        end,
        GetThemes = function()
            return themes
        end,
        Destroy = function()
            screenGui:Destroy()
            blurEffect:Destroy()
        end,
        OnCategoryChanged = nil 
    }

    return ui
end

return createModernUI
