#David Oltra Sanz & Diana Bachynska - Grupo 3CO21

import json
import numpy as np
import math
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from agentspeak import Actions
from agentspeak import grounded
from pygomas.agents.bditroop import BDITroop
from pygomas.agents.bdisoldier import BDISoldier
from pygomas.agents.bditroop import BDITroop
from pygomas.agents.bdimedic import BDIMedic
from pygomas.ontology import Belief
from agentspeak.stdlib import actions as asp_action

class BDISoldierAIN(BDISoldier):

       def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
        @actions.add_function(".esquina_cercana", (tuple,tuple,))
        def _esquina_cercana(pos,esq):
            minim = 1000; 
            pos = list(pos)
            closest_esq = None
            for i in range(5):
                dist = np.sum(np.absolute(np.subtract(pos,esq[i])))
                if minim > dist: 
                    minim = dist
                    closest_esq = esq[i]
                   
            return closest_esq
            
 
