-- Connect to the game
local GameTarget = "7WTand2sxu1x_9bepuWfeJNmQLA0dx88CkRnwJpKkDU"

-- Join the game
Send({ Target = GameTarget, Action = "JoinGame" })

-- Pac-Man's starting position
local pacman = { x = 5, y = 5 }

-- Movement direction and speed
local direction = "right"
local speed = 0.5 -- Number of squares moved per second

-- Game area dimensions
local width = 20
local height = 20

-- Pellet positions
local pellets = {
    { x = 8, y = 3 },
    { x = 10, y = 8 },
    { x = 15, y = 15 }
}

-- Trap positions
local traps = {
    { x = 3, y = 10 },
    { x = 7, y = 17 },
    { x = 12, y = 5 }
}

-- Score
local score = 0

-- Function to change Pac-Man's movement direction
local function changeDirection(newDirection)
    if newDirection == "up" and direction ~= "down" then
        direction = "up"
    elseif newDirection == "down" and direction ~= "up" then
        direction = "down"
    elseif newDirection == "left" and direction ~= "right" then
        direction = "left"
    elseif newDirection == "right" and direction ~= "left" then
        direction = "right"
    end
end

-- Function to check for pellet collisions
local function checkPelletCollision()
    for i, pellet in ipairs(pellets) do
        if pacman.x == pellet.x and pacman.y == pellet.y then
            table.remove(pellets, i) -- Remove pellet from the list
            score = score + 10 -- Increase score
            break
        end
    end
end

-- Function to check for trap collisions
local function checkTrapCollision()
    for _, trap in ipairs(traps) do
        if pacman.x == trap.x and pacman.y == trap.y then
            print("Trap! Game Over! Score:", score)
            os.exit() -- Exit the game
        end
    end
end

-- Sleep function using socket library
local socket = require("socket")
local function sleep(sec)
    socket.sleep(sec)
end

-- Game loop
local function gameLoop()
    while true do
        -- Pac-Man's movement
        if direction == "right" then
            pacman.x = pacman.x + 1
        elseif direction == "left" then
            pacman.x = pacman.x - 1
        elseif direction == "up" then
            pacman.y = pacman.y - 1
        elseif direction == "down" then
            pacman.y = pacman.y + 1
        end

        -- Check for pellet collisions
        checkPelletCollision()

        -- Check for trap collisions
        checkTrapCollision()

        -- Check if Pac-Man hits the boundaries of the game area
        if pacman.x < 1 or pacman.x > width or pacman.y < 1 or pacman.y > height then
            print("Game Over! Score:", score)
            break
        end

        -- Adjust Pac-Man's speed
        sleep(1 / speed) -- Add sleep to make Pac-Man move at a specific rate
    end
end

-- Start the game
Send({ Target = GameTarget, Action = "GoGoGo" })
