-- Resource Finding Game
-- PID: 7WTand2sxu1x_9bepuWfeJNmQLA0dx88CkRnwJpKkDU
-- Global variable initialization
local flagCaptured = false
local flagLocation = {x = 0, y = 0} -- Coordinates of the treasure
local players = {} -- Table to store player data
local totalPlayers = 0 -- Total number of players
local activePlayers = 0 -- Number of active players
local scoreTable = {} -- Table to store player scores

-- Credentials and game token
local CRED = "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc"
local GAME = "tm1jYBC0F2gTZ0EuUQKq5q_esxITDFkAG6QEpLbpI9I"

local colors = { red = "\27[31m", green = "\27[32m", reset = "\27[0m", }

-- Initialize maximum number of players
local maxPlayers = 50

-- Initialize arena size
local arenaWidth = 40 -- Width of the map in units
local arenaHeight = 40 -- Height of the map in units

-- Initialize player energy
local playerEnergy = 100 -- Maximum energy points for players

-- Initialize bonus cred for the winner
local bonusCredMultiplier = 0.5 -- Multiplier for bonus cred
local totalGameCred = 0 -- Total cred in the game

-- Function to transfer cred to start the game
local function Send(data)
    -- Mock Send function for testing
    print("Sending data:", data)
end

-- Function to transfer cred to start the game
local function transferCred()
    -- Send command to transfer cred to game
    Send({Target = CRED, Action = "Transfer", Quantity = "10", Recipient = GAME})
end

-- Function to start the game
local function startGame()
    -- Set initial coordinates of the treasure
    flagLocation.x = math.random(arenaWidth)
    flagLocation.y = math.random(arenaHeight)

    -- Assign participants as individuals
    for i = 1, maxPlayers do
        local player = {id = "ao.id" .. i, x = math.random(arenaWidth), y = math.random(arenaHeight), energy = playerEnergy, score = 0}
        table.insert(players, player)
        totalPlayers = totalPlayers + 1
        activePlayers = activePlayers + 1
    end

    -- Print in green color
    print(colors.green .. "The game has started!" .. colors.reset)
    print("Total players: " .. totalPlayers)
    print("Active players: " .. activePlayers)
end

-- Check if player has enough cred to start the game
local function checkPlayerCred()
    -- Assuming the player has enough cred, initiate the transfer and start the game
    transferCred()
    startGame()
end

-- Handler to start the game
local function handleStartGame()
    checkPlayerCred()
end

-- Function to move the player
local function movePlayer(playerID, newX, newY)
    -- Find the player with the matching ID
    for _, player in ipairs(players) do
        if player.id == playerID then
            -- Ensure new coordinates are safe and valid
            if newX >= 0 and newX <= arenaWidth and newY >= 0 and newY <= arenaHeight then
                player.x = newX
                player.y = newY
                -- Deduct energy for moving
                player.energy = player.energy - 1
                -- Update player score
                player.score = player.score + 1
                print("Player " .. playerID .. " moved to (" .. newX .. ", " .. newY .. "). Energy: " .. player.energy .. ", Score: " .. player.score)

                -- Check if the player has captured the flag
                if player.x == flagLocation.x and player.y == flagLocation.y then
                    flagCaptured = true
                    print(colors.green .. "Player " .. playerID .. " has captured the flag!" .. colors.reset)
                    -- Calculate the bonus cred
                    local bonusCred = totalGameCred * bonusCredMultiplier
                    print(colors.green .. "Player " .. playerID .. " wins " .. bonusCred .. " cred!" .. colors.reset)
                    -- End the game
                    return
                end
            else
                print(colors.red .. "New coordinates are not valid for player " .. playerID .. colors.reset)
            end
        end
    end
    print("Total players: " .. totalPlayers)
    print("Active players: " .. activePlayers)
end

-- Handler to move the player
local function handleMovePlayer(playerID, newX, newY)
    movePlayer(playerID, newX, newY)
end

-- Example of how to start the game
handleStartGame()

-- Example of how to move a player
handleMovePlayer("ao.id1", 5, 5)
handleMovePlayer("ao.id2", 10, 10)
handleMovePlayer("ao.id1", flagLocation.x, flagLocation.y)
