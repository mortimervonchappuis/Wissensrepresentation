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

primitive_action(move(_Dir)).  % Move in direction Dir.
primitive_action(stop).        % Do nothing.
% Definitions of Complex Control Actions


% [YOUR CODE HERE]
%proc(go(Dir),?(at( X , pacman)) # move(Dir)).
proc(go(Dir), P):- P = ( while( poss(move(Dir)) , move(Dir)): stop  ).
proc(walk([]), stop).
proc(walk([D|Ds]), move(D) : walk(Ds)).
proc(eat(Item), if( at(C2,pacman) & at(C1,Item) & ! & reachable(C2,C1,P)    , walk(P), stop )).
proc(main, while(some(n, at(n,food)), eat(food))).
proc(nain, while(some(n, at(n,capsule)), eat(capsule))).
proc(control,  nain:  while(some(n, at(n, ghost)), eat(ghost)) : main ).
proc(chungus,  nain:  eat(ghost) : eat(ghost) : main ).

% Preconditions for Primitive Actions.
poss(move(Dir),S):- at(C,pacman,S), adjacent(C, Dir, C2), not(at(C2,wall)).
poss(stop,S).

% Successor State Axioms for Primitive Fluents.

at(C,pacman,do(A,S)):- A = move(Dir), at(C2,pacman,S), adjacent(C2,Dir,C); A = stop, at(C,pacman,S).
at(C,ghost,do(A,S)):- A = move(Dir), at(C,ghost,S), at(C2,pacman,S), not(adjacent(C2,Dir,C)); A = move(Dir), at(C,ghost,S), at(C2,pacman,S), adjacent(C2,Dir,C), not(scared(S)) ; A = stop, at(C,ghost,S).
at(C,X,do(A,S)):- (X = food; X = capsule), A = move(Dir),at(C,X,S), at(C2,pacman,S), not(adjacent(C2,Dir,C)); (X = food; X = capsule), A = stop, at(C,X,S).


scared(do(A,S)):- A = move(Dir), at(C1,pacman,S),  at(C2, capsule, S), adjacent(C1, Dir, C2); scared(S).


% Initial Situation.

at(C,X,s0) :- at(C,X).
scared(s0) :- fail. % false intially

% Derived predicates from sheet #2, some of which extended with
% situation argument


% [YOUR SOLUTION TO SHEET #2 HERE]
% [Note: Some predicates need situation arguments!]
% empty(C):- not(at(C,_)).
% 
% reachable(C1,C2,D):- findall(Ds,reach_proxy(C1,C2,Ds),L), b_len(L,EL),min_list(EL,E), index(EL,E,I), index(L,D,I).
% 
% b_len([P],[I]):- length(P,I).
% b_len([P|Ps],[I|Is]):- length(P,I), b_len(Ps,Is).
% 
% index([V|_],V,o).
% index([_|T],V,s(I)):- index(T,V,I).
% 
% reach_proxy(C1,C2,D):- reach(C1,C2,D,[]).
% reach(C1,C2,[D], _):- adjacent(C1,D,C2), (at(C2, E), E \= wall; empty(C2)).
% reach(C1,C2,[D|Ds],P):- append(P,[C1],Ps), adjacent(C1,D,CM), not(member(CM,Ps)), (at(CM, E), E \= wall; empty(CM)), reach(CM,C2,Ds,Ps).
% 
% goal_achieved():- subgoals(0,0,0,1).
% 
% subgoals(F, CAP, G, P):- get_element_list(L), goal(F, CAP, G, P, L).
% 
% goal(F, CAP, G, P, L):- e_i_m(food, L, F), e_i_m(capsule, L, CAP), e_i_m(ghost, L, G), e_i_m(pacman, L, P) .
% 
% get_element_list(L):- findall(E, (in_maze(C), at(C,E)),L).
% 
% e_i_m(EL,L,M):-  once(member(EL,L)), M is 1.
% e_i_m(EL,L,M):-  not(once(member(EL,L))), M is 0.
% 
% 
% 
% :- [layout].

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

restoreSitArg(at(C,X),S,at(C,X,S)).
restoreSitArg(scared,S,scared(S)).
restoreSitArg(food_left,S,food_left(S)).
restoreSitArg(capsules_left,S,capsules_left(S)).
restoreSitArg(ghosts_left,S,ghosts_left(S)).
restoreSitArg(alive,S,alive(S)).

% Use this predicate to test your procedure
% L = layout file, P = procedure to test
test(L,P) :- load_layout(L), do(P,s0,S), execute(S,L).