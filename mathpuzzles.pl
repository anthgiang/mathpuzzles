%% predicate: puzzle_solution(+Puzzle).
%%
%% Author  : Anthony Giang <giang@student.unimelb.edu.au>
%% Purpose : Defines a predicate puzzle_solution/1 that finds a solution
%%           to a math puzzle. 
%%

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

