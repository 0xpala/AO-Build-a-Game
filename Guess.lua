-- Initialize variables
local GuessName = "0xpala"   -- Your Name
local stepNumber = 1 -- Initial Guess Step
local stopNumber = 9 -- Stop Guess Number
local runStatus = 'disable'
local currnetNumber = 0
local Guess = '7WTand2sxu1x_9bepuWfeJNmQLA0dx88CkRnwJpKkDU'
local lock = false
local targetNumber = math.random(1, 10) -- Random number between 1 and 10

-- Function to send a guess
local function sendGuess()
    local guess = math.random(1, 10) -- Generate a random guess between 1 and 10
    ao.send({
        Target = Guess,
        Action = "GuessNumber",
        Data = guess
    })
end

-- Function to finish the guess
local function finishGuess()
    ao.send({
        Target = Guess,
        Action = "FinishGuess",
        Data = GuessName
    })
    currnetNumber = 0
    targetNumber = math.random(1, 10) -- Reset target number
end

-- Function to start the guess game
function startGuess()
    runStatus = 'enable'
    sendGuess()
end

-- Function to stop the guess game
function stopGuess()
    runStatus = 'disable'
    print('The bot run finish')
end

-- Handler for guess result
Handlers.add(
    "HandlerGuessNumberResult",
    Handlers.utils.hasMatchingTag("Action", "GuessNumberResult"),
    function(Msg)
        if runStatus == 'disable' then
            return
        end
        if (Msg.Data == "Success") then
            currnetNumber = currnetNumber + 1
            print('Guess Success ' .. currnetNumber)
            if (currnetNumber >= stepNumber) then
                stepNumber = stepNumber + 1
                finishGuess()
            else
                sendGuess()
            end
        else
            currnetNumber = 0
            print('Guess Failed')
            sendGuess()
        end
    end
)

-- Handler for finishing guess
Handlers.add(
    "HandlerFinishGuessResult",
    Handlers.utils.hasMatchingTag("Action", "FinishGuessResult"),
    function(Msg)
        if runStatus == 'disable' then
            return
        end
        print(Msg.Data)
        if stopNumber < stepNumber then
            stopGuess()
            return
        end
        sendGuess()
    end
)

-- Handler for current guess
Handlers.add(
    "HandlerCurrentGuess",
    Handlers.utils.hasMatchingTag("Action", "CurrentGuess"),
    function(Msg)
        print(Msg.Data)
    end
)

-- Handler for rank list
Handlers.add(
    "HandlerRankList",
    Handlers.utils.hasMatchingTag("Action", "RankList"),
    function(Msg)
        print(Msg.Data)
    end
)
