local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Themes
Library.Themes = {
    Default = {
        name = "Default",
        background = Color3.fromRGB(30, 30, 35),
        sidebar = Color3.fromRGB(25, 25, 30),
        section = Color3.fromRGB(20, 20, 25),
        button = Color3.fromRGB(45, 45, 50),
        buttonHover = Color3.fromRGB(65, 105, 225),
        toggle = Color3.fromRGB(45, 45, 50),
        toggleEnabled = Color3.fromRGB(65, 105, 225),
        slider = Color3.fromRGB(45, 45, 50),
        sliderFill = Color3.fromRGB(65, 105, 225),
        dropdown = Color3.fromRGB(45, 45, 50),
        dropdownHover = Color3.fromRGB(65, 105, 225),
        text = Color3.fromRGB(255, 255, 255),
        subtext = Color3.fromRGB(200, 200, 200),
        placeholder = Color3.fromRGB(150, 150, 150)
    }
}

local currentTheme = "Default"

local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.BackgroundColor3 = Library.Themes[currentTheme].button
    button.Text = text
    button.TextColor3 = Library.Themes[currentTheme].text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Library.Themes[currentTheme].buttonHover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Library.Themes[currentTheme].button
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return button
end

local function createToggle(text, callback)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, -20, 0, 35)
    toggleButton.BackgroundColor3 = Library.Themes[currentTheme].toggle
    toggleButton.Text = text
    toggleButton.TextColor3 = Library.Themes[currentTheme].text
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleButton
    
    local enabled = false
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Library.Themes[currentTheme].toggleEnabled or Library.Themes[currentTheme].toggle
        }):Play()
        callback(enabled)
    end)
    
    return toggleButton
end

local function createSlider(text, min, max, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Library.Themes[currentTheme].text
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Library.Themes[currentTheme].slider
    sliderBg.Parent = sliderFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Library.Themes[currentTheme].sliderFill
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 0, 20)
    valueLabel.Position = UDim2.new(0, 0, 0, 30)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = min
    valueLabel.TextColor3 = Library.Themes[currentTheme].subtext
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            TweenService:Create(fill, TweenInfo.new(0.1), {
                Size = UDim2.new(percentage, 0, 1, 0)
            }):Play()
            
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return sliderFrame
end

local function createDropdown(text, options, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, -20, 0, 35)
    dropdownFrame.BackgroundColor3 = Library.Themes[currentTheme].dropdown
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = dropdownFrame
    
    local label = Instance.new("TextButton")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Library.Themes[currentTheme].text
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = dropdownFrame
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 35)
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Library.Themes[currentTheme].dropdown
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 2
    optionsFrame.Parent = dropdownFrame
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsFrame
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 35)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = Library.Themes[currentTheme].text
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.Gotham
        optionButton.ZIndex = 2
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            label.Text = text .. ": " .. option
            optionsFrame.Visible = false
            callback(option)
        end)
    end
    
    label.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
    end)
    
    return dropdownFrame
end

local function createSection(name)
    local section = {}
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, -20, 0, 30)
    sectionFrame.BackgroundColor3 = Library.Themes[currentTheme].section
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = sectionFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Library.Themes[currentTheme].text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = sectionFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -30)
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = sectionFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = contentFrame
    
    function section:Button(text, callback)
        local button = createButton(text, callback)
        button.Parent = contentFrame
        sectionFrame.Size = UDim2.new(1, -20, 0, contentFrame.AbsoluteSize.Y + 35)
        return button
    end
    
    function section:Toggle(text, callback)
        local toggle = createToggle(text, callback)
        toggle.Parent = contentFrame
        sectionFrame.Size = UDim2.new(1, -20, 0, contentFrame.AbsoluteSize.Y + 35)
        return toggle
    end
    
    function section:Slider(text, min, max, callback)
        local slider = createSlider(text, min, max, callback)
        slider.Parent = contentFrame
        sectionFrame.Size = UDim2.new(1, -20, 0, contentFrame.AbsoluteSize.Y + 50)
        return slider
    end
    
    function section:Dropdown(text, options, callback)
        local dropdown = createDropdown(text, options, callback)
        dropdown.Parent = contentFrame
        sectionFrame.Size = UDim2.new(1, -20, 0, contentFrame.AbsoluteSize.Y + 35)
        return dropdown
    end
    
    function section:Label(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 25)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Library.Themes[currentTheme].text
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.Parent = contentFrame
        sectionFrame.Size = UDim2.new(1, -20, 0, contentFrame.AbsoluteSize.Y + 25)
        return label
    end
    
    return section, sectionFrame
end

function Library:CreateWindow(title, imageId)
    local window = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernUI"
    gui.Parent = game:GetService("CoreGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 800, 0, 500)
    main.Position = UDim2.new(0.5, -400, 0.5, -250)
    main.BackgroundColor3 = Library.Themes[currentTheme].background
    main.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = main

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = Library.Themes[currentTheme].sidebar
    sidebar.Parent = main
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 6)
    sidebarCorner.Parent = sidebar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 60)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Library.Themes[currentTheme].text
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = sidebar

    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, 0, 1, -70)
    tabContainer.Position = UDim2.new(0, 0, 0, 70)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    tabContainer.Parent = sidebar
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabContainer

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -220, 1, -20)
    contentFrame.Position = UDim2.new(0, 210, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = main

    local dragging = false
    local dragStart
    local startPos
    
    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)

    function window:Tab(name, icon)
        local tab = {}
        local sections = {}
        local isActive = #sections == 0

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.Position = UDim2.new(0, 10, 0, #sections * 45)
        tabButton.BackgroundColor3 = isActive and Library.Themes[currentTheme].buttonHover or Library.Themes[currentTheme].button
        tabButton.Text = (icon and (icon .. " ") or "") .. name
        tabButton.TextColor3 = Library.Themes[currentTheme].text
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = tabContainer
        tabButton.AutoButtonColor = false
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Library.Themes[currentTheme].buttonHover
        tabContent.Visible = isActive
        tabContent.Parent = contentFrame
        
        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 10)
        contentList.Parent = tabContent

        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(sections) do
                otherTab.button.BackgroundColor3 = Library.Themes[currentTheme].button
                otherTab.content.Visible = false
            end
            tabButton.BackgroundColor3 = Library.Themes[currentTheme].buttonHover
            tabContent.Visible = true
        end)
        
        function tab:Section(name)
            local section, sectionFrame = createSection(name)
            sectionFrame.Parent = tabContent
            return section
        end
        
        table.insert(sections, {button = tabButton, content = tabContent})
        return tab
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            main.Visible = not main.Visible
        end
    end)
    
    return window
end

return Library
