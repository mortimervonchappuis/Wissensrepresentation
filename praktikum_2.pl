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

goalachivement() :- not(at(_, ghost)), at(_, capsule),  at(_, food),  at(_, pacman).

% empty(cell(2, 9)).
% empty(cell(2, 8)).
% visible(cell(1, 1), cell(1, 7), X).
% visible(cell(1, 1), cell(1, 10), X).
% adjacent(cell(1, 9), X, cell(1, 10)).
% reachable(cell(1, 9), cell(1, 10), X).
% reachable(cell(1, 1), cell(5, 18), X).
