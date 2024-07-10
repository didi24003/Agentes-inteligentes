//David Oltra Sanz & Diana Bachynska - Grupo 3CO21

//TEAM_AXIS

+flag (F): team(200) 
  <-
  .create_control_points(F,10,3,C);
  +control_points(C);
  .length(C,L);
  +total_control_points(L);
  .nth(0,C,X);
  //.goto(X);
  +patrolling;
  +patroll_point(0);
  .print("Got control points"). 

+helpmeproposal(Pos)[source(A)]: not(ayudando(_,_)) 
  <-
  ?position(MiPos);
  .print("recibida propuesta de ayuda");
  .send(A, tell, mybid(MiPos));
  +ayudando(A, Pos);
  -helpmeproposal(_);
  .print("enviada propuesta de ayuda").


+acceptproposal(Position)[source(A)]: ayudando(A, Position)
  <-
  .print("Me voy a ayudar al agente a la posicion: ", Position);
  -patrolling;
  ?position(Pos);
  +miposicion(Pos);
  .goto(Position).


+cancelproposal(Position)[source(A)]: ayudando(A,Position)
  <-
  .print("Me cancelan mi proposicion");
  -ayudando(A, Position).


+target_reached(T): ayudando(A, T)
  <-
  .print("MEDPACK!");
  .reload;
  ?miposicion(P);
  .goto(P);
  -ayudando(A, T);
  +patrolling. 


+target_reached(T): patrolling & team(200) 
  <-
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T 
  <-
  ?flag(F);
  ?control_points(C);
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
