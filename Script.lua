local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

ReplicatedStorage.LoadAsset.OnServerEvent:Connect(function(plr, AssetId)
	for _, v in ipairs(workspace.LoadedAssets:GetChildren()) do
		if v.Name == AssetId then
			return
		end
	end
		local Asset = InsertService:LoadAsset(AssetId)
		Asset.Parent = workspace.LoadedAssets
		Asset.Name = AssetId
		for _, v in ipairs(Asset:GetChildren()) do
			v.Name = AssetId
		end
		ReplicatedStorage.AssetLoaded:FireClient(plr)
end)

ReplicatedStorage.DestroyAsset.OnServerEvent:Connect(function(plr, AssetId)
	for _, v in ipairs(workspace.LoadedAssets:GetChildren()) do
		if v.Name == AssetId then
			v:Destroy()
		end
	end
end)

ReplicatedStorage.ChangeDummy.OnServerEvent:Connect(function(plr, ProductId, Dummy)
	for _, asset in ipairs(workspace.LoadedAssets:GetChildren()) do
		if asset.Name == ProductId then
			for _, v in ipairs(asset:GetChildren()) do
				local clothing = v:Clone()
				clothing.Parent = Dummy
			end
		end
	end
end)
