
                   %  THE ELEVATOR CONTROLLER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Try these example queries:
%
% % nondeterministically go to a floor whose call button is on
% ?- do(pi(n,?(on(n)) : goFloor(n)),s0,S).
% S = do(down(3), s0) ;
% S = do(up(5), s0) ;
% false.

% % either turn off a call button or to go to a floor that satisfies the test nextFloor
% ?- do(pi(n, turnoff(n) # ?(nextFloor(n)) : goFloor(n)),s0,S).
% S = do(turnoff(3), s0) ;
% S = do(turnoff(5), s0) ;
% S = do(down(3), s0) ;
% S = do(up(5), s0) ;
% false.

% % call the main controller to serve all floors and then park the elevator
% ?- do(control,s0,S).
% S = do(open,do(down(0),do(close,do(open,do(turnoff(5),do(up(5),do(close,do(open,do(turnoff(3),do(down(3),s0)))))))))) ;
% S = do(open,do(down(0),do(close,do(open,do(turnoff(3),do(down(3),do(close,do(open,do(turnoff(5),do(up(5),s0)))))))))) ;
% S = do(open,do(down(0),do(close,do(open,do(turnoff(5),do(up(5),do(close,do(open,do(turnoff(3),do(down(3),s0)))))))))) ;
% S = do(open,do(down(0),do(close,do(open,do(turnoff(3),do(down(3),do(close,do(open,do(turnoff(5),do(up(5),s0)))))))))) ;
% false.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- discontiguous(currentFloor/2).

% Primitive control actions

primitive_action(turnoff(_N)). % Turn off call button N.
primitive_action(open).        % Open elevator door.
primitive_action(close).       % Close elevator door.
primitive_action(up(_N)).      % Move elevator up to floor N.
primitive_action(down(_N)).    % Move elevator down to floor N.

% Definitions of Complex Control Actions

proc(goFloor(N), ?(currentFloor(N)) # up(N) # down(N)).
proc(serve(N), goFloor(N) : turnoff(N) : open : close).
proc(serveAfloor, pi(n, ?(nextFloor(n)) : serve(n))).
proc(park, if(currentFloor(0), open, down(0) : open)).

/* control is the main loop. So long as there is an active call
   button, it serves one floor. When all buttons are off, it
   parks the elevator.   */

proc(control, while(some(n, on(n)), serveAfloor) : park).

% Preconditions for Primitive Actions.

poss(up(N),S) :- currentFloor(M,S), M < N.
poss(down(N),S) :- currentFloor(M,S), M > N.
poss(open,_S).
poss(close,_S).
poss(turnoff(N),S) :- on(N,S).

% Successor State Axioms for Primitive Fluents.

currentFloor(M,do(A,S)) :- A = up(M) ; A = down(M) ;
              \+ A = up(_N1), \+ A = down(_N2), currentFloor(M,S).

on(M,do(A,S)) :- on(M,S), \+ A = turnoff(M).

% Initial Situation. Call buttons: 3 and 5. The elevator is at floor 4.

on(3,s0).   on(5,s0).   currentFloor(4,s0).

/* nextFloor(N,S) is an abbreviation that determines which of the
   active call buttons should be served next. Here, we simply
   choose an arbitrary active call button.   */

nextFloor(N,S) :- on(N,S).

% Restore suppressed situation arguments.

restoreSitArg(on(N),S,on(N,S)).
restoreSitArg(nextFloor(N),S,nextFloor(N,S)).
restoreSitArg(currentFloor(M),S,currentFloor(M,S)).
