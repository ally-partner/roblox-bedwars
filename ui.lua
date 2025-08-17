local uis = game:GetService("UserInputService")
local a = {windows={}}

local function make(c,p) local i=Instance.new(c) for k,v in pairs(p)do i[k]=v end return i end

local function dragify(f)
    local d,s,p
    f.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d,s,p=true,i.Position,f.Position end end)
    f.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement and d then
        local m=i.Position-s f.Position=UDim2.new(p.X.Scale,p.X.Offset+m.X,p.Y.Scale,p.Y.Offset+m.Y) end end)
    uis.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
end

function a:window(t)
    local gui=make("ScreenGui",{Parent=gethui and gethui() or game.CoreGui,Name="a-lib"})
    local win=make("Frame",{Parent=gui,BackgroundColor3=Color3.fromRGB(40,70,40),BorderSizePixel=0,Position=UDim2.new(.5,-200,.5,-150),Size=UDim2.new(0,400,0,300)})
    dragify(win)
    local bar=make("TextLabel",{Parent=win,BackgroundColor3=Color3.fromRGB(30,60,30),BorderSizePixel=0,Size=UDim2.new(1,0,0,25),Font=Enum.Font.GothamSemibold,Text=t,TextColor3=Color3.new(1,1,1),TextSize=14})
    local tabs={}

    function win:createtab(n)
        local btn=make("TextButton",{Parent=bar,Size=UDim2.new(0,80,1,0),BackgroundColor3=Color3.fromRGB(30,60,30),TextColor3=Color3.new(1,1,1),Font=Enum.Font.Gotham,TextSize=13,Text=n})
        local frame=make("Frame",{Parent=win,BackgroundColor3=Color3.fromRGB(50,90,50),BorderSizePixel=0,Position=UDim2.new(0,0,0,25),Size=UDim2.new(1,0,1,-25),Visible=false})
        btn.MouseButton1Click:Connect(function() for _,v in pairs(tabs)do v.Visible=false end frame.Visible=true end)
        table.insert(tabs,frame)
        local y=5 local tab={}

        function tab:createbutton(txt,cb)
            local b=make("TextButton",{Parent=frame,BackgroundColor3=Color3.fromRGB(60,100,60),BorderSizePixel=0,Position=UDim2.new(0,5,0,y),Size=UDim2.new(0,120,0,25),Font=Enum.Font.Gotham,Text=txt,TextColor3=Color3.new(1,1,1),TextSize=13})
            b.MouseButton1Click:Connect(cb) y+=30 return b
        end

        function tab:createtoggle(txt,state,cb)
            local b=make("TextButton",{Parent=frame,BackgroundColor3=state and Color3.fromRGB(100,180,100) or Color3.fromRGB(60,100,60),BorderSizePixel=0,Position=UDim2.new(0,5,0,y),Size=UDim2.new(0,120,0,25),Font=Enum.Font.Gotham,Text=txt,TextColor3=Color3.new(1,1,1),TextSize=13})
            local on=state b.MouseButton1Click:Connect(function() on=not on b.BackgroundColor3=on and Color3.fromRGB(100,180,100) or Color3.fromRGB(60,100,60) if cb then cb(on) end end)
            y+=30 return b
        end

        function tab:createslider(txt,min,max,val,cb)
            local l=make("TextLabel",{Parent=frame,BackgroundColor3=Color3.fromRGB(50,90,50),BorderSizePixel=0,Position=UDim2.new(0,5,0,y),Size=UDim2.new(0,120,0,15),Font=Enum.Font.Gotham,Text=txt..": "..val,TextColor3=Color3.new(1,1,1),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left})
            local bar=make("Frame",{Parent=frame,BackgroundColor3=Color3.fromRGB(60,100,60),BorderSizePixel=0,Position=UDim2.new(0,5,0,y+18),Size=UDim2.new(0,120,0,8)})
            local fill=make("Frame",{Parent=bar,BackgroundColor3=Color3.fromRGB(120,200,120),BorderSizePixel=0,Size=UDim2.new((val-min)/(max-min),0,1,0)})
            local drag=false
            bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end end)
            uis.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
            uis.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                local r=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                local v=math.floor(min+(max-min)*r) fill.Size=UDim2.new(r,0,1,0) l.Text=txt..": "..v if cb then cb(v) end end end)
            y+=35 return bar
        end

        return tab
    end

    table.insert(a.windows,win) return win
end

return a
