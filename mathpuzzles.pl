%% predicate: puzzle_solution(+Puzzle).
%%
%% Author  : Anthony Giang <giang@student.unimelb.edu.au>
%% Purpose : Defines a predicate puzzle_solution/1 that finds a solution
%%           to a math puzzle. 
%%
%% A maths puzzle is a square grid of squares, each to be filled in with
%% a single digit 1–9 (zero is not permitted) satisfying these 3 constraints:
%%
%% 1. Each row and each column contains no repeated digits;
%% 2. All squares on the diagonal line from upper left to lower right
%%    contain the same value; and
%% 3. The heading of each row and column (leftmost square in a row and 
%%    topmost square in a column) holds either the sum or the product of 
%%    all the digits in that row or column.
%%
%% A proper maths puzzle will have at most one solution.
%%
%% Here is an example puzzle as posed (left) and solved (right):
%%
%%    |    | 14 | 10 | 35 |    |    | 14 | 10 | 35 |
%%    |----|----|----|----|    |----|----|----|----|
%%    | 14 | _  | _  | _  | -> | 14 | 7  | 2  | 1  |
%%    | 15 | _  | _  | _  |    | 15 | 3  | 7  | 5  |
%%    | 28 | _  | 1  | _  |    | 28 | 4  | 1  | 7  |
%%
%% A maths puzzle is represented as a list of lists, each of the
%% same length, representing a single row of the puzzle. The first element
%% of each list is considered to be the header for that row. Each element
%% but the first of the first list in the puzzle is considered to be the
%% header of the corresponding column of the puzzle. The first element
%% of the first element of the list is the corner square of the puzzle,
%% and thus is ignored.
%%
%% For example, the program would solve the above puzzle as below:
%%
%% ?- Puzzle=[[0,14,10,35],[14,_,_,_],[15,_,_,_],[28,_,1,_]],
%% |  puzzle_solution(Puzzle
%%
%% Puzzle = [[0, 14, 10, 35], [14, 7, 2, 1], [15, 3, 7, 5], [28, 4, 1, 7]] ;
%% false.


:- use_module(library(clpfd)).  % for use of tranpose/2 predicate.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main predicate

puzzle_solution(Puzzle):-

  /* gets the diagonals in a list.
  must be a square Puzzle. */
  diagonal(-1, Puzzle, [_|T]),  

  /* check if diagonal is all the same. */
  all_same(T),                  

  /* check if the sum or product equals heading.
  Strategy: whenever a square is not bound, 
  generate a number between 1 and 9 inclusive and 
  check if that row/column is valid.*/
  chk_rows_and_cols(Puzzle),    

  /* check if each row contains no repeated digits, 
  and if each column contains no repeated digits. */
  rem_headings(Puzzle, Puz),
  maplist(all_distinct, Puz),
  transpose(Puz, PuzT),
  maplist(all_distinct, PuzT).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% diagonal predicate and its helper predicates

diagonal(_, [], []).
diagonal(N, [H|T], L):-
  N1 is N + 1,
  nth0(N1, H, E),
  append([E], L1, L),
  diagonal(N1, T, L1).

all_same([_]).
all_same([E,E|Es]):-
  all_same([E|Es]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% predicates to loop through rows and columns, and its helper predicates

chk_rows_and_cols([H|T]):-
  chk_all_rows(T),
  transpose([H|T], [_|T1]),
  chk_all_rows(T1).

chk_all_rows([]).
chk_all_rows([E|Es]):-
  (sum(E); prod(E)),    % check if a row is a sum OR a product.
    chk_all_rows(Es).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% row/column sum and product check predicates

sum([H|T]):-
  list_sum(T, Sum),
  H =:= Sum.

list_sum([], 0).
list_sum([E|Es], Sum):-
  ( integer(E)
   -> list_sum(Es, Sum1)
  ; between(1, 9, E),     % generate a number if there is none
  list_sum(Es, Sum1)),
  Sum is E + Sum1. 


prod([H|T]):-
  list_prod(T, Prod),
  H =:= Prod.

list_prod([], 1).
list_prod([E|Es], Prod):-
  ( integer(E)
   -> list_prod(Es, Prod1) 
  ; between(1, 9, E),     % generate a number if there is none
  list_prod(Es, Prod1)),
  Prod is E * Prod1. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  extra helper predicate to get puzzle with no headings

rem_headings([_|T], Puz):-
  transpose(T, [_|T1]),
  transpose(T1, Puz).

