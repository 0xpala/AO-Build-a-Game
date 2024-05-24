math.randomseed(os.time()) -- Random seed based on current time

-- Game States
local gameStates = {}
local playerCount = 0

-- Function to create a new game state for a player
local function addPlayerGameState(playerName)
    gameStates[playerName] = {
        treasureLocation = math.random(1, 6),
        currentPosition = 1,
        score = 0
    }
    playerCount = playerCount + 1
end

-- Function to end a player's game
local function endGame(playerName)
    if gameStates[playerName] then
        gameStates[playerName] = nil
        playerCount = playerCount - 1
        print(playerName .. "'s game has ended and their state has been removed.")
    else
        print("No game state found for " .. playerName .. ".")
    end
end

-- Function to evaluate if a message should trigger the handler
local function isNewGameMessage(msg)
    return msg.Action == "PlayerMove" and msg.Direction == "StartGame"
end

-- Handler to start the game for a player
Handlers.add(
    "PlayerMove",
    isNewGameMessage,
    function(msg)
        local playerName = msg.Player
        print(playerName .. " is attempting to start a game.")
        if gameStates[playerName] then
            print("Game already in progress.")
            Send({
                Target = playerName,
                Action = "GameMessage",
                Data = "You already have an active game. Finish it before starting a new one."
            })
        else
            addPlayerGameState(playerName)
            print(playerName .. " has started a game.")
            Send({
                Target = playerName,
                Action = "GameMessage",
                Data = "Game started! Try your luck by typing 'Dig' to find the treasure."
            })
        end
    end
)

-- Function to handle digging for treasure
local function isDigMessage(msg)
    return msg.Action == "PlayerMove" and msg.Direction == "Dig"
end

-- Handler to process a player's dig action
Handlers.add(
    "PlayerMove",
    isDigMessage,
    function(msg)
        local playerName = msg.Player
        local gameState = gameStates[playerName]

        if not gameState then
            Send({
                Target = playerName,
                Action = "GameMessage",
                Data = "You have no active game. Start one by sending 'StartGame' message."
            })
            return
        end

        print(playerName .. " digs for treasure.")

        if gameState.currentPosition == gameState.treasureLocation then
            gameState.score = gameState.score + 1
            Send({
                Target = playerName,
                Action = "GameMessage",
                Data = "Congratulations! You found the treasure!"
            })
            endGame(playerName)
        else
            gameState.currentPosition = gameState.currentPosition % 6 + 1
            Send({
                Target = playerName,
                Action = "GameMessage",
                Data = "Oops! No treasure here. Keep digging!"
            })
        end
    end
)

-- Command to display the current number of players
Commands.add("PlayerCount", function()
    print("Number of players currently playing: " .. playerCount)
end)

-- Command to display the rank list
Commands.add("RankList", function()
    local sortedPlayers = {}
    for playerName, gameState in pairs(gameStates) do
        table.insert(sortedPlayers, { name = playerName, score = gameState.score })
    end
    table.sort(sortedPlayers, function(a, b) return a.score > b.score end)
    print("Rank List:")
    for i, player in ipairs(sortedPlayers) do
        print(i .. ". " .. player.name .. " - Score: " .. player.score)
    end
end)
