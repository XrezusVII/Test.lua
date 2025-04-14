-- Modern UI Library with Collapsible Menu System
local UILib = {}

local function createElement(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do
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
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Text = "Toggle UI",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 14,
        ZIndex = 2
    }, gui)
    createElement("UICorner", {}, toggleBtn)

    local main = createElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 450, 0, 500),
        Position = UDim2.new(0.5, -225, 0.5, -250),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Visible = true,
        Active = true,
        Draggable = true
    }, gui)

    createElement("UICorner", { CornerRadius = UDim.new(0, 10) }, main)
    createElement("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    }, main)

    local tabContainer = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    }, main)

    local tabLayout = createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    }, tabContainer)

    local contentContainer = createElement("Frame", {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        Name = "ContentContainer"
    }, main)

    local sections = {}

    function UILib:CreateTab(name)
        local tabBtn = createElement("TextButton", {
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Text = name,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14
        }, tabContainer)
        createElement("UICorner", {}, tabBtn)

        local section = createElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false
        }, contentContainer)

        local layout = createElement("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, section)

        sections[name] = section

        tabBtn.MouseButton1Click:Connect(function()
            for _, sec in pairs(sections) do
                sec.Visible = false
            end
            section.Visible = true
        end)

        return {
            AddLabel = function(_, text)
                createElement("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text = text,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, section)
            end,

            AddButton = function(_, text, callback)
                local btn = createElement("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Color3.new(1,1,1),
                    TextSize = 14,
                    BorderSizePixel = 0
                }, section)
                createElement("UICorner", {}, btn)
                btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
            end,

            AddToggle = function(_, text, default, callback)
                local state = default or false
                local toggle = createElement("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                    Text = text .. ": " .. (state and "✅" or "❌"),
                    Font = Enum.Font.Gotham,
                    TextColor3 = Color3.new(1,1,1),
                    TextSize = 14
                }, section)
                createElement("UICorner", {}, toggle)
                toggle.MouseButton1Click:Connect(function()
                    state = not state
                    toggle.Text = text .. ": " .. (state and "✅" or "❌")
                    pcall(callback, state)
                end)
            end,

            AddSpacer = function(_, size)
                createElement("Frame", {
                    Size = UDim2.new(1, 0, 0, size or 10),
                    BackgroundTransparency = 1
                }, section)
            end
        }
    end

    toggleBtn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    return UILib
end

return UILib
