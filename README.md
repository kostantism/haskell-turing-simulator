# Turing Machine Simulator in Haskell

A functional implementation of a **Deterministic Turing Machine (DTM)** written in Haskell. This project provides a robust framework for modeling computational problems and state transitions through the simulation of a Turing Machine's tape and control unit.

## Features

* **Functional Paradigm:** Leverages Haskell's algebraic data types and recursion to model machine logic.
* **Infinite Tape Simulation:** Implements a bi-directional infinite tape using a focused-list structure.
* **Execution Tracing:** Detailed step-by-step observation of the machine's configuration (current state, tape content, and head position).
* **Pre-defined Algorithms:**
    * **Binary Increment:** Adds 1 to any binary number.
    * **Divisibility by 3:** A state-machine logic to check if a binary input is divisible by 3.
    * **Ones Replacement:** A fundamental example of symbol manipulation.

## 🛠 Tech Stack

* **Language:** Haskell
* **Environment:** GHC (Glasgow Haskell Compiler) / GHCi

## Project Structure

The file `turing.hs` contains the entire implementation:
1.  **Core Types:** Definitions for `Tape`, `Symbol`, `State`, `Machine`, and `Configuration`.
2.  **Tape Logic:** Functions for movement (`L`, `R`, `S`) and head operations (`read`/`write`).
3.  **Simulator Engine:** * `step`: Performs a single state transition.
    * `run`: Executes the machine until it reaches a defined `finalState`.

## How It Works

A Turing Machine in this simulator is defined as a record:
* **Blank Symbol:** The character representing empty cells (e.g., `' '` or `'_'`).
* **Start State:** The initial state of the machine.
* **Final States:** A list of states where the machine halts and accepts the input.
* **Transition Function:** A list of rules in the format: `((CurrentState, CurrentSymbol), (NextState, NewSymbol, Direction))`.



## Execution Guide

To run the simulator, ensure you have the Haskell platform installed.

### 1. Load the Simulator
Open your terminal in the project directory and launch GHCi:
```bash
ghci turing.hs