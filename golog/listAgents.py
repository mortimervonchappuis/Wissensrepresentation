# ListAgents.py
# -----------------

"""
This file contains a simple agent to control the Berkely Pacman game
by means of a list of directions passed as command line argument.

To be used in the 3rd lab assignment of the course 'Knowledge
Representation and High-Level Control' in WS 2018/2019 at FH Aachen.

author: Jens Classen
"""

from game import Agent
from game import Directions
from game import Actions

class ListAgent(Agent):
    """
    An agent controlled by a list of directions passed as argument.
    """

    def __init__( self, sequence = "" ):

        self.sequence = sequence.split()
        
    def getAction( self, state):

        if self.sequence == []: return Directions.STOP
        
        move = self.sequence.pop()

        if move == "w": return Directions.WEST
        if move == "n": return Directions.NORTH
        if move == "e": return Directions.EAST
        if move == "s": return Directions.SOUTH
        return Directions.STOP
