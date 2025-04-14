-- Custom UI Library สร้าง GUI เองแบบเรียบง่าย
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MyCustomUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Arcade Piece Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Toggle Button
local AutoFarmToggle = Instance.new("TextButton", MainFrame)
AutoFarmToggle.Position = UDim2.new(0, 10, 0, 50)
AutoFarmToggle.Size = UDim2.new(0, 230, 0, 30)
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoFarmToggle.TextColor3 = Color3.new(1,1,1)
AutoFarmToggle.Font = Enum.Font.Gotham
AutoFarmToggle.TextSize = 14

getgenv().AutoFarm = false
AutoFarmToggle.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    AutoFarmToggle.Text = "Auto Farm: " .. (AutoFarm and "ON" or "OFF")
end)

-- เพิ่มปุ่มอื่นๆ ได้อีก เช่น Kill Aura, Dropdown เลือกมอน ฯลฯ
