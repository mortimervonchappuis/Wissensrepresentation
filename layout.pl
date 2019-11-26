/** 

layout

Module to load a Pacman maze from a text file as used in the
Berkeley Pacman AI projects. To be used in the 2nd lab assignment
of the course 'Knowledge Representation and High-Level Control'
in WS 2019/20 at FH Aachen.

Calling load_layout(FileName) will assert facts of the form

at(cell(0,0),wall).
at(cell(1,0),wall).
...
at(cell(1,1),wall).
...
at(cell(3,3),food).
...

for wall, food, capsule, ghost, and pacman. The first argument of
cell(_,_) denotes the row, and the second one the column in the grid,
where (0,0) is the top left corner.

Additionally, facts about what cell there are in the maze and
 adjacency among them in the four cardinal directions of the form

in_maze(cell(0,0)).
in_maze(cell(0,1)).
...
adjacent(cell(0,0),east,cell(0,1)).
adjacent(cell(0,0),south,cell(1,0)).
...

will be generated.

print_facts/0 lists the currently asserted facts, delete_facts/0
 deletes them again (facts from a previously loaded maze will be
 deleted when load_layout/1 is called again).

@author Jens Claßen

**/
:- module(layout, [load_layout/1, print_facts/0, delete_facts/0,
                   at/2, in_maze/1, adjacent/3]).
:- dynamic at/2, in_maze/1, adjacent/3.
:- use_module(library(pio)).

% Mapping of ASCII characters to game symbols.
char_symbol(37,wall).     % '%'
char_symbol(46,food).     % '.'
char_symbol(111,capsule). % 'o'
char_symbol(71,ghost).    % 'G'
char_symbol(80,pacman).   % 'P'
%char_symbol(32,free).     % ' ' % free = everything else

% loads a layout file and asserts the corresponding facts
load_layout(File) :- 
        delete_facts,
        phrase_from_file(lines(0),File).

% prints the dynamic facts that have been loaded from the layout file
print_facts :-
        listing(in_maze(_)),
        listing(adjacent(_,_,_)),
        listing(at(_,_)).

% deletes all dynamic facts that have been loaded from a layout file
delete_facts :-
        retractall(in_maze(_)),
        retractall(adjacent(_,_,_)),
        retractall(at(_,_)).

% DCG to parse lines of a file one by one, increasing line index L
lines(_) --> eos, !.
lines(L) --> 
        line(L,0),
        {L1 is L+1},
        lines(L1).

% DCG to parse the characters (index C) in a line (index L)
% asserts corresponding facts about the pacman world,
% using (L,C) as grid coordinates
line(_,_)     --> ( "\n" ; eos ), !.
line(L,C) -->
        [Char],
        {generate_in_maze_fact(L,C),
         generate_adj_facts(L,C),
         generate_at_fact(Char,L,C),
         Cp1 is C+1},
        line(L,Cp1).

% end of string
eos([],[]).

generate_in_maze_fact(L,C) :-
        assert(in_maze(cell(L,C))).

% asserts 'adjacent' fact for cell (L,C)
generate_adj_facts(L,C) :-
        Lm1 is L-1,
        Cm1 is C-1,
        (L \=0 -> (assert(adjacent(cell(L,C),north,cell(Lm1,C))),
                   assert(adjacent(cell(Lm1,C),south,cell(L,C))));
                  true),
        (C \=0 -> (assert(adjacent(cell(L,C),west,cell(L,Cm1))),
                   assert(adjacent(cell(L,Cm1),east,cell(L,C))));
                  true).

% asserts 'at' fact for (L,C) if cell is not empty
generate_at_fact(Char,L,C) :-
        char_symbol(Char,Symbol), !,
        assert(at(cell(L,C),Symbol)).
generate_at_fact(_,_L,_C).
