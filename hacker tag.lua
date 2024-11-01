local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Function to create the "HACKER" label
local function createHackerLabel()
    -- Create a BillboardGui
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = character:WaitForChild("Head") -- Attach to the head
    billboardGui.Size = UDim2.new(0, 100, 0, 50) -- Size of the label
    billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- Position it above the head
    billboardGui.AlwaysOnTop = true -- Always show it above other objects

    -- Create a TextLabel
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0) -- Fill the BillboardGui
    textLabel.BackgroundTransparency = 1 -- Make the background transparent
    textLabel.Text = "HACKER" -- The text to display
    textLabel.TextColor3 = Color3.new(0, 0, 0) -- Black color
    textLabel.TextScaled = true -- Scale the text to fit
    textLabel.Parent = billboardGui

    -- Parent the BillboardGui to the character's head
    billboardGui.Parent = character.Head
end

-- Run the function to create the label
createHackerLabel()
