//David Oltra Sanz & Diana Bachynska - Grupo 3CO21

//TEAM_AXIS

+flag (F): team(200)
  <-
  .print("hola");
  !averelGeneral.

  +!averelGeneral
  <-
  +decidiendoGeneral;
  .get_backups.

  
+myBackups(B): decidiendoGeneral
  <-
  .print("Decidiendo General en mybackups");
  ?position(Pos);
  ?name(N);
  ?flag(X);
  .distance_to(Pos, X, D);
  +my_distance(D);
  ?my_distance(D);
  +aux_general(1);
  .wait(2000);
  .print("Posicion: ", Pos, "name:", N, "flag: ", X, "Distancetoflag: ", D);
  .send(B, tell, distForGen(D));
  .wait(3000);
  -myBackups(_);
  ?aux_general(A);
  .print("Soy general?:", A);
  !decideGeneral;
  .wait(2000);
  -decidiendoGeneral;
  .get_service("sirGeneral").
  
 

+distForGen(Z)[source(S)]
  <-
  .print("Estamos en distforgen");
  ?my_distance(D);
  .esMenor(D,Z,R);
  .print("Es menor = ", R);
  +compararAgentes(R);
  !setAuxGeneral.

+!setAuxGeneral: compararAgentes(R) & R>0
  <-
  .print("setAuxGeneral a 0");
  -aux_general(_);
  +aux_general(0);
  ?aux_general(V);
  .print("a ver si es verdad:",V);
  -compararAgentes(_).
 
+!setAuxGeneral: compararAgentes(R) & (R<0 | R==0)
  <-
  .print("No se modifica aux_general");
  -compararAgentes(_).


+!decideGeneral: aux_general(G) & G>0
  <-
  .print("Yo ser Paco Directo");
  -aux_general(_);
  .register_service("sirGeneral");
  +general.

+sirGeneral(L): not(general) & not(solicitandoSalud)
  <-
  ?flag(X);
  //.goto(X);
  !generarPatrulla;
  .print("Mi general es: ", L);
  .comprobarGeneral(L,G);
  if(G = 0){!averelGeneral;}
  -sirGeneral(_).


+sirGeneral(L): general & not(solicitandoSalud)
  <-
  .print("El general soy yo locoo").

+!decideGeneral: aux_general(G) & G<1
  <-
  -aux_general(_).

+health(H): H < 60 & not(solicitandoSalud) & not(general)
  <-
  +solicitandoSalud;
  .print("Mi vida es menor a 60");
  .get_service("sirGeneral").
 

+sirGeneral(L): solicitandoSalud & not(general)
  <-
  .print("existe general y es: ", L);
  ?position(Pos);
  .print("mi posiciones es:", Pos);
  .send(L,tell,llamalosmedicos(Pos)).


+mybid(Pos)[source(A)]: generalDecidiendo & general
  <-
  .print("Recibo propuesta");
  ?bids(B);
  .concat(B, [Pos], B1); 
  -bids(B);
  +bids(B1);
  ?agents(Ag);
  .concat(Ag, [A], Ag1); 
  -agents(Ag);
  +agents(Ag1);
  .print("sigo con la propuesta");
  .print("esto son los bids: ", B1);
  .print("esto son los agents: ", Ag1);
  -mybid(Pos).

+llamalosmedicos(Posicion)[source(S)]: not(generalDecidiendo)
  <-
  +generalDecidiendo;
  +posicionDeCura(Posicion);
  .print("Llamo a los medicos");
  .print("Yo, general, solicito a los médicos su posicion");
  +bids([]);
  +agents([]);
  .get_medics.

+myMedics(M): generalDecidiendo
  <-
  ?posicionDeCura(Posicion);
  .print("Yo, general, tengo medicos y son: ", M);
  .print("la posicion de cura es: ", Posicion);
  .send(M,tell,savemeproposal(Posicion));
  .wait(10000);
  !!elegirmejor(Posicion);
  -myMedics(_).

+!elegirmejor(PosAG): bids(Bi) & agents(Ag)
<-
  .print("Selecciono el mejor: ", Bi, Ag);
  .comprobar(Bi,Ag,C);
  if(C=1) {
  .agenteMasCerca(PosAG, Bi, PosMed); //devuelve el indice 
  .nth(PosMed, Bi, Pos); 
  .nth(PosMed, Ag, A);
  .send(A, tell, acceptproposal(PosAG)); 
  .delete(PosMed, Ag, Ag1);
  .send(Ag1, tell, cancelproposal(PosAG));
  };
  -solicitandoSalud;
  -solicitandoAmmo;
  -generalDecidiendo;
  -bids(_);
  +bids([]);
  -agents(_);
  +agents([]).

+!elegirmejor: not (bids(Bi))
<-
  -solicitandoSalud;
  -solicitandoAmmo;
  -generalDecidiendo;
  .print("Nadie me puede ayudar").


+ammo(A): A < 50 & not(solicitandoAmmo) & not(general)
  <-
  +solicitandoAmmo;
  .print("Mi municion es menor a 50");
  .get_service("sirGeneral").
 

+sirGeneral(L): solicitandoAmmo & not(general)
  <-
  .print("existe general y es: ", L);
  ?position(Pos);
  .print("mi posiciones es:", Pos);
  .send(L,tell,llamalosfieldops(Pos)).


+llamalosfieldops(Posicion)[source(S)]: not(generalDecidiendo)
  <-
  +generalDecidiendo;
  +posicionDeAmmo(Posicion);
  .print("Llamo a los fieldops");
  .print("Yo, general, solicito a los fieldops su posicion");
  +bids([]);
  +agents([]);
  .get_fieldops.

+myFieldops(F): generalDecidiendo
  <-
  ?posicionDeAmmo(Posicion);
  .print("Yo, general, tengo fieldops y son: ", F);
  .print("la posicion de ammo es: ", Posicion);
  .send(M,tell,helpmeproposal(Posicion));
  .wait(5000);
  !!elegirmejor(Posicion);
  -myFieldops(_).


+!generarPatrulla
	<-
	?flag(F);
	.formacionFlag(F, C);
	+control_points(C);
	.length(C, L);
	+total_control_points(L);
	.nth(0,C,X);
	//.goto(X);
	+patrolling;
	+patroll_point(0).

+target_reached(T): patrolling & team(200)
  <-
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T
  <-
  ?control_points(C);
  ?flag(F);
  .nth(P,C,A);
  .look_at(A);
  .puedoIR(A,F,S);
  .goto(S).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  .wait(2000);
  +patroll_point(0).
 
+enemies_in_fov(ID,Type,Angle,DistE,Health,PosE): friends_in_fov(FID,FType,FAngle,DistF,FHealth,PosF) //se activará si hay amigos en el campo de visión
  <-
  ?position(Pos);
  .is_friend_in_shoot(Pos, PosE, PosF, AUX);
  +my_aux(AUX);
  ?my_aux(AUX);
  if (AUX = true) {
  //.print("No puedo disparar");
  }
  if(AUX = false){
  .shoot(3, PosE);
  .look_at(PosE);
  .goto(PosE);
  //.print("Disparando 3 balas al enemigo");
  }
  -enemies_in_fov(ID,Type,Angle,DistE,Health,PosE);
  -friends_in_fov(ID,Type,Angle,DistF,Health,PosF).
  

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): not(friends_in_fov(FID,FType,FAngle,DistF,FHealth,PosF))
  <- 
  //.print("no veo amigos");
  .shoot(3,Position);
  .look_at(Position);
  .goto(Position).

+friends_in_fov(FID,FType,FAngle,DistF,FHealth,PosF)
  <-
  -friends_in_fov(FID,FType,FAngle,DistF,FHealth,PosF).

  
