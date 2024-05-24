
BotName = "GuessingBot"
local targetNumber = math.random(1, 100)  -- Random number to guess (1-100)
local guessNumber = 0  -- Bot's current guess
local attempts = 0  -- Number of attempts made
local stopNumber = 5  -- Maximum number of attempts
local runStatus = 'disable'
local totalPlayers = 0  -- Initialize player count to 0
local maxPlayers = 20  -- Maximum number of players allowed
local GameTarget = '7WTand2sxu1x_9bepuWfeJNmQLA0dx88CkRnwJpKkDU'

local function sendGuess(number)
  ao.send({
    Target = GameTarget,
    Action = "MakeGuess",
    Data = number,
  })
end

local function finishTurn()
  ao.send({
    Target = GameTarget,
    Action = "FinishTurn",
    Data = BotName,
  })
  attempts = 0
  guessNumber = 0
end

local function log(message)
  print("[Bot Log] " .. message)
end

local function handleSuccess(Msg)
  log('Guess successful! The number was ' .. targetNumber)
  finishTurn()
end

local function handleFailure(hint)
  attempts = attempts + 1
  log('Guess failed. Attempt: ' .. attempts .. ', Hint: ' .. hint)
  if attempts >= stopNumber then
    finishTurn()
    log('Maximum attempts reached.')
  else
    -- Logic to adjust guess based on hint
    if hint == "Higher" then
      guessNumber = guessNumber + math.floor(math.random(1, 10))
    elseif hint == "Lower" then
      guessNumber = guessNumber - math.floor(math.random(1, 10))
    end
    sendGuess(guessNumber)
  end
end

function startRolling()
  runStatus = 'enable'
  targetNumber = math.random(1, 100)  -- Generate new random number
  attempts = 0
  guessNumber = math.random(1, 100)  -- Initial guess
  log('Bot started guessing a number (1-100).')
  -- Check if maximum player limit has been reached
  if totalPlayers >= maxPlayers then
    log('Maximum player limit reached. Cannot start game.')
    return
  end
  -- Increment player count when the game starts
  totalPlayers = totalPlayers + 1
  log('Total players: ' .. totalPlayers)
  sendGuess(guessNumber)
end

function stopRolling()
  runStatus = 'disable'
  log('The bot has finished guessing.')
  -- Decrement player count when the game ends
  totalPlayers = totalPlayers - 1
  log('Total players: ' .. totalPlayers)
end

-- Guess Result Handler
Handlers.add(
  "HandlerMakeGuessResult",
  Handlers.utils.hasMatchingTag("Action", "MakeGuessResult"),
  function(Msg)
    if runStatus == 'disable' then
      return
    end
    if string.match(Msg.Data, "Success") then
      handleSuccess(Msg)
    else
      local hint = string.match(Msg.Data, "(Higher|Lower)")
      handleFailure(hint)
    end
  end
)

-- Your Turn Handler for Bot
Handlers.add(
  "HandlerYourTurn",
  Handlers.utils.hasMatchingTag("Action", "YourTurn"),
  function(Msg)
    if runStatus == 'enable' then
      log("Bot's turn to guess.")
      -- Already sending guess in startRolling function
    end
  end
)
