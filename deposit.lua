--// ⚡ GUI "Player Selector & Command Sender v15" by Sigma (Enhanced by Grok) 😈
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 🧾 ตารางผู้เล่นที่เลือก (แชร์ระหว่าง GUI)
local selectedPlayers = {}

-- 🌐 ฟังก์ชันส่งคำสั่ง HD Admin
local function sendMessage(command, value)
	local args = { ":" .. command .. " " .. value }
	local success, result = pcall(function()
		return ReplicatedStorage:WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
	end)
	if success then
		print("✅ ส่งคำสั่ง: " .. args[1])
		return true
	else
		warn("❌ ล้มเหลว: ไม่พบ HDAdminClient หรือ RequestCommand - " .. tostring(result))
		return false
	end
end

-- 🖼️ GUI 1: Player Selector UI
local playerGui = Instance.new("ScreenGui")
playerGui.Name = "PlayerSelectorUI"
playerGui.ResetOnSpawn = false
playerGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local playerMain = Instance.new("Frame")
playerMain.Size = UDim2.new(0, 300, 0, 400)
playerMain.Position = UDim2.new(0.3, -150, 0.5, -200)
playerMain.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
playerMain.BorderSizePixel = 0
playerMain.Active = true
playerMain.Draggable = true
playerMain.ClipsDescendants = true
playerMain.ZIndex = 1
playerMain.Parent = playerGui

local playerCorner = Instance.new("UICorner")
playerCorner.CornerRadius = UDim.new(0, 10)
playerCorner.Parent = playerMain

local playerGradient = Instance.new("UIGradient")
playerGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
})
playerGradient.Rotation = 45
playerGradient.Parent = playerMain

local playerStroke = Instance.new("UIStroke")
playerStroke.Thickness = 2
playerStroke.Color = Color3.fromRGB(255, 50, 50)
playerStroke.Transparency = 0.5
playerStroke.Parent = playerMain

local playerTitle = Instance.new("TextLabel")
playerTitle.Text = "👥 เลือกผู้เล่น"
playerTitle.Size = UDim2.new(1, 0, 0, 40)
playerTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
playerTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
playerTitle.Font = Enum.Font.GothamBlack
playerTitle.TextSize = 20
playerTitle.ZIndex = 2
playerTitle.Parent = playerMain
local playerCornerTitle = Instance.new("UICorner")
playerCornerTitle.CornerRadius = UDim.new(0, 8)
playerCornerTitle.Parent = playerTitle

-- 📝 ช่องป้อนชื่อผู้เล่น
local playerInput = Instance.new("TextBox")
playerInput.Size = UDim2.new(1, -10, 0, 35)
playerInput.Position = UDim2.new(0, 5, 0, 45)
playerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
playerInput.TextColor3 = Color3.new(1, 1, 1)
playerInput.PlaceholderText = "🔍 ป้อนชื่อผู้เล่น..."
playerInput.Font = Enum.Font.Gotham
playerInput.TextSize = 16
playerInput.ZIndex = 3
playerInput.Parent = playerMain
local playerCornerInput = Instance.new("UICorner")
playerCornerInput.CornerRadius = UDim.new(0, 6)
playerCornerInput.Parent = playerInput
local playerStrokeInput = Instance.new("UIStroke")
playerStrokeInput.Thickness = 1
playerStrokeInput.Color = Color3.fromRGB(255, 50, 50)
playerStrokeInput.Transparency = 0.7
playerStrokeInput.Parent = playerInput

-- 📜 รายชื่อผู้เล่น
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -10, 1, -135)
playerList.Position = UDim2.new(0, 5, 0, 85)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 6
playerList.BackgroundTransparency = 1
playerList.ClipsDescendants = true
playerList.ZIndex = 2
playerList.Parent = playerMain

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 4)
playerLayout.Parent = playerList

-- 🧩 ฟังก์ชันสร้างรายชื่อผู้เล่น
local function updatePlayerList()
	for _, child in ipairs(playerList:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local item = Instance.new("Frame")
			item.Size = UDim2.new(1, -5, 0, 50)
			item.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
			item.ZIndex = 3
			item.Parent = playerList

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = item

			local thumb = Instance.new("ImageLabel")
			thumb.Size = UDim2.new(0, 50, 0, 50)
			thumb.BackgroundTransparency = 1
			local content, _ = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			thumb.Image = content
			thumb.ZIndex = 4
			thumb.Parent = item
			local cornerThumb = Instance.new("UICorner")
			cornerThumb.CornerRadius = UDim.new(0, 6)
			cornerThumb.Parent = thumb

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Text = plr.Name
			nameLabel.Size = UDim2.new(1, -130, 1, 0)
			nameLabel.Position = UDim2.new(0, 60, 0, 0)
			nameLabel.TextColor3 = Color3.new(1, 1, 1)
			nameLabel.BackgroundTransparency = 1
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 16
			nameLabel.ZIndex = 4
			nameLabel.Parent = item

			local select = Instance.new("TextButton")
			select.Text = selectedPlayers[plr.Name] and "✔" or "เลือก"
			select.Size = UDim2.new(0, 60, 0, 30)
			select.Position = UDim2.new(1, -65, 0.5, -15)
			select.BackgroundColor3 = selectedPlayers[plr.Name] and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(60, 120, 255)
			select.TextColor3 = Color3.new(1, 1, 1)
			select.Font = Enum.Font.GothamBlack
			select.TextSize = 14
			select.ZIndex = 4
			select.Parent = item
			local cornerSelect = Instance.new("UICorner")
			cornerSelect.CornerRadius = UDim.new(0, 6)
			cornerSelect.Parent = select

			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			select.MouseEnter:Connect(function()
				TweenService:Create(select, tweenInfo, { Size = UDim2.new(0, 65, 0, 32) }):Play()
			end)
			select.MouseLeave:Connect(function()
				TweenService:Create(select, tweenInfo, { Size = UDim2.new(0, 60, 0, 30) }):Play()
			end)

			select.MouseButton1Click:Connect(function()
				if selectedPlayers[plr.Name] then
					selectedPlayers[plr.Name] = nil
					select.Text = "เลือก"
					select.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
				else
					selectedPlayers[plr.Name] = true
					select.Text = "✔"
					select.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
				end
				TweenService:Create(select, tweenInfo, { BackgroundColor3 = select.BackgroundColor3 }):Play()
			end)
		end
	end

	playerList.CanvasSize = UDim2.new(0, 0, 0, playerLayout.AbsoluteContentSize.Y + 10)
end

-- 🧩 กรอบปุ่มควบคุม (PlayerSelectorUI)
local playerControlFrame = Instance.new("Frame")
playerControlFrame.Size = UDim2.new(1, -10, 0, 40)
playerControlFrame.Position = UDim2.new(0, 5, 1, -50)
playerControlFrame.BackgroundTransparency = 1
playerControlFrame.ZIndex = 5
playerControlFrame.Parent = playerMain

local playerControlLayout = Instance.new("UIGridLayout")
playerControlLayout.CellSize = UDim2.new(0, 90, 0, 30)
playerControlLayout.CellPadding = UDim2.new(0, 8, 0, 5)
playerControlLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerControlLayout.Parent = playerControlFrame

-- 🔄 ปุ่มรีเฟรช
local refresh = Instance.new("TextButton")
refresh.Text = "🔄 Refresh"
refresh.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
refresh.TextColor3 = Color3.new(1, 1, 1)
refresh.Font = Enum.Font.GothamBlack
refresh.TextSize = 14
refresh.ZIndex = 6
refresh.Parent = playerControlFrame
local cornerRefresh = Instance.new("UICorner")
cornerRefresh.CornerRadius = UDim.new(0, 6)
cornerRefresh.Parent = refresh
local strokeRefresh = Instance.new("UIStroke")
strokeRefresh.Thickness = 1
strokeRefresh.Color = Color3.fromRGB(255, 255, 255)
strokeRefresh.Transparency = 0.7
strokeRefresh.Parent = refresh
refresh.MouseButton1Click:Connect(function()
	updatePlayerList()
end)
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
refresh.MouseEnter:Connect(function()
	TweenService:Create(refresh, tweenInfo, { Size = UDim2.new(0, 95, 0, 32), BackgroundColor3 = Color3.fromRGB(150, 150, 255) }):Play()
end)
refresh.MouseLeave:Connect(function()
	TweenService:Create(refresh, tweenInfo, { Size = UDim2.new(0, 90, 0, 30), BackgroundColor3 = Color3.fromRGB(100, 100, 255) }):Play()
end)

-- 🧠 ปุ่มเลือกทั้งหมด
local selectAll = Instance.new("TextButton")
selectAll.Text = "✅ เลือกทั้งหมด"
selectAll.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
selectAll.TextColor3 = Color3.new(1, 1, 1)
selectAll.Font = Enum.Font.GothamBlack
selectAll.TextSize = 14
selectAll.ZIndex = 6
selectAll.Parent = playerControlFrame
local cornerSelectAll = Instance.new("UICorner")
cornerSelectAll.CornerRadius = UDim.new(0, 6)
cornerSelectAll.Parent = selectAll
local strokeSelectAll = Instance.new("UIStroke")
strokeSelectAll.Thickness = 1
strokeSelectAll.Color = Color3.fromRGB(255, 255, 255)
strokeSelectAll.Transparency = 0.7
strokeSelectAll.Parent = selectAll

local allSelected = false
selectAll.MouseButton1Click:Connect(function()
	allSelected = not allSelected
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			selectedPlayers[plr.Name] = allSelected or nil
		end
	end
	selectAll.Text = allSelected and "❌ ยกเลิกทั้งหมด" or "✅ เลือกทั้งหมด"
	updatePlayerList()
end)
selectAll.MouseEnter:Connect(function()
	TweenService:Create(selectAll, tweenInfo, { Size = UDim2.new(0, 95, 0, 32), BackgroundColor3 = Color3.fromRGB(0, 255, 100) }):Play()
end)
selectAll.MouseLeave:Connect(function()
	TweenService:Create(selectAll, tweenInfo, { Size = UDim2.new(0, 90, 0, 30), BackgroundColor3 = Color3.fromRGB(0, 200, 100) }):Play()
end)

-- 🎮 ปุ่มซ่อน/แสดง (PlayerSelectorUI)
local playerToggleGui = Instance.new("TextButton")
playerToggleGui.Text = "🔴 ซ่อน GUI"
playerToggleGui.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
playerToggleGui.TextColor3 = Color3.new(1, 1, 1)
playerToggleGui.Font = Enum.Font.GothamBlack
playerToggleGui.TextSize = 14
playerToggleGui.ZIndex = 6
playerToggleGui.Parent = playerControlFrame
local cornerToggleGui = Instance.new("UICorner")
cornerToggleGui.CornerRadius = UDim.new(0, 6)
cornerToggleGui.Parent = playerToggleGui
local strokeToggleGui = Instance.new("UIStroke")
strokeToggleGui.Thickness = 1
strokeToggleGui.Color = Color3.fromRGB(255, 255, 255)
strokeToggleGui.Transparency = 0.7
strokeToggleGui.Parent = playerToggleGui

-- 🖼️ GUI 2: Command Sender UI
local commandGui = Instance.new("ScreenGui")
commandGui.Name = "CommandSenderUI"
commandGui.ResetOnSpawn = false
commandGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local commandMain = Instance.new("Frame")
commandMain.Size = UDim2.new(0, 400, 0, 400)
commandMain.Position = UDim2.new(0.7, -200, 0.5, -200)
commandMain.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
commandMain.BorderSizePixel = 0
commandMain.Active = true
commandMain.Draggable = true
commandMain.ClipsDescendants = true
commandMain.ZIndex = 1
commandMain.Parent = commandGui

local commandCorner = Instance.new("UICorner")
commandCorner.CornerRadius = UDim.new(0, 10)
commandCorner.Parent = commandMain

local commandGradient = Instance.new("UIGradient")
commandGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
})
commandGradient.Rotation = 45
commandGradient.Parent = commandMain

local commandStroke = Instance.new("UIStroke")
commandStroke.Thickness = 2
commandStroke.Color = Color3.fromRGB(255, 50, 50)
commandStroke.Transparency = 0.5
commandStroke.Parent = commandMain

local commandTitle = Instance.new("TextLabel")
commandTitle.Text = "💻 ส่งคำสั่ง"
commandTitle.Size = UDim2.new(1, 0, 0, 40)
commandTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
commandTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
commandTitle.Font = Enum.Font.GothamBlack
commandTitle.TextSize = 20
commandTitle.ZIndex = 2
commandTitle.Parent = commandMain
local commandCornerTitle = Instance.new("UICorner")
commandCornerTitle.CornerRadius = UDim.new(0, 8)
commandCornerTitle.Parent = commandTitle

-- 📜 ช่องป้อนคำสั่ง
local commandInput = Instance.new("TextBox")
commandInput.Size = UDim2.new(0.65, -10, 0, 35)
commandInput.Position = UDim2.new(0, 5, 0, 45)
commandInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
commandInput.TextColor3 = Color3.new(1, 1, 1)
commandInput.PlaceholderText = "💻 ป้อนคำสั่ง (เช่น to, rocket)..."
commandInput.Font = Enum.Font.Gotham
commandInput.TextSize = 16
commandInput.ZIndex = 3
commandInput.Parent = commandMain
local cornerCommandInput = Instance.new("UICorner")
cornerCommandInput.CornerRadius = UDim.new(0, 6)
cornerCommandInput.Parent = commandInput
local strokeCommandInput = Instance.new("UIStroke")
strokeCommandInput.Thickness = 1
strokeCommandInput.Color = Color3.fromRGB(255, 50, 50)
strokeCommandInput.Transparency = 0.7
strokeCommandInput.Parent = commandInput

-- 🚀 ปุ่มส่งคำสั่ง
local sendCommandButton = Instance.new("TextButton")
sendCommandButton.Text = "📡 ส่ง"
sendCommandButton.Size = UDim2.new(0.35, -15, 0, 35)
sendCommandButton.Position = UDim2.new(0.65, 5, 0, 45)
sendCommandButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
sendCommandButton.TextColor3 = Color3.new(1, 1, 1)
sendCommandButton.Font = Enum.Font.GothamBlack
sendCommandButton.TextSize = 16
sendCommandButton.ZIndex = 3
sendCommandButton.Parent = commandMain
local cornerSendButton = Instance.new("UICorner")
cornerSendButton.CornerRadius = UDim.new(0, 6)
cornerSendButton.Parent = sendCommandButton
local strokeSendButton = Instance.new("UIStroke")
strokeSendButton.Thickness = 1
strokeSendButton.Color = Color3.fromRGB(255, 255, 255)
strokeSendButton.Transparency = 0.7
strokeSendButton.Parent = sendCommandButton

-- 📜 ข้อความแจ้งเตือน
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 35)
statusLabel.Position = UDim2.new(0, 5, 0, 85)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 16
statusLabel.ZIndex = 3
statusLabel.Parent = commandMain
local cornerStatus = Instance.new("UICorner")
cornerStatus.CornerRadius = UDim.new(0, 6)
cornerStatus.Parent = statusLabel
local strokeStatus = Instance.new("UIStroke")
strokeStatus.Thickness = 1
strokeStatus.Color = Color3.fromRGB(255, 50, 50)
strokeStatus.Transparency = 0.7
strokeStatus.Parent = statusLabel

-- 🧩 กรอบปุ่มคำสั่ง
local buttonFrame = Instance.new("ScrollingFrame")
buttonFrame.Size = UDim2.new(1, -10, 0, 150)
buttonFrame.Position = UDim2.new(0, 5, 0, 125)
buttonFrame.BackgroundTransparency = 1
buttonFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
buttonFrame.ScrollBarThickness = 4
buttonFrame.ZIndex = 5
buttonFrame.Parent = commandMain

local buttonLayout = Instance.new("UIGridLayout")
buttonLayout.CellSize = UDim2.new(0, 70, 0, 30)
buttonLayout.CellPadding = UDim2.new(0, 8, 0, 8)
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Parent = buttonFrame

-- 🎵 UI กรอก ID เพลง
local musicInputUI = Instance.new("Frame")
musicInputUI.Size = UDim2.new(0, 200, 0, 120)
musicInputUI.Position = UDim2.new(0.5, -100, 0.5, -60)
musicInputUI.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
musicInputUI.BorderSizePixel = 0
musicInputUI.Visible = false
musicInputUI.ZIndex = 10
musicInputUI.Parent = commandGui

local musicCorner = Instance.new("UICorner")
musicCorner.CornerRadius = UDim.new(0, 10)
musicCorner.Parent = musicInputUI

local musicGradient = Instance.new("UIGradient")
musicGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
})
musicGradient.Rotation = 45
musicGradient.Parent = musicInputUI

local musicStroke = Instance.new("UIStroke")
musicStroke.Thickness = 2
musicStroke.Color = Color3.fromRGB(255, 50, 50)
musicStroke.Transparency = 0.5
musicStroke.Parent = musicInputUI

local musicTitle = Instance.new("TextLabel")
musicTitle.Text = "🎵 กรอก ID เพลง"
musicTitle.Size = UDim2.new(1, 0, 0, 30)
musicTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
musicTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
musicTitle.Font = Enum.Font.GothamBlack
musicTitle.TextSize = 16
musicTitle.ZIndex = 11
musicTitle.Parent = musicInputUI
local musicCornerTitle = Instance.new("UICorner")
musicCornerTitle.CornerRadius = UDim.new(0, 8)
musicCornerTitle.Parent = musicTitle

local musicIdInput = Instance.new("TextBox")
musicIdInput.Size = UDim2.new(1, -10, 0, 30)
musicIdInput.Position = UDim2.new(0, 5, 0, 35)
musicIdInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
musicIdInput.TextColor3 = Color3.new(1, 1, 1)
musicIdInput.PlaceholderText = "🎵 ป้อน ID เพลง..."
musicIdInput.Font = Enum.Font.Gotham
musicIdInput.TextSize = 14
musicIdInput.ZIndex = 11
musicIdInput.Parent = musicInputUI
local musicCornerInput = Instance.new("UICorner")
musicCornerInput.CornerRadius = UDim.new(0, 6)
musicCornerInput.Parent = musicIdInput
local musicStrokeInput = Instance.new("UIStroke")
musicStrokeInput.Thickness = 1
musicStrokeInput.Color = Color3.fromRGB(255, 50, 50)
musicStrokeInput.Transparency = 0.7
musicStrokeInput.Parent = musicIdInput

local musicButtonFrame = Instance.new("Frame")
musicButtonFrame.Size = UDim2.new(1, -10, 0, 40)
musicButtonFrame.Position = UDim2.new(0, 5, 0, 70)
musicButtonFrame.BackgroundTransparency = 1
musicButtonFrame.ZIndex = 11
musicButtonFrame.Parent = musicInputUI

local musicButtonLayout = Instance.new("UIGridLayout")
musicButtonLayout.CellSize = UDim2.new(0, 90, 0, 30)
musicButtonLayout.CellPadding = UDim2.new(0, 8, 0, 5)
musicButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
musicButtonLayout.Parent = musicButtonFrame

local confirmButton = Instance.new("TextButton")
confirmButton.Text = "✅ ตกลง"
confirmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
confirmButton.TextColor3 = Color3.new(1, 1, 1)
confirmButton.Font = Enum.Font.GothamBlack
confirmButton.TextSize = 14
confirmButton.ZIndex = 12
confirmButton.Parent = musicButtonFrame
local cornerConfirm = Instance.new("UICorner")
cornerConfirm.CornerRadius = UDim.new(0, 6)
cornerConfirm.Parent = confirmButton
local strokeConfirm = Instance.new("UIStroke")
strokeConfirm.Thickness = 1
strokeConfirm.Color = Color3.fromRGB(255, 255, 255)
strokeConfirm.Transparency = 0.7
strokeConfirm.Parent = confirmButton

local cancelButton = Instance.new("TextButton")
cancelButton.Text = "❌ ยกเลิก"
cancelButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
cancelButton.TextColor3 = Color3.new(1, 1, 1)
cancelButton.Font = Enum.Font.GothamBlack
cancelButton.TextSize = 14
cancelButton.ZIndex = 12
cancelButton.Parent = musicButtonFrame
local cornerCancel = Instance.new("UICorner")
cornerCancel.CornerRadius = UDim.new(0, 6)
cornerCancel.Parent = cancelButton
local strokeCancel = Instance.new("UIStroke")
strokeCancel.Thickness = 1
strokeCancel.Color = Color3.fromRGB(255, 255, 255)
strokeCancel.Transparency = 0.7
strokeCancel.Parent = cancelButton

-- 🧩 ฟังก์ชันสร้างปุ่มคำสั่ง
local function createButton(text, color, command, isMusic)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBlack
	btn.TextSize = 14
	btn.ZIndex = 6
	btn.Parent = buttonFrame

	local cornerBtn = Instance.new("UICorner")
	cornerBtn.CornerRadius = UDim.new(0, 6)
	cornerBtn.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.7
	stroke.Parent = btn

	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, tweenInfo, { Size = UDim2.new(0, 75, 0, 32), BackgroundColor3 = Color3.fromRGB(math.min(color.R * 255 + 50, 255), math.min(color.G * 255 + 50, 255), math.min(color.B * 255 + 50, 255)) }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, tweenInfo, { Size = UDim2.new(0, 70, 0, 30), BackgroundColor3 = color }):Play()
	end)

	if isMusic then
		btn.MouseButton1Click:Connect(function()
			musicInputUI.Visible = true
			musicIdInput.Text = ""
			TweenService:Create(musicInputUI, tweenInfo, { BackgroundTransparency = 0 }):Play()
			musicIdInput:CaptureFocus()
		end)
	else
		btn.MouseButton1Click:Connect(function()
			if not next(selectedPlayers) and playerInput.Text == "" then
				warn("⚠️ กรุณาเลือกผู้เล่นหรือป้อนชื่อผู้เล่น!")
				return
			end
			if playerInput.Text ~= "" then
				task.spawn(function()
					if sendMessage(command, playerInput.Text) then
						local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						statusLabel.Text = "📤 ส่งคำสั่ง: " .. command .. " ไปยัง " .. playerInput.Text
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
						task.wait(3)
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
						task.wait(0.5)
						statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
					end
				end)
			end
			for name in pairs(selectedPlayers) do
				task.spawn(function()
					if sendMessage(command, name) then
						local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						statusLabel.Text = "📤 ส่งคำสั่ง: " .. command .. " ไปยัง " .. name
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
						task.wait(3)
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
						task.wait(0.5)
						statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
					end
				end)
			end
		end)
	end
end

-- ปุ่มคำสั่ง
createButton("💩 :poop", Color3.fromRGB(140, 100, 255), "poop")
createButton("🧊 :ice", Color3.fromRGB(0, 170, 255), "ice")
createButton("🚔 :jail", Color3.fromRGB(255, 90, 90), "jail")
createButton("⚡ :zap", Color3.fromRGB(255, 210, 50), "zap")
createButton("🛑 :uncmdbar2", Color3.fromRGB(200, 50, 200), "uncmdbar2")
createButton("🔥 :unff", Color3.fromRGB(255, 150, 50), "unff")
createButton("🕊️ :unfly", Color3.fromRGB(50, 200, 200), "unfly")
createButton("🔄 :re", Color3.fromRGB(100, 255, 100), "re")
createButton("🚶 :to", Color3.fromRGB(255, 100, 150), "to")
createButton("🤝 :bring", Color3.fromRGB(100, 150, 255), "bring")
createButton("🚀 :rocket", Color3.fromRGB(255, 100, 0), "rocket")
createButton("🎵 :music", Color3.fromRGB(0, 150, 255), "music", true)

-- อัปเดต CanvasSize
buttonLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	buttonFrame.CanvasSize = UDim2.new(0, 0, 0, buttonLayout.AbsoluteContentSize.Y + 10)
end)

-- 🎵 การทำงานของ UI กรอก ID เพลง
local function closeMusicInputUI()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(musicInputUI, tweenInfo, { BackgroundTransparency = 1 }):Play()
	task.wait(0.3)
	musicInputUI.Visible = false
end

confirmButton.MouseButton1Click:Connect(function()
	local id = musicIdInput.Text:match("^%d+$")
	if not id then
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		statusLabel.Text = "⚠️ กรุณาป้อน ID เพลง (ตัวเลขเท่านั้น)!"
		TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
		task.wait(3)
		TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
		task.wait(0.5)
		statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
		TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
		return
	end
	task.spawn(function()
		if sendMessage("music", id) then
			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			statusLabel.Text = "📤 ส่งเพลง ID: " .. id
			TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
			task.wait(3)
			TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
			task.wait(0.5)
			statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
			TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
		end
	end)
	closeMusicInputUI()
end)

confirmButton.MouseEnter:Connect(function()
	TweenService:Create(confirmButton, tweenInfo, { Size = UDim2.new(0, 95, 0, 32), BackgroundColor3 = Color3.fromRGB(0, 255, 100) }):Play()
end)
confirmButton.MouseLeave:Connect(function()
	TweenService:Create(confirmButton, tweenInfo, { Size = UDim2.new(0, 90, 0, 30), BackgroundColor3 = Color3.fromRGB(0, 200, 100) }):Play()
end)

cancelButton.MouseButton1Click:Connect(function()
	closeMusicInputUI()
end)
cancelButton.MouseEnter:Connect(function()
	TweenService:Create(cancelButton, tweenInfo, { Size = UDim2.new(0, 95, 0, 32), BackgroundColor3 = Color3.fromRGB(255, 100, 100) }):Play()
end)
cancelButton.MouseLeave:Connect(function()
	TweenService:Create(cancelButton, tweenInfo, { Size = UDim2.new(0, 90, 0, 30), BackgroundColor3 = Color3.fromRGB(255, 50, 50) }):Play()
end)

musicIdInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local id = musicIdInput.Text:match("^%d+$")
		if not id then
			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			statusLabel.Text = "⚠️ กรุณาป้อน ID เพลง (ตัวเลขเท่านั้น)!"
			TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
			task.wait(3)
			TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
			task.wait(0.5)
			statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
			TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
			return
		end
		task.spawn(function()
			if sendMessage("music", id) then
				local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				statusLabel.Text = "📤 ส่งเพลง ID: " .. id
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
				task.wait(3)
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
				task.wait(0.5)
				statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
			end
		end)
		closeMusicInputUI()
	end
end)

-- 🧩 กรอบปุ่มควบคุม (CommandSenderUI)
local commandControlFrame = Instance.new("Frame")
commandControlFrame.Size = UDim2.new(1, -10, 0, 80)
commandControlFrame.Position = UDim2.new(0, 5, 1, -90)
commandControlFrame.BackgroundTransparency = 1
commandControlFrame.ZIndex = 5
commandControlFrame.Parent = commandMain

local commandControlLayout = Instance.new("UIGridLayout")
commandControlLayout.CellSize = UDim2.new(0, 120, 0, 30)
commandControlLayout.CellPadding = UDim2.new(0, 8, 0, 5)
commandControlLayout.SortOrder = Enum.SortOrder.LayoutOrder
commandControlLayout.Parent = commandControlFrame

-- 🎮 ปุ่มซ่อน/แสดง (CommandSenderUI)
local commandToggleGui = Instance.new("TextButton")
commandToggleGui.Text = "🔴 ซ่อน GUI"
commandToggleGui.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
commandToggleGui.TextColor3 = Color3.new(1, 1, 1)
commandToggleGui.Font = Enum.Font.GothamBlack
commandToggleGui.TextSize = 14
commandToggleGui.ZIndex = 6
commandToggleGui.Parent = commandControlFrame
local cornerCommandToggleGui = Instance.new("UICorner")
cornerCommandToggleGui.CornerRadius = UDim.new(0, 6)
cornerCommandToggleGui.Parent = commandToggleGui
local strokeCommandToggleGui = Instance.new("UIStroke")
strokeCommandToggleGui.Thickness = 1
strokeCommandToggleGui.Color = Color3.fromRGB(255, 255, 255)
strokeCommandToggleGui.Transparency = 0.7
strokeCommandToggleGui.Parent = commandToggleGui

-- 🛡️ ปุ่ม Auto :re
local autoReEnabled = false
local autoReButton = Instance.new("TextButton")
autoReButton.Text = "🔄 Auto :re (ปิด)"
autoReButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
autoReButton.TextColor3 = Color3.new(1, 1, 1)
autoReButton.Font = Enum.Font.GothamBlack
autoReButton.TextSize = 14
autoReButton.ZIndex = 6
autoReButton.Parent = commandControlFrame
local cornerAutoRe = Instance.new("UICorner")
cornerAutoRe.CornerRadius = UDim.new(0, 6)
cornerAutoRe.Parent = autoReButton
local strokeAutoRe = Instance.new("UIStroke")
strokeAutoRe.Thickness = 1
strokeAutoRe.Color = Color3.fromRGB(255, 255, 255)
strokeAutoRe.Transparency = 0.7
strokeAutoRe.Parent = autoReButton

-- 🛡️ ปุ่ม Anti-Command
local antiCommandEnabled = false
local antiCommandButton = Instance.new("TextButton")
antiCommandButton.Text = "🛡️ Anti-Command (ปิด)"
antiCommandButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
antiCommandButton.TextColor3 = Color3.new(1, 1, 1)
antiCommandButton.Font = Enum.Font.GothamBlack
antiCommandButton.TextSize = 14
antiCommandButton.ZIndex = 6
antiCommandButton.Parent = commandControlFrame
local cornerAntiCommand = Instance.new("UICorner")
cornerAntiCommand.CornerRadius = UDim.new(0, 6)
cornerAntiCommand.Parent = antiCommandButton
local strokeAntiCommand = Instance.new("UIStroke")
strokeAntiCommand.Thickness = 1
strokeAntiCommand.Color = Color3.fromRGB(255, 255, 255)
strokeAntiCommand.Transparency = 0.7
strokeAntiCommand.Parent = antiCommandButton

-- 🔄 ปุ่ม Auto Spam (ใหม่! กดคำสั่งอัตโนมัติทุก 1.5s)
local autoSpamEnabled = false
local autoSpamConnection = nil
local autoSpamButton = Instance.new("TextButton")
autoSpamButton.Text = "🔄 Auto Spam (ปิด)"
autoSpamButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
autoSpamButton.TextColor3 = Color3.new(1, 1, 1)
autoSpamButton.Font = Enum.Font.GothamBlack
autoSpamButton.TextSize = 14
autoSpamButton.ZIndex = 6
autoSpamButton.Parent = commandControlFrame
local cornerAutoSpam = Instance.new("UICorner")
cornerAutoSpam.CornerRadius = UDim.new(0, 6)
cornerAutoSpam.Parent = autoSpamButton
local strokeAutoSpam = Instance.new("UIStroke")
strokeAutoSpam.Thickness = 1
strokeAutoSpam.Color = Color3.fromRGB(255, 255, 255)
strokeAutoSpam.Transparency = 0.7
strokeAutoSpam.Parent = autoSpamButton

-- ฟังก์ชันส่งคำสั่งแบบ auto (สำหรับ selected players หรือ input)
local function autoSendCommand(command)
	if not next(selectedPlayers) and playerInput.Text == "" then
		warn("⚠️ Auto Spam หยุด: ไม่มีผู้เล่นเลือก!")
		autoSpamEnabled = false
		autoSpamButton.Text = "🔄 Auto Spam (ปิด)"
		autoSpamButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		return
	end
	if playerInput.Text ~= "" then
		sendMessage(command, playerInput.Text)
	end
	for name in pairs(selectedPlayers) do
		-- 🛡️ Check ผู้เล่นยังออนไลน์มั้ย (ป้องกัน error)
		local plr = Players:FindFirstChild(name)
		if plr then
			sendMessage(command, name)
		else
			selectedPlayers[name] = nil  -- ลบออกถ้าออกเกม
		end
	end
	statusLabel.Text = "🔄 Auto: ส่ง " .. command .. " แล้ว!"
end

autoSpamButton.MouseButton1Click:Connect(function()
	autoSpamEnabled = not autoSpamEnabled
	if autoSpamEnabled then
		local cmd = commandInput.Text:lower():gsub("^:", "")
		if cmd == "" then
			warn("⚠️ Auto Spam หยุด: ไม่มีคำสั่งใน input!")
			autoSpamEnabled = false
			return
		end
		autoSpamButton.Text = "🔄 Auto Spam (เปิด)"
		autoSpamButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
		autoSpamConnection = task.spawn(function()
			while autoSpamEnabled do
				autoSendCommand(cmd)
				task.wait(1.5)  -- 1.5 วินาทีตามที่ขอ
			end
		end)
	else
		autoSpamButton.Text = "🔄 Auto Spam (ปิด)"
		autoSpamButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		if autoSpamConnection then
			task.cancel(autoSpamConnection)
			autoSpamConnection = nil
		end
		statusLabel.Text = "🛡️ Auto Spam หยุดแล้ว!"
	end
end)
autoSpamButton.MouseEnter:Connect(function()
	TweenService:Create(autoSpamButton, tweenInfo, { Size = UDim2.new(0, 125, 0, 32), BackgroundColor3 = autoSpamEnabled and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(150, 150, 150) }):Play()
end)
autoSpamButton.MouseLeave:Connect(function()
	TweenService:Create(autoSpamButton, tweenInfo, { Size = UDim2.new(0, 120, 0, 30), BackgroundColor3 = autoSpamEnabled and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(100, 100, 100) }):Play()
end)

-- 🚀 การทำงานของปุ่มส่งคำสั่ง
sendCommandButton.MouseButton1Click:Connect(function()
	local command = commandInput.Text:lower():gsub("^:", "") -- ลบ :
	if command == "" then
		warn("⚠️ กรุณาป้อนคำสั่ง!")
		return
	end
	if not next(selectedPlayers) and playerInput.Text == "" then
		warn("⚠️ กรุณาเลือกผู้เล่นหรือป้อนชื่อผู้เล่น!")
		return
	end
	if playerInput.Text ~= "" then
		task.spawn(function()
			if sendMessage(command, playerInput.Text) then
				local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				statusLabel.Text = "📤 ส่งคำสั่ง: " .. command .. " ไปยัง " .. playerInput.Text
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
				task.wait(3)
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
				task.wait(0.5)
				statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
			end
		end)
	end
	for name in pairs(selectedPlayers) do
		task.spawn(function()
			if sendMessage(command, name) then
				local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				statusLabel.Text = "📤 ส่งคำสั่ง: " .. command .. " ไปยัง " .. name
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
				task.wait(3)
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
				task.wait(0.5)
				statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
				TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
			end
		end)
	end
end)

sendCommandButton.MouseEnter:Connect(function()
	TweenService:Create(sendCommandButton, tweenInfo, { Size = UDim2.new(0.35, -10, 0, 37), BackgroundColor3 = Color3.fromRGB(255, 100, 100) }):Play()
end)
sendCommandButton.MouseLeave:Connect(function()
	TweenService:Create(sendCommandButton, tweenInfo, { Size = UDim2.new(0.35, -15, 0, 35), BackgroundColor3 = Color3.fromRGB(255, 50, 50) }):Play()
end)

-- 🎮 ปุ่มเปิด GUI: เลือกชื่อ (PlayerSelectorUI)
local playerGuiVisible = true
local playerToggleIndicator = Instance.new("TextButton")
playerToggleIndicator.Size = UDim2.new(0, 100, 0, 40)
playerToggleIndicator.Position = UDim2.new(0.3, -50, 0, 10)
playerToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
playerToggleIndicator.Text = "เลือกชื่อ"
playerToggleIndicator.TextColor3 = Color3.new(1, 1, 1)
playerToggleIndicator.Font = Enum.Font.GothamBlack
playerToggleIndicator.TextSize = 16
playerToggleIndicator.ZIndex = 10
playerToggleIndicator.Visible = false
playerToggleIndicator.Active = true
playerToggleIndicator.Draggable = true
playerToggleIndicator.Parent = playerGui

local playerCornerIndicator = Instance.new("UICorner")
playerCornerIndicator.CornerRadius = UDim.new(0, 6)
playerCornerIndicator.Parent = playerToggleIndicator

local playerStrokeIndicator = Instance.new("UIStroke")
playerStrokeIndicator.Thickness = 2
playerStrokeIndicator.Color = Color3.fromRGB(255, 255, 255)
playerStrokeIndicator.Transparency = 0.5
playerStrokeIndicator.Parent = playerToggleIndicator

local function togglePlayerGuiVisibility()
	playerGuiVisible = not playerGuiVisible
	playerMain.Visible = playerGuiVisible
	playerToggleIndicator.Visible = not playerGuiVisible
	playerToggleGui.Text = playerGuiVisible and "🔴 ซ่อน GUI" or "🟢 แสดง GUI"
	playerToggleGui.BackgroundColor3 = playerGuiVisible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)
	playerToggleIndicator.BackgroundColor3 = playerGuiVisible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(playerMain, tweenInfo, { BackgroundTransparency = playerGuiVisible and 0 or 1 }):Play()
	TweenService:Create(playerToggleIndicator, tweenInfo, { BackgroundTransparency = playerGuiVisible and 1 or 0 }):Play()
end

playerToggleGui.MouseButton1Click:Connect(togglePlayerGuiVisibility)
playerToggleIndicator.MouseButton1Click:Connect(togglePlayerGuiVisibility)
playerToggleIndicator.MouseEnter:Connect(function()
	TweenService:Create(playerToggleIndicator, tweenInfo, { Size = UDim2.new(0, 105, 0, 42), BackgroundColor3 = Color3.fromRGB(255, 100, 100) }):Play()
end)
playerToggleIndicator.MouseLeave:Connect(function()
	TweenService:Create(playerToggleIndicator, tweenInfo, { Size = UDim2.new(0, 100, 0, 40), BackgroundColor3 = playerGuiVisible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100) }):Play()
end)

-- 🎮 ปุ่มเปิด GUI: คำสั่ง (CommandSenderUI)
local commandGuiVisible = true
local commandToggleIndicator = Instance.new("TextButton")
commandToggleIndicator.Size = UDim2.new(0, 100, 0, 40)
commandToggleIndicator.Position = UDim2.new(0.7, -50, 0, 10)
commandToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
commandToggleIndicator.Text = "คำสั่ง"
commandToggleIndicator.TextColor3 = Color3.new(1, 1, 1)
commandToggleIndicator.Font = Enum.Font.GothamBlack
commandToggleIndicator.TextSize = 16
commandToggleIndicator.ZIndex = 10
commandToggleIndicator.Visible = false
commandToggleIndicator.Active = true
commandToggleIndicator.Draggable = true
commandToggleIndicator.Parent = commandGui

local commandCornerIndicator = Instance.new("UICorner")
commandCornerIndicator.CornerRadius = UDim.new(0, 6)
commandCornerIndicator.Parent = commandToggleIndicator

local commandStrokeIndicator = Instance.new("UIStroke")
commandStrokeIndicator.Thickness = 2
commandStrokeIndicator.Color = Color3.fromRGB(255, 255, 255)
commandStrokeIndicator.Transparency = 0.5
commandStrokeIndicator.Parent = commandToggleIndicator

local function toggleCommandGuiVisibility()
	commandGuiVisible = not commandGuiVisible
	commandMain.Visible = commandGuiVisible
	commandToggleIndicator.Visible = not commandGuiVisible
	commandToggleGui.Text = commandGuiVisible and "🔴 ซ่อน GUI" or "🟢 แสดง GUI"
	commandToggleGui.BackgroundColor3 = commandGuiVisible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)
	commandToggleIndicator.BackgroundColor3 = commandGuiVisible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(commandMain, tweenInfo, { BackgroundTransparency = commandGuiVisible and 0 or 1 }):Play()
	TweenService:Create(commandToggleIndicator, tweenInfo, { BackgroundTransparency = commandGuiVisible and 1 or 0 }):Play()
end

commandToggleGui.MouseButton1Click:Connect(toggleCommandGuiVisibility)
commandToggleIndicator.MouseButton1Click:Connect(toggleCommandGuiVisibility)
commandToggleIndicator.MouseEnter:Connect(function()
	TweenService:Create(commandToggleIndicator, tweenInfo, { Size = UDim2.new(0, 105, 0, 42), BackgroundColor3 = Color3.fromRGB(255, 100, 100) }):Play()
end)
commandToggleIndicator.MouseLeave:Connect(function()
	TweenService:Create(commandToggleIndicator, tweenInfo, { Size = UDim2.new(0, 100, 0, 40), BackgroundColor3 = commandGuiVisible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100) }):Play()
end)

-- 🎮 คีย์ลัด (Ctrl + H สำหรับ PlayerSelectorUI, Ctrl + J สำหรับ CommandSenderUI)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			togglePlayerGuiVisibility()
		elseif input.KeyCode == Enum.KeyCode.J and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			toggleCommandGuiVisibility()
		end
	end
end)

-- 🔄 Auto :re
autoReButton.MouseButton1Click:Connect(function()
	autoReEnabled = not autoReEnabled
	autoReButton.Text = autoReEnabled and "🔄 Auto :re (เปิด)" or "🔄 Auto :re (ปิด)"
	autoReButton.BackgroundColor3 = autoReEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
end)
autoReButton.MouseEnter:Connect(function()
	TweenService:Create(autoReButton, tweenInfo, { Size = UDim2.new(0, 125, 0, 32), BackgroundColor3 = autoReEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 150, 150) }):Play()
end)
autoReButton.MouseLeave:Connect(function()
	TweenService:Create(autoReButton, tweenInfo, { Size = UDim2.new(0, 120, 0, 30), BackgroundColor3 = autoReEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100) }):Play()
end)

LocalPlayer.CharacterAdded:Connect(function(character)
	if autoReEnabled then
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			task.spawn(function()
				sendMessage("re", LocalPlayer.Name)
			end)
		end)
	end
end)

-- 🛡️ Anti-Command
antiCommandButton.MouseButton1Click:Connect(function()
	antiCommandEnabled = not antiCommandEnabled
	antiCommandButton.Text = antiCommandEnabled and "🛡️ Anti-Command (เปิด)" or "🛡️ Anti-Command (ปิด)"
	antiCommandButton.BackgroundColor3 = antiCommandEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
end)
antiCommandButton.MouseEnter:Connect(function()
	TweenService:Create(antiCommandButton, tweenInfo, { Size = UDim2.new(0, 125, 0, 32), BackgroundColor3 = antiCommandEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 150, 150) }):Play()
end)
antiCommandButton.MouseLeave:Connect(function()
	TweenService:Create(antiCommandButton, tweenInfo, { Size = UDim2.new(0, 120, 0, 30), BackgroundColor3 = antiCommandEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100) }):Play()
end)

TextChatService.TextChannels.RBXGeneral.MessageReceived:Connect(function(message)
	if not antiCommandEnabled then return end
	local msg = message.Text:lower()
	local sender = Players:GetPlayerByUserId(message.SenderUserId)
	local commands = { "poop", "jail", "ice", "control" }
	local counterCommands = { "unpoop", "unjail", "unice", "control" }
	for i, cmd in ipairs(commands) do
		if msg:match(":" .. cmd .. "%s+(%S+)") then
			local targetName = msg:match(":" .. cmd .. "%s+(%S+)")
			if targetName and LocalPlayer.Name:lower():find(targetName, 1, true) then
				task.spawn(function()
					local counterCmd = counterCommands[i]
					local target = (cmd == "control" and sender and sender.Name) or LocalPlayer.Name
					if target then
						sendMessage(counterCmd, target)
						local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						statusLabel.Text = "🛡️ ป้องกัน: รัน " .. counterCmd .. " สำเร็จ! (ตรวจจับ: " .. targetName .. ")"
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
						task.wait(3)
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 1 }):Play()
						task.wait(0.5)
						statusLabel.Text = "🛡️ สถานะ: รอคำสั่ง..."
						TweenService:Create(statusLabel, tweenInfo, { TextTransparency = 0 }):Play()
					end
				end)
			end
		end
	end
end)

-- โหลดรายชื่อเริ่มต้น
updatePlayerList()

-- อัปเดตอัตโนมัติเมื่อมีผู้เล่นเข้า/ออก
local debounce = false
Players.PlayerAdded:Connect(function()
	if not debounce then
		debounce = true
		task.wait(0.5)
		updatePlayerList()
		debounce = false
	end
end)
Players.PlayerRemoving:Connect(function(player)
	selectedPlayers[player.Name] = nil  -- 🛠️ ซ่อมบัค: ลบชื่อจาก selectedPlayers ทันทีที่ออกเกม
	if not debounce then
		debounce = true
		task.wait(0.5)
		updatePlayerList()
		debounce = false
	end
end)
