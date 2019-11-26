:- [layout].

maze_0() :- load_layout(maze_0).
maze_1() :- load_layout(maze_1).

empty(C) :- not(at(C, _)).

visible(C, C, _) :- not(at(C, wall)).
visible(C1, C3, D) :- adjacent(C2, D, C3), not(at(C2, wall)), visible(C1, C2, D).

reachable(C, C, []) :- not(at(C, wall)).
reachable(C1, C3, [D|Ds]) :- adjacent(C1, D, C2), not(at(C1, wall)), sound_path(Ds), reachable(C2, C3, Ds).

goalachivement() :- not(at(_, ghost)), at(_, capsule),  at(_, food),  at(_, pacman).

% empty(cell(2, 9)).
% empty(cell(2, 8)).
% visible(cell(1, 1), cell(1, 7), X).
% visible(cell(1, 1), cell(1, 10), X).
% adjacent(cell(1, 9), X, cell(1, 10)).
% reachable(cell(1, 9), cell(1, 10), X).
% reachable(cell(1, 1), cell(5, 18), X).

sound_path([]).
sound_path([north]).
sound_path([east]).
sound_path([south]).
sound_path([west]).
sound_path([D1, D2|Ds]) :- redundant(D1, D2), sound_path([D2|Ds]).

redundant(D1, D2) :- not((D1 = south, D2 = north)), not((D2 = south, D1 = north)), not((D1 = east, D2 = west)), not((D2 = east, D1 = west)).

% path(C, C, _) :- (not(at(C, wall))).
% path(C1, C2, [C1, C2]) :- adjacent(C1, _, C2).
% path(C1, C3, Cs) :- append(Cs,[C1], C), adjacent(C1, _, C2), not(member(C2, C)), path(C2, C3, C).

reach_proxy(C1,C2,D) :- reach(C1,C2,D,[]).
reach(C1,C2,[D], _) :- adjacent(C1,D,C2), (at(C2, E), E \= wall; empty(C2)).
reach(C1,C2,[D|Ds],P) :- append(P,[C1],Ps), adjacent(C1,D,CM), not(member(CM,Ps)), (at(CM, E), E \= wall; empty(CM)), reach(CM,C2,Ds,Ps).

reach_proxy(C1,C2) :- reach(C1,C2,[]).
reach(C1,C2, _) :- adjacent(C1,D,C2), (at(C2, E), E \= wall; empty(C2)).
reach(C1,C2,P) :- append(P,[C1],Ps), adjacent(C1,_,CM), not(member(CM,Ps)), (at(CM, E), E \= wall; empty(CM)), reach(CM,C2,Ps).reach_proxy(C1,C2,D) :- reach(C1,C2,D,[]).

