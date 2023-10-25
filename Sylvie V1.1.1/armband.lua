-- vars
local arm = 0
local counterLeft
local counterRight
assert(config:load("ArmbandIco"), "Config file not found! Remember to put the 'data' folder in your figura folder on the same layer as the avatar one, aka not in it. If you already have a data folder, take the .json out of this avatar upload's folder and put it there, then reload the avatar!")
local armbandIco = textures:read("ArmbandIco", config:load("ArmbandIco") --[[@as string]])


-- autodetect which model is being used

if models.armband_alex then
    --log("alex")
    armbandModel = models.armband_alex
elseif models.armband_steve then
    --log("steve")
    armbandModel = models.armband_steve
else 
    --log("generic")
    armbandModel = models.armband
end

if host:isHost() then
    counterLeft = config:load("armband_counterL" --[[@as number]])-1
    if counterLeft == nil then
        counterLeft = 0
    end
    counterRight = config:load("armband_counterR" --[[@as number]])-1
    if counterRight == nil then
        counterRight = 0
    end
end

-- Add pride emoji textures
local prideEmojisTexSheet = textures:fromVanilla("prideEmojisTexSheet", "figura:textures/font/emojis/pride.png")
local prideEmojiSheetPos = {
    vec(0, 0, 0, 0),
    vec(0, 32, 8, 8),
    vec(32, 24, 8, 8),
    vec(32, 32, 8, 8),
    vec(24, 24, 8, 8),
    vec(24, 32, 8, 8),
    vec(24, 0, 8, 8),
    vec(8, 0, 8, 8),
    vec(24, 16, 8, 8),
    vec(0, 8, 8, 8),
    vec(8, 32, 8, 8),
}

--set models to not visible (change for default settings)

armbandModel.root.LeftElbow.LeftFlag:setVisible(false)
armbandModel.root.RightElbow.RightFlag:setVisible(false)
armbandModel.root.LeftElbow.LeftPan:setVisible(false)
armbandModel.root.RightElbow.RightPan:setVisible(false)
armbandModel.root.LeftElbow.LeftEnby:setVisible(false)
armbandModel.root.RightElbow.RightEnby:setVisible(false)
armbandModel.root.LeftElbow.LeftTrans:setVisible(false)
armbandModel.root.RightElbow.RightTrans:setVisible(false)
armbandModel.root.LeftElbow.LeftLesbian:setVisible(false)
armbandModel.root.RightElbow.RightLesbian:setVisible(false)
armbandModel.root.LeftElbow.LeftRainbow:setVisible(false)
armbandModel.root.RightElbow.RightRainbow:setVisible(false)
armbandModel.root.LeftElbow.LeftAce:setVisible(false)
armbandModel.root.RightElbow.RightAce:setVisible(false)
armbandModel.root.LeftElbow.LeftAroAce:setVisible(false)
armbandModel.root.RightElbow.RightAroAce:setVisible(false)
armbandModel.root.LeftElbow.LeftGay:setVisible(false)
armbandModel.root.RightElbow.RightGay:setVisible(false)
armbandModel.root.LeftElbow.LeftBi:setVisible(false)
armbandModel.root.RightElbow.RightBi:setVisible(false)
armbandModel.root.LeftElbow.LeftPlural:setVisible(false)
armbandModel.root.RightElbow.RightPlural:setVisible(false)

-- action_wheel base page
local armbands = action_wheel:newPage()

function events.ENTITY_INIT()
    if host:isHost() and action_wheel:getCurrentPage() == nil then
        action_wheel:setPage(armbands)
    end
end

-- add more flags here and in the setflag function

local flags = {
    "None",
    "Pan",
    "Non-Binary",
    "Trans",
    "Lesbian",
    "Rainbow",
    "Asexual",
    "Aro/Ace",
    "Gay",
    "Bisexual",
    "Plural",
}

function setflag(arm,flag)
    --log(arm,flag)
    if arm == "Left" then
        armbandModel.root.LeftElbow.LeftPan:setVisible(flag == "Pan")
        armbandModel.root.LeftElbow.LeftEnby:setVisible(flag == "Non-Binary")
        armbandModel.root.LeftElbow.LeftTrans:setVisible(flag == "Trans")
        armbandModel.root.LeftElbow.LeftLesbian:setVisible(flag == "Lesbian")
        armbandModel.root.LeftElbow.LeftRainbow:setVisible(flag == "Rainbow")
        armbandModel.root.LeftElbow.LeftAce:setVisible(flag == "Asexual")
        armbandModel.root.LeftElbow.LeftAroAce:setVisible(flag == "Aro/Ace")
        armbandModel.root.LeftElbow.LeftGay:setVisible(flag == "Gay")
        armbandModel.root.LeftElbow.LeftBi:setVisible(flag == "Bisexual")
        armbandModel.root.LeftElbow.LeftPlural:setVisible(flag == "Plural")
        if host:isHost() then
            config:save("armband_left", flag)
            config:save("armband_counterL", counterLeft+1)
        end
    end
    if arm == "Right" then
        armbandModel.root.RightElbow.RightPan:setVisible(flag == "Pan")
        armbandModel.root.RightElbow.RightEnby:setVisible(flag == "Non-Binary")
        armbandModel.root.RightElbow.RightTrans:setVisible(flag == "Trans")
        armbandModel.root.RightElbow.RightLesbian:setVisible(flag == "Lesbian")
        armbandModel.root.RightElbow.RightRainbow:setVisible(flag == "Rainbow")
        armbandModel.root.RightElbow.RightAce:setVisible(flag == "Asexual")
        armbandModel.root.RightElbow.RightAroAce:setVisible(flag == "Aro/Ace")
        armbandModel.root.RightElbow.RightGay:setVisible(flag == "Gay")
        armbandModel.root.RightElbow.RightBi:setVisible(flag == "Bisexual")
        armbandModel.root.RightElbow.RightPlural:setVisible(flag == "Plural")
        if host:isHost() then
            config:save("armband_right", flag)
            config:save("armband_counterR", counterRight+1)
        end
    end
    
end

function pings.setflag(arm,flag)
    setflag(arm,flag)
end

if host:isHost() then
    -- actions on the wheel
    local cycle_left = armbands:newAction()
    cycle_left:title(("Cycle left (current: "..flags[counterLeft+1]..")"))
    if flags[counterLeft+1] == "None" then
        cycle_left:item("minecraft:structure_void")
    else cycle_left:item(nil)
    end
    cycle_left:color(0.4, 0.5, 0.42)
    cycle_left:hoverColor(204, 255, 229)
    cycle_left:texture(prideEmojisTexSheet, prideEmojiSheetPos[counterLeft+1].x, prideEmojiSheetPos[counterLeft+1].y, prideEmojiSheetPos[counterLeft+1].z, prideEmojiSheetPos[counterLeft+1].w, 3)
    cycle_left:onLeftClick(function ()
        cycleLeft(1)
    end)
    cycle_left:onRightClick(function ()
        cycleLeft(-1)
    end)
    cycle_left:onScroll(function (direction)
        cycleLeft(direction)
    end)

    function cycleLeft(direction)
        counterLeft = (counterLeft + direction) % #flags
        --log(counterLeft,flags[counterLeft+1])
        pings.setflag("Left",flags[counterLeft+1])
        cycle_left:title(("Cycle left (current: %s)"):format(flags[counterLeft+1]))
        cycle_left:texture(prideEmojisTexSheet, prideEmojiSheetPos[counterLeft+1].x, prideEmojiSheetPos[counterLeft+1].y, prideEmojiSheetPos[counterLeft+1].z, prideEmojiSheetPos[counterLeft+1].w, 3)
        if flags[counterLeft+1] == "None" then
            cycle_left:item("minecraft:structure_void")
        else cycle_left:item(nil)
        end
    end


    local cycle_right = armbands:newAction()
    cycle_right:title(("Cycle right (current: "..flags[counterRight+1]..")"))
    if flags[counterRight+1] == "None" then
        cycle_right:item("minecraft:structure_void")
    else cycle_right:item(nil)
    end
    cycle_right:color(0.4, 0.5, 0.42)
    cycle_right:hoverColor(204/255, 255/255, 229/255)
    cycle_right:texture(prideEmojisTexSheet, prideEmojiSheetPos[counterRight+1].x, prideEmojiSheetPos[counterRight+1].y, prideEmojiSheetPos[counterRight+1].z, prideEmojiSheetPos[counterRight+1].w, 3)
    cycle_right:onLeftClick(function ()
        cycleRight(1)
    end)
    cycle_right:onRightClick(function ()
        cycleRight(-1)
    end)
    cycle_right:onScroll(function (direction)
        cycleRight(direction)
    end)

    function cycleRight(direction)
        counterRight = (counterRight + direction) % #flags
        --log(counterRight,flags[counterRight+1])
        pings.setflag("Right",flags[counterRight+1])
        cycle_right:title(("Cycle right (current: %s)"):format(flags[counterRight+1]))
        cycle_right:texture(prideEmojisTexSheet, prideEmojiSheetPos[counterRight+1].x, prideEmojiSheetPos[counterRight+1].y, prideEmojiSheetPos[counterRight+1].z, prideEmojiSheetPos[counterRight+1].w, 3)
        if flags[counterRight+1] == "None" then
            cycle_right:item("minecraft:structure_void")
        else cycle_right:item(nil)
        end
    end

    local hide_flag = armbands:newAction()
    hide_flag:title("Clear all")
    hide_flag:item("minecraft:structure_void")
    hide_flag:onLeftClick(function ()
        counterRight = 0
        counterLeft = 0
        cycleLeft(0)
        cycleRight(0)
    end)
end

-- Init stuff
if host:isHost() then
    if not config:load("armband_right") then
        config:save("armband_right", "None")
    end
    if not config:load("armband_left") then
        config:save("armband_left", "None")
    end
end

setflag("Left",config:load("armband_left"))
setflag("Right",config:load("armband_right"))

-- VVV Action wheel menu stuff - Un-comment this if you want to add this as a page within an action wheel. Adds a back button and a return function that adds a button to a menu that redirects to this wheel page.
-- Where you want to put the action to redirect to this page, add the following:
-- (Parent action wheel page name here):setAction(-1, require("armband"))
local wawa = require("ActionWheelPageConfirmer")
if wawa ~= nil and host:isHost() then
    armbands:newAction()
    :title('Back')
    :item("minecraft:barrier")
    :onLeftClick(function() 
    action_wheel:setPage("Accessories") 
    end)
    return action_wheel:newAction()
    :title("Pride Armbands")
    :texture(armbandIco)
    :onLeftClick(function()
        --store the current active page so that we can set it back as active later
        prevPage=action_wheel:getCurrentPage()
        --set this file's page as active
        action_wheel:setPage(armbands)
    end)
end