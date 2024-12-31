local Library = {}

local function loadUI()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    local themes = {
        Default = {
            name = "Default",
            background = Color3.fromRGB(30, 30, 35),
            sidebar = Color3.fromRGB(25, 25, 30),
            button = Color3.fromRGB(45, 45, 50),
            buttonHover = Color3.fromRGB(65, 105, 225),
            text = Color3.fromRGB(255, 255, 255),
            subtext = Color3.fromRGB(200, 200, 200)
        }
    }

    local currentTheme = "Default"

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
        
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        return button
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

        local categoryContainers = {}
        for _, category in ipairs(categories) do
            local container = Instance.new("ScrollingFrame")
            container.Size = UDim2.new(1, -220, 1, -20)
            container.Position = UDim2.new(0, 210, 0, 10)
            container.BackgroundTransparency = 1
            container.ScrollBarThickness = 4
            container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
            container.Name = category.name
            container.Visible = false
            container.Parent = mainFrame
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 10)
            contentLayout.Parent = container
            
            categoryContainers[category.name] = container
        end

        categoryContainers[categories[1].name].Visible = true

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
        titleLabel.Text = title
        titleLabel.TextColor3 = themes[currentTheme].text
        titleLabel.TextSize = 24
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Parent = sidebar

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

                if categoryContainers[selectedCategory] then
                    categoryContainers[selectedCategory].Visible = false
                end

                selectedCategory = category.name
                categoryContainers[selectedCategory].Visible = true

                for catName, btn in pairs(categoryButtons) do
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = catName == selectedCategory 
                            and themes[currentTheme].buttonHover 
                            or themes[currentTheme].button
                    }):Play()
                end
            end)
        end

        categoryButtons[selectedCategory].BackgroundColor3 = themes[currentTheme].buttonHover

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
            ContentFrame = categoryContainers,
            BlurEffect = blurEffect,
            CurrentCategory = function()
                return selectedCategory
            end,
            CreateButton = createStyledButton,
            ShowNotification = function(message, type)
                showNotification(message, type, screenGui)
            end,
            Destroy = function()
                screenGui:Destroy()
                blurEffect:Destroy()
            end
        }

        return ui
    end

    return createModernUI
end

Library.Init = function()
    return loadUI()
end

return Library
