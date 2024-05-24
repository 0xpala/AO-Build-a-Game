-- Pacman Game
-- Importing essential modules
local json = require("json")

-- Global Variables and Setup
GameStatus = "Not-Started"
WaitDuration = 150000 -- 2.5 minutes in milliseconds
GameDuration = 900000 -- 15 minutes in milliseconds
CurrentTime = 0 -- This will be updated with the actual time

CurrencyToken = "PAC"  -- Currency used in the game
DepositAmount = 2  -- Amount of PAC coins required for participation
MinimumPlayers = 3

PlayersData = {}
WaitingList = {}

-- Function to roll a dice
function rollDice()
    return math.random(1, 6)
end

function initialize()
    GameStatus = "Not-Started"
    PlayersData = {}
    WaitingList = {}
end

function startWaiting()
    GameStatus = "Waiting"
    CurrentTime = os.time() * 1000 -- Update current time in milliseconds
    print("The game is starting soon! Please deposit " .. DepositAmount .. " " .. CurrencyToken .. " to join.")
end

function checkStart()
    if #WaitingList >= MinimumPlayers then
        commenceGame()
    else
        print("Insufficient players! Waiting for more...")
    end
end

function commenceGame()
    GameStatus = "Playing"
    CurrentTime = os.time() * 1000 -- Update current time in milliseconds
    for playerId, _ in pairs(WaitingList) do
        PlayersData[playerId] = {position = 1, score = 0}
        WaitingList[playerId] = nil -- Remove player from waiting list
    end
    print("Game has started. Best of luck to all participants!")
end

-- Function for player movement based on dice roll
function move(playerId)
    local player = PlayersData[playerId]
    if not player then
        print("Player not found.")
        return
    end

    local diceRoll = rollDice()
    print("Player " .. playerId .. " rolled a " .. diceRoll)

    -- Check for a 6 on the dice
    if diceRoll == 6 then
        print("Player " .. playerId .. " rolled a 6 and gets another turn!")
        move(playerId)  -- Recursive call for another turn
        return
    end

    -- Move the player
    local newPosition = player.position + diceRoll
    player.position = newPosition

    -- Check if the player reached the final position
    if newPosition >= 100 then
        endRound(playerId)
    end
end

function checkEnd()
    if GameStatus ~= "Playing" then return end

    local currentTime = os.time() * 1000
    if currentTime >= (CurrentTime + GameDuration) then
        endRound(nil)  -- Game over due to time expiration
    end
end

function endRound(winnerId)
    print("Game Over")

    -- Calculate and distribute rewards
    local totalCoins = 0
    for playerId, player in pairs(PlayersData) do
        totalCoins = totalCoins + DepositAmount  -- Add deposited coins by each player
        if playerId == winnerId then
            distributeReward(winnerId, totalCoins, "Winning the game")
        end
    end

    initialize() -- Restart the game
end

-- Function to distribute rewards to a player.
-- @param recipient: The player receiving the reward.
-- @param qty: The quantity of the reward.
-- @param reason: The reason for the reward.
function distributeReward(recipient, qty, reason)
    -- Implement reward distribution logic here
    print("Rewarding player " .. recipient .. ": " .. qty .. " " .. CurrencyToken .. " for " .. reason)
end

-- Player registration and payment handling
function enrollPlayer(playerId)
    if GameStatus ~= "Waiting" then
        print("Cannot enroll player, game is not in waiting mode.")
        return
    end

    WaitingList[playerId] = true
    print("Player " .. playerId .. " has been enrolled in the game.")
end

function withdrawPlayer(playerId)
    if GameStatus ~= "Waiting" then
        print("Cannot withdraw player, game is not in waiting mode.")
        return
    end

    WaitingList[playerId] = nil
    print("Player " .. playerId .. " has been withdrawn from the game.")
end

-- Main game loop
function gameLoop()
    checkEnd()
end

-- Initialize the game
initialize()
startWaiting()
