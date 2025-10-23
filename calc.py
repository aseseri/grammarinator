import sys

def main():
    """
    A simple (and very insecure) calculator program
    that reads an expression from a file and evaluates it.
    """
    if len(sys.argv) != 2:
        print("Usage: python calc.py <input_file>")
        return

    input_file = sys.argv[1]

    try:
        with open(input_file, 'r') as f:
            expression = f.read()

            # --- THIS IS THE VULNERABLE PART ---
            # We are fuzzing the 'eval' function.
            # 'eval' will execute any string as Python code.
            # ------------------------------------
            
            if not expression:
                print("Input file is empty.")
                return

            print(f"Evaluating: '{expression.strip()}'")
            
            # Using eval() is dangerous, which makes it a
            # perfect target for fuzzing.
            result = eval(expression)
            
            print(f"Result: {result}")

    except ZeroDivisionError:
        print("!!! CRASH (Semantic): Division by zero! !!!")
        exit(1)
    except SyntaxError:
        print("!!! ERROR (Syntactic): Invalid syntax. (Grammarinator shouldn't produce this!) !!!")
        exit(1)
    except Exception as e:
        # This is what we are looking for!
        # A "catch-all" for other crashes.
        print(f"!!! CRASH (Other): {type(e).__name__}: {e} !!!")
        exit(1)

if __name__ == "__main__":
    main()