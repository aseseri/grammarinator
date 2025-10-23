# CS 230 Tool Tutorial: Grammarinator

This repository contains a simple demonstration of `grammarinator`, a grammar-based fuzzer, for our CS 230 Software Engineering presentation.

-   **Tool:** `grammarinator`
-   **Target Program:** `calc.py` (A simple, vulnerable calculator)
-   **Grammar:** `tiny_calc_syntax.g4` and `tiny_calc_logic.g4` (ANTLR v4 grammars for the calculator)

## Key Concepts

* **Fuzzer Type:** This is a **black-box** fuzzer. It has no knowledge of the target's internal code or logic (no CFG, no code coverage).
* **Generation Type:** This is a **generation-based** fuzzer. It generates new inputs "from scratch" based on a set of rules (the grammar). It does not mutate existing seeds.
* **"Under the Hood":** `grammarinator` works by building a random **Abstract Syntax Tree (AST)** in memory based on the grammar rules, and then "un-parsing" that tree back into a string to create the test case.

-----

## The Demo Scenario

This demo is in two parts to show the two primary jobs of a grammar fuzzer.

### Part 1: Finding Grammar Mismatches (Syntactic Bugs)

First, we use the fuzzer to find bugs in our grammar specification.

1.  **Run the first demo script:**
    ```bash
    # Create and activate a Python virtual environment
    python3 -m venv venv
    source venv/bin/activate  # (or .\venv\Scripts\activate on Windows)
    
    # Install the required tools
    pip install -r requirements.txt
    
    ./run_demo_syntax.sh
    ```
2.  **Observe:** You will see the script find "crashes." Our `calc.py` parser correctly prints **"\!\!\! ERROR (Syntactic): Invalid syntax"** because the grammar (`tiny_calc_syntax.g4`) has a bug: it's generating "invalid" numbers with leading zeros (like `007`). This shows a **mismatch between our specification and our parser.**

-----

### Part 2: The In-Class Exercise (Fixing the Grammar)

Now, we fix the grammar bug.

1.  Open `tiny_calc_syntax.g4` in a text editor.
2.  Comment out the "Problem" line and uncomment the "Solution" line:
    ```antlr
    // INT: [0-9]+; // Problem
    INT: '0' | [1-9][0-9]*; // Solution
    ```
3.  Save the file and run the script again:
    ```bash
    ./run_demo_syntax.sh
    ```
4.  **Observe:** All tests now pass, and the script reports **"Total crashes found: 0"**. We have successfully "calibrated" our fuzzer.

-----

### Part 3: Finding Logic Bugs (The Real Goal)

Now that we have a correct grammar, we use it to find real logic bugs in our program. The file `tiny_calc_logic.g4` already includes the grammar fix *and* adds support for multiplication and division.

1.  **Run the second demo script:**
    ```bash
    ./run_demo_logic.sh
    ```
2.  **Observe:** The script will run until it gets "lucky" and generates a test case like `5/0`. You will see a real Python **`ZeroDivisionError`** crash\!

This shows the true purpose of `grammarinator`: finding deep logic bugs by feeding a program millions of syntactically valid but semantically dangerous inputs.

*(Note: You may need to run `run_demo_logic.sh` a few times or increase the `-n 20` test case number to `n -200` to guarantee you hit a division-by-zero crash.)*
