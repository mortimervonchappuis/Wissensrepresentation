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

% Primitive control actions

primitive_action(move(_Dir)).  % Move in direction Dir.
primitive_action(stop).        % Do nothing.

% Definitions of Complex Control Actions


% [YOUR CODE HERE]
% proc(go(Dir),...).
% proc(walk(Path),...).
% proc(eat(Item),...).
% proc(main,...).


% Preconditions for Primitive Actions.


% [YOUR CODE HERE]
% poss(move(Dir),S) :- ...
% poss(stop,S) :- ...


% Successor State Axioms for Primitive Fluents.

% at(C,X,do(A,S)) :- ...
% scared(do(A,S)) :- ...


% [YOUR CODE HERE]


% Initial Situation.

at(C,X,s0) :- at(C,X).
scared(s0) :- fail. % false intially

% Derived predicates from sheet #2, some of which extended with
% situation argument


% [YOUR SOLUTION TO SHEET #2 HERE]
% [Note: Some predicates need situation arguments!]


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
