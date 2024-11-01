

local existingNotification = false 
local teleportEnabled = false  
local keybind = Enum.KeyCode.E 

local function displayNotification(message)
    if existingNotification then

        existingNotification:Destroy()
    end

    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui", playerGui)
    existingNotification = Instance.new("TextLabel", screenGui)
    

    existingNotification.Text = message
    existingNotification.Size = UDim2.new(0, 300, 0, 50)  
    existingNotification.Position = UDim2.new(1, -10, 1, -10)  
    existingNotification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
    existingNotification.TextColor3 = Color3.fromRGB(255, 255, 255)  
    existingNotification.TextScaled = true
    existingNotification.AnchorPoint = Vector2.new(1, 1)  
    existingNotification.BorderSizePixel = 0
    
 
    wait(3)
    screenGui:Destroy()
    existingNotification = false
end


local function teleportTo(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()  

    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(position) 
        displayNotification("Teleported to: " .. tostring(position)) 
    end
end


local function getMouseClickPosition()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    return mouse.Hit.Position
end

local function onMouseClick()
    if teleportEnabled then 
        local targetPosition = getMouseClickPosition()
        teleportTo(targetPosition)
    end
end


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


    setKeyButton.MouseButton1Click:Connect(function()
        keyLabel.Text = "Press a key..."
        keybind = nil  

      
        local function captureKeyPress(input)
            if input.UserInputType == Enum.UserInputType.Keyboard and keybind == nil then
                keybind = input.KeyCode
                keyLabel.Text = "Current Key: " .. tostring(keybind)
                game:GetService("UserInputService").InputBegan:Disconnect(captureKeyPress)
            end
        end
        
        game:GetService("UserInputService").InputBegan:Connect(captureKeyPress)
    end)


    okButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        print("Keybind set to: " .. tostring(keybind))
    end)
end


local function toggleTeleportation(input)
    if input.KeyCode == keybind then
        teleportEnabled = not teleportEnabled 
        if teleportEnabled then
            displayNotification("Teleportation enabled! Click to teleport.")
        else
            displayNotification("Teleportation disabled.")
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(toggleTeleportation)


game.Players.LocalPlayer:GetMouse().Button1Down:Connect(onMouseClick)


createKeybindGui()

print("Teleport tool activated! Click in the game to teleport.")
