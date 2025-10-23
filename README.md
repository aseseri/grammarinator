# CS 230 Tool Tutorial: Grammarinator

This repository contains a simple demonstration of `grammarinator`, a grammar-based fuzzer, for our CS 230 Software Engineering presentation.

-   **Tool:** `grammarinator`
-   **Target Program:** `calc.py` (A simple, vulnerable calculator)
-   **Grammar:** `tiny_calc.g4` (An ANTLR v4 grammar for the calculator)

## Key Concepts

* **Fuzzer Type:** This is a **black-box** fuzzer. It has no knowledge of the target's internal code or logic (no CFG, no code coverage).
* **Generation Type:** This is a **generation-based** fuzzer. It generates new inputs "from scratch" based on a set of rules (the grammar). It does not mutate existing seeds.
* **"Under the Hood":** `grammarinator` works by building a random **Abstract Syntax Tree (AST)** in memory based on the grammar rules, and then "un-parsing" that tree back into a string to create the test case.

## How to Run This Demo

### Step 1: Setup

First, clone the repo and set up a virtual environment.

```bash
# Create and activate a Python virtual environment
python3 -m venv venv
source venv/bin/activate  # (or .\venv\Scripts\activate on Windows)

# Install the required tools
pip install -r requirements.txt

# Run the demo
./run_demo.sh