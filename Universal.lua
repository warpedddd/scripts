getgenv().Astra = {
    ["Core"] = {
        ["watermark"] = false;
        ["FPS_cap"] = 0;
    },

    ["Aimbot"] = {
        ["enabled"] = true;
        ["mode"] = "camera"; -- camera or mouse
        ["threading"] = "RenderStepped";
        ["aimbone"] = "Head";
        ["strength"] = 1;
        ["useFOV"] = true;
        ["fovSize"] = 160;
        ["bind"] = {
            ["key"] = "x";
            ["mode"] = "hold"; -- options: hold, toggle, always
        },
    },

    ["Triggerbot"] = {
        ["enabled"] = true;
        ["meshparts"] = true;
        ["mode"] = "all executors";
        ["delay"] = 0.1;
        ["threading"] = "RenderStepped";
        ["bind"] = {
            ["key"] = "Q";
            ["mode"] = "toggle"; -- options: hold, toggle, always
        },
        ["flags"] = {
            ["health"] = { ["flag"] = 0, ["enabled"] = true };
        },
        ["predict"] = {
            ["enabled"] = false;
            ["auto predict"] = false;
            ["static value"] = 0.1455;
        }
    }
}

-- // Vars // -- 
local Workspace = game.FindFirstChildOfClass("Workspace")
local Players = game:FindFirstChildOfClass("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Table = getgenv().Astra
local RunService = game:GetService("RunService")
local Target = {}
local Toggle = false
local Camera = Workspace.CurrentCamera;
local Fov = Drawing.new("Circle");
local Inset = game:GetService("GuiService"):GetGuiInset()

Target[1] = nil
Target[2] = nil

function Flags(Plr)
    local Dead = nil

    if Plr and Plr.Character and game.PlaceId == 2788229376 or 7213786345 or 16033173781 or 9825515356 and Table.Triggerbot.flags.health.enabled then
        if Plr.Character:FindFirstChild("BodyEffects") then
            if Plr.Character.BodyEffects:FindFirstChild("K.O") then
                Dead = Plr.Character.BodyEffects["K.O"].Value
            elseif Plr.Character.BodyEffects:FindFirstChild("KO") then
                Dead = Plr.Character.BodyEffects.KO.Value
            end
        end
    elseif Plr and Plr.Character and Plr.Character:FindFirstChild("Humanoid") and Table.Triggerbot.flags.health.enabled then
        if Plr.Character:FindFirstChild("Humanoid").Health > Table.Triggerbot.flags.health.flag then
            Dead = true
        else
            Dead = false
        end
    end
    return Dead
end

function Ping()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    return ping
end

RunService["Heartbeat"]:Connect(function()
    if Table.Aimbot.useFOV then
        Fov.Visible = true
        Fov.Radius = Table.Aimbot.fovSize
        Fov.Color = Color3.new(255, 255, 255)
        Fov.Position = Vector2.new(Mouse.X, Mouse.Y + Inset.Y)
    else
        Fov.Visible = false
    end
end)   

RunService[Table.Triggerbot.threading]:Connect(function()
    if Mouse.Target and Mouse.Target.Parent ~= nil and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent.Name ~= LocalPlayer.Name and Toggle then
        Target[1] = game:GetService("Players"):FindFirstChild(Mouse.Target.Parent.Name)
        if Target[1] and Target[1].Character then
            for _, index in pairs(Target[1].Character:GetChildren()) do
                if Table.Triggerbot.meshparts then
                    if index:IsA("BasePart") and index:IsA("MeshPart") and not Flags(Target[1]) then
                        local PredictedCframe = nil 

                        if Table.Triggerbot.predict.enabled then
                            PredictedCframe = index.CFrame + index.Velocity * Table.Triggerbot.predict['static value']
                        else 
                            PredictedCframe = index.CFrame
                        end

                        if Table.Triggerbot.mode == "all executors" then
                            if PredictedCframe then
                                wait(Table.Triggerbot.delay)
                                VirtualInputManager:SendMouseButtonEvent(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, 0, true, game, 1)
                                wait(Table.Triggerbot.delay)
                                VirtualInputManager:SendMouseButtonEvent(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, 0, false, game, 1)
                                break
                            end
                        elseif Table.Triggerbot.mode == "mouse1click support" then
                            if PredictedCframe then
                                wait(Table.Triggerbot.delay)
                                mouse1click()
                                wait(Table.Triggerbot.delay)
                                break
                            end
                        else
                            error("'Triggerbot Mode' configuration is missing in Astra:")
                        end
                    end 
                else 
                    if index:IsA("BasePart") and not Flags(Target[1]) then
                        local PredictedCframe = nil 

                        if Table.Triggerbot.predict.enabled then
                            PredictedCframe = index.CFrame + index.Velocity * Table.Triggerbot.predict['static value']
                        else 
                            PredictedCframe = index.CFrame
                        end

                        if Table.Triggerbot.mode == "all executors" then
                            if PredictedCframe then
                                wait(Table.Triggerbot.delay)
                                VirtualInputManager:SendMouseButtonEvent(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, 0, true, game, 1)
                                wait(Table.Triggerbot.delay)
                                VirtualInputManager:SendMouseButtonEvent(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, 0, false, game, 1)
                                break
                            end
                        elseif Table.Triggerbot.mode == "mouse1click support" then
                            if PredictedCframe then
                                wait(Table.Triggerbot.delay)
                                mouse1click()
                                wait(Table.Triggerbot.delay)
                                break
                            end
                        else
                            error("'Triggerbot Mode' configuration is missing in Astra:")
                        end
                    end 
                end
            end
        end
    end

    if Table.Triggerbot.enabled and Table.Triggerbot.predict['auto predict'] then
        Table.Triggerbot.predict['static value'] = Ping() / 1000 / 2 + 0.1
    end
end)

function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge  

    for _, player in pairs(Players:GetPlayers()) do  
        if player and player.character and player.Name ~= LocalPlayer.Name and player.Character:FindFirstChild("HumanoidRootPart") then 
            local ScreenPos = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)  
            
            if ScreenPos then
                local distance, onscreen = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if distance <= closestDistance and Table.Aimbot.useFOV ~= true then
                    closestDistance = distance
                    closestPlayer = player
                elseif Fov.Radius >= distance and distance <= closestDistance and Table.Aimbot.useFOV == true then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

RunService[Table.Aimbot.threading]:Connect(function()
    if Target[2] and Target[2].Character then
        local targetPart = Target[2].Character:FindFirstChild(Table.Aimbot.aimbone)
        if targetPart and Table.Aimbot.enabled then
            if Table.Aimbot.mode == "mouse" then
                local ScreenPos = Camera:WorldToScreenPoint(targetPart.Position)
                local deltaX = (ScreenPos.X - Mouse.X) * Table.Aimbot.strength
                local deltaY = (ScreenPos.Y - Mouse.Y) * Table.Aimbot.strength
                mousemoverel(deltaX, deltaY)
            elseif Table.Aimbot.mode == "camera" then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), Table.Aimbot.strength)
            end
        end
    end
end)

local Toggle2 = false;
local Toggle3 = false;

UserInputService.InputBegan:Connect(function(input, Processed)
    if (Processed) then
        return (nil)
    end
 
    if (input.KeyCode == Enum.KeyCode[Table.Triggerbot.bind.key] and Table.Triggerbot.enabled) then
        if (Table.Triggerbot.bind.Mode == "hold") then
            Toggle2 = true
        elseif (Table.Triggerbot.bind.mode == "toggle") then
            Toggle2 = not Toggle2
        end
        
        if Toggle2 then
            Toggle = true;
        else
            Toggle = false;
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, Processed)
    if (Processed) then
        return nil
    end
 
    if (input.KeyCode == Enum.KeyCode[Table.Aimbot.bind.key] and Table.Aimbot.enabled) then
        if (Table.Aimbot.bind.mode == "hold") then
            Toggle3 = true
        elseif (Table.Aimbot.bind.mode == "toggle") then
            Toggle3 = not Toggle3
        end
        
        if Toggle3 then
            Target[2] = GetClosestPlayer()
        else
            Target[2] = nil
        end
    end
end)    
