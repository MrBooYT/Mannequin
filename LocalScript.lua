local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ClothesGui = Player:WaitForChild("PlayerGui"):WaitForChild("ClothesGui"):WaitForChild("ClothesFrame")
ClothesGui.Visible = false
ClothesGui.Position = UDim2.fromScale(0.5, 1.1)
ClothesGui.Warning.Visible = false
local SearchId

ReplicatedStorage.ClothesGui.OnClientEvent:Connect(function(Dummy)
	Mannequin = Dummy
	CameraPos = workspace.Camera.CFrame
	workspace.Camera.CameraType = Enum.CameraType.Scriptable
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local proprietyTable = {
		CFrame = Mannequin.CameraPosition.CFrame
	}
	local Tween = TweenService:Create(workspace.Camera, tweenInfo, proprietyTable)
	Tween:Play()
	tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	proprietyTable = {
		Position = UDim2.fromScale(0.5, 0.435),
		Visible = true
	}
	Tween = TweenService:Create(ClothesGui, tweenInfo, proprietyTable)
	Tween:Play()
	Player.Character.Humanoid.WalkSpeed = 0
	Player.Character.Humanoid.JumpHeight = 0
end)

ClothesGui.Search.X.Activated:Connect(function()
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local proprietyTable = {
		CFrame = CameraPos
	}
	local Tween = TweenService:Create(workspace.Camera, tweenInfo, proprietyTable)
	Tween:Play()
	tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	proprietyTable = {
		Position = UDim2.fromScale(0.5, 1.1),
		Visible = false
	}
	Tween = TweenService:Create(ClothesGui, tweenInfo, proprietyTable)
	Tween:Play()
	wait(1)
	workspace.Camera.CameraType = Enum.CameraType.Custom
	Mannequin = nil
	Player.Character.Humanoid.WalkSpeed = 16
	Player.Character.Humanoid.JumpHeight = 7.2
end)

ClothesGui.Search.SearchButton.Activated:Connect(function()
	SearchId = ClothesGui.Search.Text
	ReplicatedStorage.LoadAsset:FireServer(SearchId)
end)

ReplicatedStorage.AssetLoaded.OnClientEvent:Connect(function()
	for _, asset in ipairs(workspace.LoadedAssets:GetChildren()) do
		if asset.Name == SearchId then
			for _, instance in ipairs(asset:GetChildren()) do
				local NewClothing = instance:Clone()
				for _, manpart in ipairs(Mannequin:GetChildren()) do
					if manpart.ClassName == NewClothing.ClassName then
						manpart:Destroy()
						ReplicatedStorage.DestroyAsset:FireServer(manpart.Name)
					end
				end
				NewClothing.Parent = Mannequin
				ClothesGui.Warning.Visible = true
			end
		end
	end
end)

ClothesGui.Search.ApplyButton.Activated:Connect(function()
	for _, v in ipairs(Mannequin:GetChildren()) do
		if v.ClassName == "Accessory" or v.ClassName == "Shirt" or v.ClassName == "Pants" then
			v:Destroy()
			ReplicatedStorage.ChangeDummy:FireServer(v.Name, Mannequin)
		end
	end
	ClothesGui.Warning.Visible = false
end)
