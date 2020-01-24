/**
pacman_template.pl
Template for solution to 3rd lab assignment of the course 'Knowledge
Representation and High-Level Control' in WS 2018/2019 at FH Aachen.
@author Jens Claßen
**/

:- use_module(vis).
:- use_module(layout).

:- [golog].

:- discontiguous(at/3).
:- discontiguous(scared/1).
:- load_layout('maze_0.lay').
% Primitive control actions

primitive_action(move(_D)).  % Move in Dection D.
primitive_action(stop).        % Do nothing.
% Definitions of Complex Control Actions


% [YOUR CODE HERE]
%proc(go(D), ?(at( X , pacman)) # move(D)).
%proc(go(D), P):- P = ( while( poss(move(D)) , move(D)): stop  ).
proc(go(D), while( poss(move(D)) , move(D)) : stop).
proc(walk([]), stop).
proc(walk([D|Ds]), move(D) : walk(Ds)).
proc(eat(Item), if( at(C2, pacman) & at(C1, Item) & ! & reachable(C2, C1, P), walk(P), stop)).


proc(feast_cap, while(some(n, at(n, capsule)), eat(capsule))).
proc(feast_food, while(some(n, at(n, food)), eat(food))).
proc(feast_ghost, while(some(n, at(n, ghost)), eat(ghost))).

proc(cheat, eat(ghost) : eat(ghost) : eat(ghost) : eat(ghost)).
proc(cheaty, feast_cap : cheat : feast_food).
% proc(spam, feast_cap : cheat : if(scared, walk(west), walk(east))).


proc(final, feast_cap : feast_ghost : feast_food).

proc(debug, while(-scared, move(east)) : move(west) : walk([west, west])).



% Preconditions for Primitive Actions.
poss(move(D), S):- at(C, pacman, S), adjacent(C, D, C2), not(at(C2, wall)).
poss(stop, S) :- at(_, pacman, S).

% Successor State Axioms for Primitive Fluents.

at(C1, pacman, do(A, S)):- 
	A = move(D), at(C2, pacman, S), adjacent(C2, D, C1);%, (not(at(C1, ghost)) ; not(scared(S))); 
	A = stop, at(C1, pacman, S).%, not(not(adjacent(C2, D, C1)), at(C2, pacman, S), at(C1, ghost, S), not(scared(S))).
at(C1, X, do(A, S)):- 
	(X = food; X = capsule; X = ghost_), A = move(D), at(C1, X, S), at(C2, pacman, S), not(adjacent(C2, D, C1)); 
	(X = food; X = capsule; X = ghost_), A = stop, at(C1, X, S).
at(C1, ghost, do(A, S)):- 
	A = move(D), at(C1, ghost, S), at(C2, pacman, S), not(adjacent(C2, D, C1)); 
	A = move(D), at(C1, ghost, S), at(C2, pacman, S), adjacent(C2, D, C1), not(scared(S)); 
	not(A = move(_)), at(C1, ghost, S).
scared(do(A, S)) :- 
	A = move(D), at(C1, pacman, S),  at(C2, capsule, S), adjacent(C1, D, C2); 
	scared(S).


% Initial Situation.

at(C, X, s0) :- at(C, X).
%not(scared(s0)).
%scared(s0) :- fail. % false intially

% Derived predicates from sheet #2, some of which extended with
% situation argument


% [YOUR SOLUTION TO SHEET #2 HERE]
% [Note: Some predicates need situation arguments!]


maze_0() :- load_layout(maze_0).
maze_1() :- load_layout(maze_1).

empty(cell(X, Y)) :- not(at(cell(X, Y), _)).
% empty(C) :- not(at(C, _)).

trespass(C) :- (at(C, E), not(E = wall); empty(C)).

visible(C, C, _) :- not(at(C, wall)).
visible(C1, C3, D) :- adjacent(C2, D, C3), not(at(C2, wall)), visible(C1, C2, D).

reachable(C1, C2, Ds) :- reach(C1, C2, Ds, []).

reach(C1, C2, [D], _) :- adjacent(C1, D, C2), trespass(C2).
reach(C1, C3, [D|Ds], Nodes) :- append(Nodes, [C1], Nodes_), adjacent(C1, D, C2), not(member(C2, Nodes_)), trespass(C2), reach(C2, C3, Ds, Nodes_).

goalachievement(A, B, C, D) :- ghost(A), pacman(B) , capsule(C), food(D).

ghost(ghost) :- at(_, ghost).
ghost(no_ghost) :- not(at(_, ghost)).

pacman(pacman) :- at(_, pacman).
pacman(no_pacman) :- not(at(_, pacman)).

capsule(capsule) :- at(_, capsule).
capsule(no_capsule) :- not(at(_, capsule)).

food(food) :- at(_, food).
food(no_food) :- not(at(_, food)).






% empty(cell(2, 9)).
% empty(cell(2, 8)).
% visible(cell(1, 1), cell(1, 7), X).
% visible(cell(1, 1), cell(1, 10), X).
% adjacent(cell(1, 9), X, cell(1, 10)).
% reachable(cell(1, 9), cell(1, 10), X).
% reachable(cell(1, 1), cell(5, 18), X).
% goalachivement(A, B, C, D).


% Restore suppressed situation arguments.

restoreSitArg(at(C, X), S, at(C, X, S)).
restoreSitArg(scared, S, scared(S)).
restoreSitArg(food_left, S, food_left(S)).
restoreSitArg(capsules_left, S, capsules_left(S)).
restoreSitArg(ghosts_left, S, ghosts_left(S)).
restoreSitArg(alive, S, alive(S)).

% Use this predicate to test your procedure
% L = layout file, P = procedure to test
test(L, P) :- load_layout(L), do(P, s0, S), execute(S, L).

:-test('maze_1.lay', debug).