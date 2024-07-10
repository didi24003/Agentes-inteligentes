#David Oltra Sanz & Diana Bachynska - Grupo 3CO21

import json
import numpy as np
import math
import random
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from agentspeak import Actions
from agentspeak import grounded
from pygomas.agents.bditroop import BDITroop
from pygomas.agents.bdisoldier import BDISoldier
from pygomas.agents.bditroop import BDITroop
from pygomas.agents.bdifieldop import BDIFieldOp
from pygomas.agents.bdimedic import BDIMedic
from pygomas.ontology import Belief
from agentspeak.stdlib import actions as asp_action



class MyMedic(BDIMedic):

	def add_custom_actions(self, actions):
		super().add_custom_actions(actions) 
			
		@actions.add_function(".is_friend_in_shoot", (tuple, tuple, tuple, ))      
		def _is_friend_in_shoot(agPos, enePos, friPos): 
			'''
			Recibe parametro: la posición del agente, la posición del enemigo y la posición del amigo
			
			return: devuelve True si el amigo está en la linea de fuego, False si no lo está.			
			'''
			vecOrigen = [0,0];   #vector origen 
			agVec = [agPos[0], agPos[2]]; #posicion del agente
			eVec = [enePos[0] - agVec[0], enePos[2] - agVec[1]];  #posicion del enemigo
			fVec = [friPos[0] - agVec[0], friPos[2] - agVec[1]];  #posicion del amigo 
			distF = dist(vecOrigen, fVec); #calcula la distancia entre el agente y el amigo 
			if (distF < 0.05 * 50): return True; #si la dist agente-amigo es menor que 2.5 significa que el amigo está cerca
			cosAngulo = (eVec[0] * fVec[0] + eVec[1] * fVec[1]) / (module(eVec) * module(fVec)) 
			cosAlpha = max(-1, min(1, cosAngulo))
			angulo = math.acos(cosAlpha) #calculo el ángulo entre el enemigo y el amigo 
			if (angulo  < math.pi / 12): return True #si el ángulo es menor que 15 grados, el amigo está en la linea de fuego
			else: return False 

		@actions.add_function(".puedoIR", (tuple, tuple, ))
		def _puedoIR(miPos, posFlag):
			'''
			Recibe parametro: la posición a la que quiere ir el agente y la posición de la bandera
			
			return: devuelve la posición a la que quiere ir el agente si es posible, si no, devuelve la posición de la bandera.			
			'''
			X, Y, Z = miPos
			if self.map.can_walk(X,Z): return miPos
			else: return posFlag
		    
		    
class MyField(BDIFieldOp):

	def add_custom_actions(self, actions):
		super().add_custom_actions(actions)
		
		@actions.add_function(".is_friend_in_shoot", (tuple, tuple, tuple, ))      
		def _is_friend_in_shoot(agPos, enePos, friPos): 
			'''
			Recibe parametro: la posición del agente, la posición del enemigo y la posición del amigo
			
			return: devuelve True si el amigo está en la linea de fuego, False si no lo está.			
			'''

			vecOrigen = [0,0];   #vector origen 
			agVec = [agPos[0], agPos[2]]; #posicion del agente
			eVec = [enePos[0] - agVec[0], enePos[2] - agVec[1]];  #posicion del enemigo
			fVec = [friPos[0] - agVec[0], friPos[2] - agVec[1]];  #posicion del amigo 
			distF = dist(vecOrigen, fVec); #calcula la distancia entre el agente y el amigo 
			if (distF < 0.05 * 50): return True; #si la dist agente-amigo es menor que 2.5 significa que el amigo está cerca
			cosAngulo = (eVec[0] * fVec[0] + eVec[1] * fVec[1]) / (module(eVec) * module(fVec)) 
			cosAlpha = max(-1, min(1, cosAngulo))
			angulo = math.acos(cosAlpha) #calculo el ángulo entre el enemigo y el amigo 
			if (angulo  < math.pi / 12): return True #si el ángulo es menor que 15 grados, el amigo está en la linea de fuego
			else: return False 

		@actions.add_function(".puedoIR", (tuple, tuple, ))
		def _puedoIR(miPos, posFlag):
			'''
			Recibe parametro: la posición a la que quiere ir el agente y la posición de la bandera
			
			return: devuelve la posición a la que quiere ir el agente si es posible, si no, devuelve la posición de la bandera.			
			'''		
			X, Y, Z = miPos
			if self.map.can_walk(X,Z): return miPos
			else: return posFlag

			
		
class MySoldado(BDISoldier):
	def add_custom_actions(self, actions):
		super().add_custom_actions(actions)
		
		@actions.add_function(".formacionFlag", (tuple))
		def _formacionFlag(posFlag):
			'''
			Recibe parametro: La posicición de la bandera.
			
			return: la lista de posibles puntos a patrullar alrededor de la bandera.
			'''
			radiusCircle = 30 #distancia de los puntos a la bandera

			pto_A = [posFlag[0] - radiusCircle ,posFlag[1], posFlag[2]]
			pto_B = [posFlag[0], posFlag[1], posFlag[2] - radiusCircle]
			pto_C = [posFlag[0] + radiusCircle, posFlag[1], posFlag[2]]
			pto_D = [posFlag[0], posFlag[1],posFlag[2] + radiusCircle]
			positions = [tuple(pto_A), tuple(pto_B),tuple(pto_C), tuple(pto_D)]
			positions = random.sample(positions, len(positions))
			return tuple(positions)
			
	
        
		@actions.add_function(".distance_to", (tuple,tuple,))
		def _distancia_to(pos,esq):
			'''
			Recibe parametro: dos tuplas

			return: devuelve la distancia euclidiana entre dos puntos.
			''' 
			pos = list(pos)
			dist = ((pos[0]-esq[0])**2+(pos[2]-esq[2])**2)**0.5   
			return dist
		    
		@actions.add_function(".esMenor", (float,float,))
		def _esMenor(a,b):
			'''
			Recibe parametro: dos números

			return: devuelve 1 si el primer número es menor que el segundo, 0 si no lo es.
			'''
			if a < b:
				return 1
			else:
				return 0
		
		@actions.add_function(".is_friend_in_shoot", (tuple, tuple, tuple, ))      
		def _is_friend_in_shoot(agPos, enePos, friPos): 
			'''
			Recibe parametro: la posición del agente, la posición del enemigo y la posición del amigo

			return: devuelve True si el amigo está en la linea de fuego, False si no lo está.
			'''

			vecOrigen = [0,0];   #vector origen 
			agVec = [agPos[0], agPos[2]]; #posicion del agente
			eVec = [enePos[0] - agVec[0], enePos[2] - agVec[1]];  #posicion del enemigo
			fVec = [friPos[0] - agVec[0], friPos[2] - agVec[1]];  #posicion del amigo 
			distF = dist(vecOrigen, fVec); #calcula la distancia entre el agente y el amigo 
			if (distF < 0.05 * 50): return True; #si la dist agente-amigo es menor que 2.5 significa que el amigo está cerca
			cosAngulo = (eVec[0] * fVec[0] + eVec[1] * fVec[1]) / (module(eVec) * module(fVec)) 
			cosAlpha = max(-1, min(1, cosAngulo))
			angulo = math.acos(cosAlpha) #calculo el ángulo entre el enemigo y el amigo 
			if (angulo  < math.pi / 12): return True #si el ángulo es menor que 15 grados, el amigo está en la linea de fuego
			else: return False 
			
		@actions.add_function(".agenteMasCerca", (tuple, tuple))
		def _agente_mas_cercano(posicion, posiciones):
			'''
			Función: elegir  el médico más cercano.

			Recibe dos parametros: la posición de la unidad que solicita la ayuda y la lista de las posiciones de los médicos.

			return: El índice de la posición del médico más cercano en la lista de posiciones.
			'''
			# Inicializamos la distancia mínima a un número muy grande
			min_distancia = float('inf')
			indice_medico_mas_cercano = None

			# Recorremos la lista de posiciones
			for i, posicion_medico in enumerate(posiciones):
				# Calculamos la distancia euclidiana (ignorando la componente Y)
				distancia = math.sqrt(math.pow(posicion_medico[0] - posicion[0], 2) + math.pow(posicion_medico[2] - posicion[2], 2))

				# Si la distancia es menor que la distancia mínima actual, actualizamos la distancia mínima y el índice del médico más cercano
				if distancia < min_distancia:
					min_distancia = distancia
					indice_medico_mas_cercano = i

			# Devolvemos el índice de la posición del médico más cercano
			return indice_medico_mas_cercano
		
		@actions.add_function(".comprobar", (tuple, tuple))
		def _comprobar(tupla1, tupla2):
			'''
			Recibe parametro: dos tuplas
			return: devuelve 1 si ambas tuplas tienen elementos, 0 si no los tiene

			'''

			if tupla1 and tupla2:  # Si ambas tuplas tienen elementos
				return 1
			else:  # Si ninguna tupla tiene elementos
				return 0
			
		@actions.add_function(".comprobarGeneral", (tuple))
		def _comprobarGeneral(tupla1):
			'''
			esta función devuelve 1 si la tupla tiene elementos, 0 si no los tiene
			'''	
			if tupla1:  # Si ambas tuplas tienen elementos
				return 1
			else:  # Si ninguna tupla tiene elementos
				return 0
			
			
		@actions.add_function(".flagTaken", ())
		def _flagTaken():
			'''			
			return: devuelve 1 si la bandera está siendo llevada por un agente, 0 si no lo está.		
			'''
			return 1 if self.is_objective_carried else 0
			
		@actions.add_function(".puedoIR", (tuple, tuple, ))
		def _puedoIR(miPos, posFlag):
			'''
			Recibe parametro: la posición a la que quiere ir el agente y la posición de la bandera
			
			return: devuelve la posición a la que quiere ir el agente si es posible, si no, devuelve la posición de la bandera.			
			'''
			X, Y, Z = miPos
			if self.map.can_walk(X,Z): return miPos
			else: return posFlag


def module(vec):
	'''
	esta función calcula el módulo de un vector utilizando la fórmula de la raíz cuadrada de la suma de los cuadrados de las componentes del vector
	'''	
	return math.sqrt(sum(v**2 for v in vec))
    
    
def dist(v1, v2):
	'''
	esta función calcula la distancia euclidiana entre dos vectores
	'''	
	return math.sqrt(sum((v1p - v2p)**2 for v1p, v2p in zip(v1, v2)))
		    
