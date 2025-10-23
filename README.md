# CS 230 Tool Tutorial: Grammarinator

This repository contains a simple demonstration of `grammarinator`, a grammar-based fuzzer, for our CS 230 Software Engineering presentation.

-   **Tool:** `grammarinator`
-   **Target Program:** `calc.py` (A simple, vulnerable calculator)
-   **Grammar:** `tiny_calc.g4` (An ANTLR v4 grammar for the calculator)

## Key Concepts

* **Fuzzer Type:** This is a **black-box** fuzzer. It has no knowledge of the target's internal code or logic (no CFG, no code coverage).
* **Generation Type:** This is a **generation-based** fuzzer. It generates new inputs "from scratch" based on a set of rules (the grammar). It does not mutate existing seeds.
* **"Under the Hood":** `grammarinator` works by building a random **Abstract Syntax Tree (AST)** in memory based on the grammar rules, and then "un-parsing" that tree back into a string to create the test case.

-----

## How to Run This Demo

```bash
# Create and activate a Python virtual environment
python3 -m venv venv
source venv/bin/activate  # (or .\venv\Scripts\activate on Windows)

# Install the required tools
pip install -r requirements.txt

# Run the demo
./run_demo.sh
```

-----

## What This Demo Shows

This demo runs in two stages to show how a fuzzer helps find bugs in both a parser and its grammar specification.

### Part 1: Finding a Grammar Mismatch

The `tiny_calc.g4` file intentionally contains a "bug" in the grammar rule that is too permissive:

```antlr
// This rule allows numbers with leading zeros, like "007"
INT: [0-9]+; // Problem
```

Our `calc.py` parser, however, is stricter and (correctly) rejects numbers with leading zeros.

When you run `./run_demo.sh` for the first time, you will see our `calc.py` parser print **"\!\!\! ERROR (Syntactic): Invalid syntax"** for these inputs. The script will count these as "crashes."

This demonstrates a **mismatch between our grammar (the specification) and our parser (the implementation)**. `grammarinator` helped us find this bug in our *grammar*.

### Part 2: Fixing the Grammar

1.  Open `tiny_calc.g4` in a text editor.
2.  Comment out the "Problem" line and uncomment the "Solution" line:
    ```antlr
    // INT: [0-9]+; // Problem
    INT: '0' | [1-9][0-9]*; // Solution
    ```
3.  Save the file and run `./run_demo.sh` again.

You will see that `grammarinator` only generates valid integers (no leading zeros). All 20 test cases will now be parsed successfully, and the script will report **"Total crashes found: 0"**.

We have now validated our grammar and can proceed with large-scale fuzzing to find *logic* bugs (like division-by-zero, overflows, etc.).
