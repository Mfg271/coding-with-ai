# C template for multiple main files

For https://c-programming.aydos.de

Select a C main file and press <kbd>F5</kbd> to start your program. There are two examples for testing: `hello.c` and `pi-estimator.c`.

## Tests

Run the filter regression tests with Bash and `g++`:

```sh
bash tests/filter-by-min-age.sh
```

The script compiles `src/filter-by-min-age.c` as C++17 and checks that rows with missing ages do not crash the program, and that valid rows are still filtered by the minimum age.