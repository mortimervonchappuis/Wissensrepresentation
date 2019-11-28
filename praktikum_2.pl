:- [layout].

maze_0() :- load_layout(maze_0).
maze_1() :- load_layout(maze_1).

empty(C) :- not(at(C, _)).

trespass(C) :- (at(C, E), not(E = wall); empty(C)).

visible(C, C, _) :- not(at(C, wall)).
visible(C1, C3, D) :- adjacent(C2, D, C3), not(at(C2, wall)), visible(C1, C2, D).

reachable(C1, C2, Ds) :- reach(C1, C2, Ds, []).

reach(C1, C2, [D], _) :- adjacent(C1, D, C2), trespass(C2).
reach(C1, C3, [D|Ds], Ps) :- append(Ps, [C1], Ps_), adjacent(C1, D, C2), not(member(C2, Ps_)), trespass(C2), reach(C2, C3, Ds, Ps_).

goalachivement(A, B, C, D) :- ghost(A), pacman(B) , capsule(C), food(D).

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
