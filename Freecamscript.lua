-- Free Cam Script for Roblox
local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")

-- Variables to control camera movement
local freeCamEnabled = false
local camSpeed = 50 -- Camera movement speed
local sensitivity = 0.2 -- Mouse sensitivity
local rotationSpeed = 0.5 -- Camera rotation speed

-- Variables to store camera offset
local camOffset = Vector3.new(0, 5, 10)
local lastPosition = camera.CFrame.Position
local lastMousePosition = Vector2.new()

-- Toggle Free Cam (press "F" to enable/disable)
local function toggleFreeCam()
    freeCamEnabled = not freeCamEnabled
    if freeCamEnabled then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(lastPosition + camOffset)
    else
        camera.CameraType = Enum.CameraType.Custom
        -- Reset camera back to player view
        camera.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position + camOffset)
    end
end

-- Handle camera movement when free cam is enabled
local function moveCamera()
    if freeCamEnabled then
        local mouseDelta = userInputService:GetMouseDelta()
        local moveDirection = Vector3.new()

        -- Rotate the camera based on mouse movement
        local horizontalRotation = CFrame.Angles(0, -mouseDelta.X * rotationSpeed, 0)
        local verticalRotation = CFrame.Angles(mouseDelta.Y * rotationSpeed, 0, 0)

        -- Move the camera with WASD keys
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        -- Move the camera up and down with Q/E keys
        if userInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveDirection = moveDirection - camera.CFrame.UpVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.E) then
            moveDirection = moveDirection + camera.CFrame.UpVector
        end
        
        -- Update the camera's position
        camera.CFrame = camera.CFrame * horizontalRotation * verticalRotation
        camera.CFrame = camera.CFrame + moveDirection.Unit * camSpeed * 0.1
    end
end

-- Listen for "F" key to toggle free cam
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F then
        toggleFreeCam()
    end
end)

-- Continuously move the camera when free cam is enabled
game:GetService("RunService").RenderStepped:Connect(function()
    moveCamera()
end)
