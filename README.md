# mathpuzzles

A maths puzzle is a square grid of squares, each to be filled in with
a single digit 1–9 (zero is not permitted) satisfying these 3 constraints:

 1. Each row and each column contains no repeated digits;
 2. All squares on the diagonal line from upper left to lower right
    contain the same value; and
 3. The heading of each row and column (leftmost square in a row and 
    topmost square in a column) holds either the sum or the product of 
    all the digits in that row or column.

A proper maths puzzle will have at most one solution.

Here is an example puzzle as posed (left) and solved (right):

    |    | 14 | 10 | 35 |    |    | 14 | 10 | 35 |
    |----|----|----|----|    |----|----|----|----|
    | 14 | _  | _  | _  | -> | 14 | 7  | 2  | 1  |
    | 15 | _  | _  | _  |    | 15 | 3  | 7  | 5  |
    | 28 | _  | 1  | _  |    | 28 | 4  | 1  | 7  |

A maths puzzle is represented as a list of lists, each of the
same length, representing a single row of the puzzle. The first element
of each list is considered to be the header for that row. Each element
but the first of the first list in the puzzle is considered to be the
header of the corresponding column of the puzzle. The first element
of the first element of the list is the corner square of the puzzle,
and thus is ignored.

For example, the program would solve the above puzzle as below:

```
?- Puzzle=[[0, 14, 10, 35], [14, _ , _, _], [15, _, _, _], [28, _, 1, _]],
|  puzzle_solution(Puzzle).

Puzzle = [[0, 14, 10, 35], [14, 7, 2, 1], [15, 3, 7, 5], [28, 4, 1, 7]] ;
false.
```
