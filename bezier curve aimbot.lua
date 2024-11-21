--[[
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                                                                                                      

    ///////////////////////////////
    //  © 2022 - 2023 AstraTools //
    //    All rights reserved    //
    ///////////////////////////////
    // This material may not be  //
    //   reproduced, displayed,  //
    //  modified or distributed  //
    // without the express prior //
    // written permission of the //
    //   the copyright holder.   //
    ///////////////////////////////

	

	{AstraTools} - Features    
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                                                                                                      
    
    {+} Enable And Disable Aimbot
    {+} Highly customizable source
    {+} Non junky code
    {+} Universal
    {+} Bezier Aimbot Curve / Easing 
    {+} Neat visuals + Outlines
    {+} Barely any fps loss
    
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
]]

-- // Vars & Services // --
local V3                    = Vector3.new;
local V2                    = Vector2.new;
local C3                    = Color3.new;
local UserInputService      = game:GetService("UserInputService");
local Inset                 = game:GetService("GuiService"):GetGuiInset()
local Current_Camera        = game:FindFirstChild("Workspace").CurrentCamera; -- // Workspace - Client for rivals support (Workspace is default) // --
local Run_Service           = game:GetService("RunService");
local Local_Player          = game:FindFirstChild("Players").LocalPlayer;
local Players               = game:FindFirstChild("Players") -- // Players - Client for rivals support (Players is default) // --
local Boxes                 = {};
local Target                = nil;
local Toggle                = nil;
local Get_Mouse_Pos         = Local_Player:GetMouse();
local Field_Of_View_Outline = Drawing.new("Circle");
local Field_Of_View         = Drawing.new("Circle");
local WatermarkText         = Drawing.new("Text");
local WatermarkText2        = Drawing.new("Text");

-- // Easier Starting Connections // --
local Connection; Connection = function(ConnectionType, Function) 
    local Connection = ConnectionType:Connect(Function)
    return Connection
end

-- // Field Of View Main Func // --
local Fov; Fov = function()
    if Field_Of_View and Field_Of_View_Outline then
        -- // Circle Properties // --
        Field_Of_View_Outline.Visible   = true
        Field_Of_View_Outline.Thickness = 5
        Field_Of_View_Outline.Radius    = 162
        Field_Of_View_Outline.Color     = C3(0, 0, 0)
        Field_Of_View_Outline.Position  = V2(Get_Mouse_Pos.X, Get_Mouse_Pos.Y + Inset.Y)

        Field_Of_View.Visible           = true
        Field_Of_View.Thickness         = 1
        Field_Of_View.Radius            = 160
        Field_Of_View.Color             = C3(0.486274, 0.725490, 1)
        Field_Of_View.Position          = V2(Get_Mouse_Pos.X, Get_Mouse_Pos.Y + Inset.Y)

        -- // Always try to return something it is a good habit // --
        return Field_Of_View_Outline, Field_Of_View
    end
    -- // Returns nil // --
    return nil
end

-- // Watermark Main Func // --
local Watermark
Watermark = function()
    if WatermarkText and WatermarkText2 then
        -- // Define text properties // --
        WatermarkText.Visible   = true
        WatermarkText.Outline   = true
        WatermarkText.Size      = 14
        WatermarkText.Font      = 2
        WatermarkText.Color     = C3(1, 1, 1)
        WatermarkText.Center    = true 
        WatermarkText.Text      = "Astra"

        WatermarkText2.Visible  = true
        WatermarkText2.Outline  = true
        WatermarkText2.Font     = 2
        WatermarkText2.Size     = 14
        WatermarkText2.Text     = "Tools"
        WatermarkText2.Color    = C3(0.486274, 0.725490, 1)
        WatermarkText2.Center   = true 

        -- // Set position under cursor // --
        local watermarkOffsetY = 30 + Inset.Y
        WatermarkText.Position  = V2(Get_Mouse_Pos.X, Get_Mouse_Pos.Y + watermarkOffsetY)
        WatermarkText2.Position = V2(Get_Mouse_Pos.X, Get_Mouse_Pos.Y + watermarkOffsetY + WatermarkText.Size + 2)

        -- // Always try to return something; it is a good habit // --
        return WatermarkText, WatermarkText2
    end
    -- // Returns nil // --
    return nil
end


-- // Box ESP // --
local BoxEsp
BoxEsp = function()
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= Local_Player and not Boxes[v] then
            -- // Creates New Box // --
            local Box_Outline = Drawing.new("Square")
            local Box = Drawing.new("Square")
            local Health_Bar = Drawing.new("Line")

            Box_Outline.Color = C3(0, 0, 0)
            -- // Caches the Box // --
            Boxes[v] = {Box = Box, Outline = Box_Outline, Health = Health_Bar}
            
            -- // Loop // --
            Run_Service.RenderStepped:Connect(function()
                -- // Checks if the players are available // --
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    local Position, OnScreen = Current_Camera.WorldToScreenPoint(Current_Camera, v.Character.HumanoidRootPart.Position)
                    local Health = v.Character.Humanoid.Health
                    local MaxHealth = v.Character.Humanoid.MaxHealth

                    -- // Checks if the players are on screen and the health is greater than 0 (death check) // --
                    if OnScreen and Health > 0 then
                        Box_Outline.Visible = true
                        Box_Outline.Thickness = 5
                        Box_Outline.Transparency = 1

                        Box.Visible = true
                        Box.Transparency = 1
                        Box.Thickness = 1

                        -- // Set team-based color // --
                        if Local_Player.Team == v.Team then
                            Box.Color = C3(1, 0, 0)
                        else
                            Box.Color = C3(0.486274, 0.725490, 1)
                        end

                        -- // Calculate Sizes // --
                        local Size = V2((v.Character.HumanoidRootPart.Size.X * 1350) / Position.Z, (v.Character.HumanoidRootPart.Size.Y * 3000) / Position.Z)
                        local InnerSize = Size - V2(4, 4) -- Inner box is slightly smaller to fit within outline

                        Box_Outline.Size = Size
                        Box.Size = InnerSize

                        -- // Set Positioning for Boxes // --
                        local Point = V2(Position.X - Size.X / 2, (Position.Y + Inset.Y - Size.Y / 2))
                        local InnerPoint = Point + V2(2, 2) -- Adjusted to center within outline

                        Box.Position = InnerPoint
                        Box_Outline.Position = Point

                        -- // Health Bar Position and Size // --
                        Health_Bar.Visible = true
                        Health_Bar.Color = C3(0, 1, 0)
                        Health_Bar.Thickness = 2

                        -- Calculate health bar height and start from the bottom of the box
                        local HealthBarHeight = Size.Y * (Health / MaxHealth)
                        Health_Bar.From = Point - V2(6, -Size.Y) -- Start at the bottom of the box
                        Health_Bar.To = Point - V2(6, -Size.Y + HealthBarHeight) -- End based on health percentage
                    else
                        -- // Makes the box and health bar non-visible if player is off-screen or dead // --
                        Box.Visible = false
                        Box_Outline.Visible = false
                        Health_Bar.Visible = false
                    end
                else
                    -- // Makes the box and health bar non-visible if player isn't available // --
                    Box.Visible = false
                    Box_Outline.Visible = false
                    Health_Bar.Visible = false
                end
            end)
        end
    end
end

-- // Get Closest Player // --
local GetClosestPlayer; GetClosestPlayer = function()
    local ClosestTarget = nil;
    local MaxDistance   = math.huge;
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v ~= Local_Player and v.Character:FindFirstChild("HumanoidRootPart") then
            -- // Gets distance // --
            local Position = Current_Camera.WorldToScreenPoint(Current_Camera, v.Character.HumanoidRootPart.Position)
            local Distance = (V2(Position.X, Position.Y) - V2(Get_Mouse_Pos.X, Get_Mouse_Pos.Y)).Magnitude
            -- // If the distance is less than math.huge and the field of view radius is greater than the distance // --
            if (Field_Of_View.Radius > Distance and Distance < MaxDistance) then
                MaxDistance = Distance
                ClosestTarget = v
            end
        end
    end
    -- // Returns Result Or Nil // --
    return (ClosestTarget)
end

-- // Quadratic Bezier Formula // --
local QuadraticBezier; QuadraticBezier = function(t, p0, p1, p2)
    return (1-t) ^ 2 * p0 + 2 * (1-t) * t * p1 + t ^ 2 * p2
end

-- // Keybind // --
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end
    if input.KeyCode == Enum.KeyCode["E"] then -- // Replace this with your own BIND // --
        Toggle = not Toggle
        if Toggle then
            Target = GetClosestPlayer()
        else
            Target = nil
        end
    end
end)

-- // Main Aimbot Func // --
local Aimbot; Aimbot = function()
    if Target and Target.Character and Target.Character:FindFirstChild("Head") and Target.Character:FindFirstChild("Humanoid") then
        -- // Vars // --
        local Health = Target.Character.Humanoid.Health
        local Position = Target.Character.Head.Position
        -- // Endpoint // --
        local BezierPoint = QuadraticBezier(0.0001, Current_Camera.CFrame.Position, Current_Camera.CFrame.Position + Position, Position)
        -- // Checks if health is greater than 0 // --
        if Health > 0 then
            Current_Camera.CFrame = CFrame.new(BezierPoint, Position)
        else
            -- // if its not it'll return nil // --
            return nil
        end
    else
        -- // If the target is not available then return nil // --
        return nil
    end
end

-- // Runs Box Esp Function // --
BoxEsp()

-- // Makes it so the box goes on new players too // --
Connection(Players.PlayerAdded, function()
    BoxEsp()
end)

Connection(Run_Service.RenderStepped, function() -- // Just Remove the features you want to remove for instance, if I wanted to remove disable the aimbot completely I could just take it out from the connection
    Aimbot();
    Fov();
    Watermark();
end)
