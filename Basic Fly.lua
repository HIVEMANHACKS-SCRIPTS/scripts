local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local userInputService = game:GetService("UserInputService")
local playerGui = player:WaitForChild("PlayerGui")


for _, v in ipairs(character:GetChildren()) do
    if v:IsA("Script") and v.Name == "FlyingScript" then
        v:Destroy()
    end
end

local flying = false
local speed = 50 
local bodyVelocity


local function showMessage(text)
    local screenGui = Instance.new("ScreenGui", playerGui)
    local textLabel = Instance.new("TextLabel")

    textLabel.Size = UDim2.new(1, 0, 0.1, 0) 
    textLabel.Position = UDim2.new(0, 0, 0, 0) 
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) 
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.5 
    textLabel.Parent = screenGui

    wait(10)
    screenGui:Destroy() 
end

-- Function to start flying
local function fly()
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = character.HumanoidRootPart

    while flying do
        wait()
        

        local cameraDirection = workspace.CurrentCamera.CFrame.LookVector
        local moveDirection = Vector3.new()


        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cameraDirection
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cameraDirection
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cameraDirection:Cross(Vector3.new(0, 1, 0))
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cameraDirection:Cross(Vector3.new(0, 1, 0))
        end
        

        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            bodyVelocity.Velocity = Vector3.new(moveDirection.X * speed, speed, moveDirection.Z * speed)
        elseif userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
            bodyVelocity.Velocity = Vector3.new(moveDirection.X * speed, -speed, moveDirection.Z * speed)
        else
            bodyVelocity.Velocity = Vector3.new(moveDirection.X * speed, 0, moveDirection.Z * speed)
        end
    end

    bodyVelocity:Destroy()
end


local function stopFlying()
    flying = false
end


userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        if flying then
            stopFlying()
        else
            fly()
        end
    end
end)


showMessage("Press 'E' to toggle flying.\nUse 'W', 'A', 'S', 'D' to move,\n'Space' to go up,\nand 'Left Shift' to go down.")