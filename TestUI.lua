-- Easy-to-Use Modern UI Library with Tabs and Toggle Visibility
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
    local player = game:GetService("Players").LocalPlayer
    local gui = createElement("ScreenGui", {
        Name = config.Name or "ModernUI",
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })

    -- Toggle Button
    local toggleBtn = createElement("TextButton", {
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "Toggle UI",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        ZIndex = 10
    }, gui)
    createElement("UICorner", {}, toggleBtn)

    -- Main UI Frame
    local main = createElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 450, 0, 500),
        Position = UDim2.new(0.5, -225, 0.5, -250),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    }, gui)
    createElement("UICorner", { CornerRadius = UDim.new(0, 10) }, main)

    -- Tab Buttons Holder
    local tabButtons = createElement("Frame", {
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, main)
    createElement("UICorner", {}, tabButtons)
    createElement("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, tabButtons)

    -- Pages Holder
    local pages = createElement("Frame", {
        Position = UDim2.new(0, 125, 0, 0),
        Size = UDim2.new(1, -125, 1, 0),
        BackgroundTransparency = 1
    }, main)

    local ui = { Tabs = {} }

    function ui:CreateTab(name)
        local page = createElement("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            Visible = false
        }, pages)
        local layout = createElement("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, page)

        local tabButton = createElement("TextButton", {
            Size = UDim2.new(1, -10, 0, 30),
            Text = name,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(55, 55, 55),
            TextColor3 = Color3.new(1, 1, 1)
        }, tabButtons)
        createElement("UICorner", {}, tabButton)

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(ui.Tabs) do t.page.Visible = false end
            page.Visible = true
        end)

        local tab = {}
        function tab:AddLabel(text)
            createElement("TextLabel", {
                Size = UDim2.new(1, -10, 0, 24),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.GothamBold,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left
            }, page)
        end

        function tab:AddButton(text, callback)
            local btn = createElement("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Text = text,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 14,
                BorderSizePixel = 0
            }, page)
            createElement("UICorner", {}, btn)
            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function tab:AddToggle(text, default, callback)
            local state = default or false
            local toggle = createElement("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(65, 65, 65),
                Text = text .. ": " .. (state and "ON" or "OFF"),
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 14
            }, page)
            createElement("UICorner", {}, toggle)
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = text .. ": " .. (state and "ON" or "OFF")
                pcall(callback, state)
            end)
        end

        function tab:AddSpacer(size)
            createElement("Frame", {
                Size = UDim2.new(1, 0, 0, size or 10),
                BackgroundTransparency = 1
            }, page)
        end

        ui.Tabs[name] = { page = page }
        if #pages:GetChildren() == 2 then page.Visible = true end
        return tab
    end

    toggleBtn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    return ui
end

return UILib
