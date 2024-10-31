-- Teleport Tool Script for Executor

local existingNotification = false  -- Variable to track if a notification already exists
local teleportEnabled = false  -- Variable to track if teleportation is enabled
local keybind = Enum.KeyCode.E  -- Default keybind

-- Function to display a notification
local function displayNotification(message)
    if existingNotification then
        -- If there's already a notification, remove it
        existingNotification:Destroy()
    end

    -- Create a new ScreenGui to display the message
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui", playerGui)
    existingNotification = Instance.new("TextLabel", screenGui)
    
    -- Configure the TextLabel properties
    existingNotification.Text = message
    existingNotification.Size = UDim2.new(0, 300, 0, 50)  -- Width, Height
    existingNotification.Position = UDim2.new(1, -10, 1, -10)  -- Very bottom right corner
    existingNotification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Background color
    existingNotification.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Text color
    existingNotification.TextScaled = true
    existingNotification.AnchorPoint = Vector2.new(1, 1)  -- Anchor point to the bottom right
    existingNotification.BorderSizePixel = 0
    
    -- Fade out and destroy the notification after 3 seconds
    wait(3)
    screenGui:Destroy()
    existingNotification = false
end

-- Function to teleport the player
local function teleportTo(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()  -- Wait for character if not loaded

    -- Ensure HumanoidRootPart exists before teleporting
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(position)  -- Use CFrame for teleportation
        displayNotification("Teleported to: " .. tostring(position))  -- Display the teleportation message
    end
end

-- Function to get the mouse click position
local function getMouseClickPosition()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    return mouse.Hit.Position
end

-- Function to connect the click event for mouse
local function onMouseClick()
    if teleportEnabled then  -- Only teleport if enabled
        local targetPosition = getMouseClickPosition()
        teleportTo(targetPosition)
    end
end

-- Function to create the GUI for keybind setup
local function createKeybindGui()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui", playerGui)
    
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Text = "Set Keybind"

    local keyLabel = Instance.new("TextLabel", frame)
    keyLabel.Size = UDim2.new(1, 0, 0, 50)
    keyLabel.Position = UDim2.new(0, 0, 0.25, 0)
    keyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLabel.TextScaled = true
    keyLabel.Text = "Current Key: " .. tostring(keybind)

    local setKeyButton = Instance.new("TextButton", frame)
    setKeyButton.Size = UDim2.new(1, 0, 0, 50)
    setKeyButton.Position = UDim2.new(0, 0, 0.5, 0)
    setKeyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    setKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    setKeyButton.TextScaled = true
    setKeyButton.Text = "Press to Set Key"

    local okButton = Instance.new("TextButton", frame)
    okButton.Size = UDim2.new(1, 0, 0, 50)
    okButton.Position = UDim2.new(0, 0, 0.75, 0)
    okButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    okButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    okButton.TextScaled = true
    okButton.Text = "OK"

    -- Set keybind on button press
    setKeyButton.MouseButton1Click:Connect(function()
        keyLabel.Text = "Press a key..."
        keybind = nil  -- Reset keybind for capturing new key

        -- Capture the key press
        local function captureKeyPress(input)
            if input.UserInputType == Enum.UserInputType.Keyboard and keybind == nil then
                keybind = input.KeyCode
                keyLabel.Text = "Current Key: " .. tostring(keybind)
                game:GetService("UserInputService").InputBegan:Disconnect(captureKeyPress)
            end
        end
        
        game:GetService("UserInputService").InputBegan:Connect(captureKeyPress)
    end)

    -- Close the GUI and print confirmation
    okButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        print("Keybind set to: " .. tostring(keybind))
    end)
end

-- Function to toggle teleportation with keybind
local function toggleTeleportation(input)
    if input.KeyCode == keybind then
        teleportEnabled = not teleportEnabled  -- Toggle the teleportation state
        if teleportEnabled then
            displayNotification("Teleportation enabled! Click to teleport.")
        else
            displayNotification("Teleportation disabled.")
        end
    end
end

-- Connect the key press to toggle teleportation
game:GetService("UserInputService").InputBegan:Connect(toggleTeleportation)

-- Connect mouse click to teleport function (conditional)
game.Players.LocalPlayer:GetMouse().Button1Down:Connect(onMouseClick)

-- Create the keybind setup GUI
createKeybindGui()

print("Teleport tool activated! Click in the game to teleport.")
