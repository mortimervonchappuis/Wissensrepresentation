/** 

vis

Module to execute a given action sequence (in the form of a situation
term) generated by Golog in the visualization of the Berkeley Pacman
game. To be used in the 3rd lab assignment of the course 'Knowledge
Representation and High-Level Control' in WS 2018/2019 at FH Aachen.

@author Jens Claßen (j.classen@fh-aachen.de)

**/
:- module(vis, [execute/2]).

execute(S,Layout) :-
        situation2list(S,Seq),
        atomic_list_concat(['sequence=',Seq],List),
        process_create(path('python2'), 
                       ['pacman.py',
                        '--layout',
                        Layout,
                        '--ghosts',
                        'StaticGhost',
                        '--pacman',
                        'ListAgent',
                        '-a',
                        List],
                       [%stdout(null),    
                        %stderr(null),
                        process(PID)]),   % need PID for exit status
        process_wait(PID, _Status), !.

situation2list(s0,'').
situation2list(do(move(Dir),S),Seq) :-
        situation2list(S,Seq1),
        mapdir(Dir,C),
        atomic_list_concat([C,Seq1],' ',Seq).
situation2list(do(stop,S),Seq) :-
        situation2list(S,Seq1),
        atomic_list_concat([x,Seq1],' ',Seq).

mapdir(west,w).
mapdir(east,e).
mapdir(south,s).
mapdir(north,n).
