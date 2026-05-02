-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyCoolMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tạo Frame chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0.5, -100, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Visible = false -- Mặc định ẩn
frame.Parent = screenGui

-- Bo góc cho đẹp
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Text = "HACKER MENU 😎"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

-- Nút bấm mẫu (Tăng tốc chạy)
local speedBtn = Instance.new("TextButton")
speedBtn.Text = "Tăng Tốc (Speed)"
speedBtn.Size = UDim2.new(0.8, 0, 0, 40)
speedBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
speedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
speedBtn.Parent = frame

speedBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    print("Đã tăng tốc độ!")
end)

-- Phím tắt để đóng/mở Menu (Nhấn phím 'M')
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        frame.Visible = not frame.Visible
    end
end)
