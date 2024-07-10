//David Oltra Sanz & Diana Bachynska - Grupo 3CO21

//TEAM_AXIS

+savemeproposal(Pos)[source(A)]: not(ayudando(_,_)) 
  <-
  ?position(MiPos);
  .print("recibida propuesta de ayuda");
  .send(A, tell, mybid(MiPos));
  +ayudando(A, Pos);
  -savemeproposal(_);
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
  .cure;
  ?miposicion(P);
  .goto(P);
  -ayudando(A, T);
  +patrolling.


+enemies_in_fov(ID,Type,Angle,DistE,Health,PosE): friends_in_fov(IFD,FType,FAngle,DistF,FHealth,PosF) //se activará si hay amigos en el campo de visión
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

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): not(friends_in_fov(FID,FType,FAngle,DistF,Health,PosF))
  <- 
  //.print("no veo amigos");
  .shoot(3,Position);
  .look_at(Position);
  .goto(Position).

+friends_in_fov(FID,FType,FAngle,DistF,FHealth,PosF)
  <-
  -friends_in_fov(FID,FType,FAngle,DistF,FHealth,PosF).
