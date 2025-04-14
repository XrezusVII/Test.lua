-- Modern UI Library with Theme System
local UILib = {}

local Themes = {
    Default = {
        Background = Color3.fromRGB(25, 25, 25),
        Button = Color3.fromRGB(40, 40, 40),
        Toggle = Color3.fromRGB(50, 50, 50),
        TextColor = Color3.new(1,1,1)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Button = Color3.fromRGB(220, 220, 220),
        Toggle = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.new(0,0,0)
    },
    DarkBlue = {
        Background = Color3.fromRGB(15, 15, 35),
        Button = Color3.fromRGB(30, 30, 60),
        Toggle = Color3.fromRGB(40, 40, 70),
        TextColor = Color3.new(0.8, 0.8, 1)
    }
}

local function createElement(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

function UILib:Init(config)
    local themeName = config.Theme or "Default"
    local Theme = Themes[themeName] or Themes.Default

    local gui = createElement("ScreenGui", {
        Name = config.Name or "ModernUI",
        ResetOnSpawn = false,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })

    local main = createElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    }, gui)

    createElement("UICorner", { CornerRadius = UDim.new(0, 8) }, main)
    createElement("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, main)

    local tabButtons = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    }, main)
    local buttonLayout = createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    }, tabButtons)

    local contentFrame = createElement("Frame", {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1
    }, main)

    local ui = {}
    local tabs = {}

    function ui:CreateTab(tabName)
        local tab = createElement("Frame", {
            Name = tabName,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false
        }, contentFrame)

        local layout = createElement("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, tab)

        local tabBtn = createElement("TextButton", {
            Text = tabName,
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Theme.Button,
            TextColor3 = Theme.TextColor,
            Font = Enum.Font.GothamBold,
            TextSize = 14
        }, tabButtons)
        createElement("UICorner", {}, tabBtn)

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(contentFrame:GetChildren()) do
                if t:IsA("Frame") then t.Visible = false end
            end
            tab.Visible = true
        end)

        local api = {}

        function api:AddLabel(text)
            createElement("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }, tab)
        end

        function api:AddButton(text, callback)
            local btn = createElement("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Theme.Button,
                Text = text,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextColor,
                TextSize = 14
            }, tab)
            createElement("UICorner", {}, btn)
            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function api:AddToggle(text, default, callback)
            local state = default or false
            local toggle = createElement("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Theme.Toggle,
                Text = text .. ": " .. (state and "ON" or "OFF"),
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextColor,
                TextSize = 14
            }, tab)
            createElement("UICorner", {}, toggle)
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = text .. ": " .. (state and "ON" or "OFF")
                pcall(callback, state)
            end)
        end

        function api:AddSpacer(size)
            createElement("Frame", {
                Size = UDim2.new(1, 0, 0, size or 10),
                BackgroundTransparency = 1
            }, tab)
        end

        table.insert(tabs, tab)
        return api
    end

    -- Toggle Button
    local toggleBtn = createElement("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Theme.Button,
        Text = "-",
        TextColor3 = Theme.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = main
    })
    createElement("UICorner", {}, toggleBtn)
    local visible = true
    toggleBtn.MouseButton1Click:Connect(function()
        visible = not visible
        contentFrame.Visible = visible
        tabButtons.Visible = visible
        toggleBtn.Text = visible and "-" or "+"
    end)

    return ui
end

return UILib
