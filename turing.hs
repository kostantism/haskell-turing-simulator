-- Define types for better code readability
type State = String
type Symbol = Char

-- Directions the head can move: Left, Right, or Stay
data Move = L | R | S deriving (Eq, Show)

-- The Tape is represented as a "zipper" for efficient movement
-- 'left' contains symbols to the left of the head (in reverse order)
-- 'focus' is the symbol currently under the head
-- 'right' contains symbols to the right of the head
data Tape = Tape
  { left  :: [Symbol]
  , focus :: Symbol
  , right :: [Symbol]
  } deriving (Eq, Show)

-- A Transition rule: ((Current State, Current Symbol), (Next State, New Symbol, Movement))
type Transition = [((State, Symbol), (State, Symbol, Move))]

-- Configuration represents the current snapshot of the machine
data Configuration = Configuration
  { currentState :: State
  , tape         :: Tape
  } deriving (Eq, Show)

-- The Turing Machine definition
data Machine = Machine
  { blank       :: Symbol      -- The symbol used for empty tape cells
  , transition  :: Transition  -- The list of transition rules (delta function)
  , startState  :: State       -- The initial state
  , finalStates :: [State]     -- List of states that stop execution (halting states)
  } deriving (Eq, Show)

-- Read the symbol currently under the head
readSymbol (Tape _ f _) = f

-- Update the symbol under the head
writeSymbol s (Tape l _ r) = (Tape l s r)

-- Move the head to the right
moveRight blank (Tape l f []) = Tape (f:l) blank [] -- Extend tape with blank if at the end
moveRight blank (Tape l f (x:xs)) = Tape (f:l) x xs

-- Move the head to the left
moveLeft blank (Tape [] f r) = Tape [] blank (f:r) -- Extend tape with blank if at the start
moveLeft blank (Tape (x:xs) f r) = Tape xs x (f:r)

-- General movement function based on the Move direction
move blank L t = moveLeft blank t
move blank R t = moveRight blank t
move blank S t = t

-- Look up a transition rule in the machine's transition table
searchTransition [] _ _ = Nothing
searchTransition (x:xs) state symbol = 
    if fst (fst x) == state && snd (fst x) == symbol
    then Just (snd x)
    else searchTransition xs state symbol

-- Perform a single computational step
step m (Configuration q t) 
    | elem q (finalStates m) = Nothing -- Stop if current state is a final state
    | otherwise = let s = readSymbol t
                  in case searchTransition (transition m) q s of 
                        Nothing -> Nothing -- Halt if no transition rule is found
                        Just (q', s', mv) ->
                            let t1 = writeSymbol s' t        -- Write new symbol
                                t2 = move (blank m) mv t1    -- Move head
                            in Just (Configuration q' t2)    -- Return new configuration

-- Recursively run the machine and collect all intermediate configurations (the trace)
run m conf = case step m conf of
                Nothing -> [conf]
                Just conf' -> conf : run m conf'

-- Initialize the tape with a blank symbol and an input string
initTape blank [] = Tape [] blank []
initTape blank (x:xs) = Tape [] x xs

-- Create the initial configuration for a machine
initConfig m t = Configuration (startState m) t

-- EXAMPLE 1: Replace all '1's with '0's
replaceOnes = Machine
              { blank = '_'
              , startState = "q0"
              , finalStates = ["qf"]
              , transition =
                  [ (("q0",'1'), ("q0",'0',R))
                  , (("q0",'_'), ("qf",'_',S))
                  ]
              }

t = initTape '_' "1111"
c = initConfig replaceOnes t
trace = run replaceOnes c

-- EXAMPLE 2: Binary Increment (Adds 1 to a binary number)
binaryIncrement = Machine
                  { blank = ' '
                  , startState = "right"
                  , finalStates = ["done"]
                  , transition =
                      [ (("right",'1'), ("right",'1',R)) -- Go to the end of the number
                      , (("right",'0'), ("right",'0',R))
                      , (("right",' '), ("carry",' ',L)) -- Start carrying from the LSB

                      , (("carry",'1'), ("carry",'0',L)) -- 1 + 1 = 0 and carry
                      , (("carry",'0'), ("done",'1',L))  -- 0 + 1 = 1 and finish
                      , (("carry",' '), ("done",'1',L))  -- Blank + 1 = 1 and finish
                      ]
                  }

t1 = initTape ' ' "1011"
c1 = initConfig binaryIncrement t1
trace1 = run binaryIncrement c1

-- EXAMPLE 3: Divisibility by 3 (Check for binary input)
divisibleBy3 = Machine
              { blank = ' '
              , startState = "q0"
              , finalStates = ["accept"]
              , transition =
                  [ (("q0",'0'), ("q0",'0',R))
                  , (("q0",'1'), ("q1",'1',R))
                  , (("q0",' '), ("accept",' ',R)) -- Modulo 0

                  , (("q1",'0'), ("q2",'0',R))
                  , (("q1",'1'), ("q0",'1',R))     -- Modulo 1

                  , (("q2",'0'), ("q1",'0',R))
                  , (("q2",'1'), ("q2",'1',R))     -- Modulo 2
                  ]
              }

t2 = initTape ' ' "1001" 
c2 = initConfig divisibleBy3 t2
trace2 = run divisibleBy3 c2