-- Easy-to-Use UI Library with Theme Settings and Multiple Tabs
local UILib = {}

local function createElement(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

function UILib:Init(config)
    -- Ensure config has Name and default theme
    local theme = config.Theme or "Dark"  -- Default to Dark theme if not provided

    local gui = createElement("ScreenGui", {
        Name = config.Name or "EasyUI",
        ResetOnSpawn = false,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })

    local main = createElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    }, gui)

    createElement("UICorner", { CornerRadius = UDim.new(0, 8) }, main)
    createElement("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, main)

    local layout = createElement("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, main)

    local ui = {}

    -- Add Tabs Container
    local tabContainer = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        Parent = main
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 5) }, tabContainer)

    -- Function to create new Tabs
    local function createTab(tabName, content)
        local button = createElement("TextButton", {
            Size = UDim2.new(0, 100, 0, 40),
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Text = tabName,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            BorderSizePixel = 0,
            Parent = tabContainer
        })
        createElement("UICorner", {}, button)

        button.MouseButton1Click:Connect(function()
            -- Clear previous tab content
            for _, child in pairs(main:GetChildren()) do
                if child ~= tabContainer then
                    child:Destroy()
                end
            end

            -- Add content to the new tab
            content()
        end)
    end

    -- Add the Setting Tab
    createTab("Settings", function()
        local settingsTab = createElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Parent = main
        })

        -- Add theme change options
        ui:AddLabel("Select Theme:")
        ui:AddButton("Light Theme", function()
            gui.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            main.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            ui:SetTextColor(Color3.fromRGB(0, 0, 0))
        end)

        ui:AddButton("Dark Theme", function()
            gui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ui:SetTextColor(Color3.fromRGB(255, 255, 255))
        end)

        ui:AddButton("Blue Theme", function()
            gui.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
            main.BackgroundColor3 = Color3.fromRGB(0, 0, 180)
            ui:SetTextColor(Color3.fromRGB(255, 255, 255))
        end)
    end)

    -- Function to set text color
    function ui:SetTextColor(color)
        for _, label in pairs(main:GetChildren()) do
            if label:IsA("TextLabel") then
                label.TextColor3 = color
            end
        end
    end

    -- Add other standard functions
    function ui:AddLabel(text)
        createElement("TextLabel", {
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        }, main)
    end

    function ui:AddButton(text, callback)
        local btn = createElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Text = text,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14,
            BorderSizePixel = 0
        }, main)
        createElement("UICorner", {}, btn)
        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    function ui:AddToggle(text, default, callback)
        local state = default or false
        local toggle = createElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Text = text .. ": " .. (state and "ON" or "OFF"),
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14
        }, main)
        createElement("UICorner", {}, toggle)
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = text .. ": " .. (state and "ON" or "OFF")
            pcall(callback, state)
        end)
    end

    function ui:AddSpacer(size)
        createElement("Frame", {
            Size = UDim2.new(1, 0, 0, size or 10),
            BackgroundTransparency = 1
        }, main)
    end

    return ui
end

return UILib
