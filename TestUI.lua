-- Sleek Modern UI Library (Inspired by OrionLib)
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
    local gui = createElement("ScreenGui", {
        Name = config.Name or "ModernUILib",
        ResetOnSpawn = false,
        Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    })

    local main = createElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 420, 0, 540),
        Position = UDim2.new(0.5, -210, 0.5, -270),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    }, gui)

    createElement("UICorner", { CornerRadius = UDim.new(0, 10) }, main)
    createElement("UIStroke", { Color = Color3.fromRGB(60, 60, 60), Thickness = 2 }, main)
    createElement("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, main)

    local layout = createElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, main)

    local ui = {}

    function ui:AddLabel(text)
        createElement("TextLabel", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(235, 235, 235),
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left
        }, main)
    end

    function ui:AddButton(text, callback)
        local btn = createElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            BorderSizePixel = 0
        }, main)
        createElement("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)
        createElement("UIStroke", { Color = Color3.fromRGB(90, 90, 90), Thickness = 1 }, btn)
        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    function ui:AddToggle(text, default, callback)
        local state = default or false
        local toggle = createElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(50, 50, 60),
            Text = text .. ": " .. (state and "✅" or "❌"),
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 16
        }, main)
        createElement("UICorner", { CornerRadius = UDim.new(0, 6) }, toggle)
        createElement("UIStroke", { Color = Color3.fromRGB(70, 70, 70), Thickness = 1 }, toggle)
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = text .. ": " .. (state and "✅" or "❌")
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
