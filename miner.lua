local chestType = "ironchest:iron_chest"

function welcomeMessage()
    print("Excavation initiating...")
    fuelLevel = turtle.getFuelLevel()
    print("Fuel level:" .. fuelLevel)
end

function isChestBelow()
    local isBlockBelow, data = turtle.inspectDown()
    
    if isBlockBelow then
        if data.name == chestType then
            return true
        end        
    end
    return false    
end

function validateChestBelow()
    if isChestBelow() == false then
        print(chestType .." was not detected below. Exiting...")
        exit()
    else
        print("Correct chest detected below")    
    end

end

function moveToMiningSpot()
    turtle.dig()
    turtle.forward()
end

function dropOffAtChest()
    turtle.back()

    if isChestBelow() then
        print("Dropping off at chest!")
        for i=1, 16 do 
            turtle.select(i)
            turtle.dropDown()
        end
    else
        print("ERROR: Could not detect the drop-off chest.")
    end

end


function digToBottom(blocks)
    local isDiggable = turtle.digDown()
    local hasMoved = false

    if isDiggable then
        blocks = blocks + 1
        hasMoved = turtle.down()
    end

    if hasMoved == true then
        digToBottom(blocks)
    else
        -- we've hit something we can't move into, so terminate this.
        print("Could not dig further. Dug:", blocks)
        goBackUp(blocks)
    end
end

function goBackUp(blocks)
    for i=1, blocks do
        turtle.up()
    end
    print("Returned to the top")
end

function moveForwardAlongX(positions)
    turtle.turnRight()
    for x=0, positions do
        turtle.dig()
        turtle.forward()
    end
    turtle.turnLeft()
end

function moveBackwardAlongX(positions)
    turtle.turnLeft()
    for x=0, positions do
        turtle.dig()
        turtle.forward()
    end
    turtle.turnRight()
end

function digSquare(maxX, maxY)
    for x=0, maxX do
        moveToMiningSpot()
        moveForwardAlongX(x)
        digToBottom(0)
        moveBackwardAlongX(x)
        dropOffAtChest()
        -- need to now get to the starting point 
    end
end

welcomeMessage()
validateChestBelow()

digSquare(3,3)