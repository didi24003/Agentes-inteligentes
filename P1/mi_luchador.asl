//David Oltra Sanz & Diana Bachynska - Grupo 3CO21

//NOS_LUCHADOR 


+flag(F): team(200)
  <-
  +puntos_patrulla([[0,0,250],[250,0,0],[0,0,0],[250,0,250]]);
  +estado(0);
  +campear.
 

+target_reached(T): destino_camp
  <-
  -campear;
  -destino_camp;
  +termino_campear;
  .look_at([125,0,125]);
  .print("mirando a: ", [125,0,125]);
  +al_acecho;
  -target_reached(T).

+target_reached(T): dest_centro
<-
  .print("queremos patrullar");
  -dest_centro;
  -target_reached;
  !patrullar.
  

+friends_in_fov(ID,Type,Angle,Distance,Health,Position):health(H) & H >= Health & ammo(A) & A>0 & termino_campear
  <-
  .print("Disparo");
  .shoot(10,Position);
  .look_at(Position); 
  .goto(Position); //le persigo hasta matarlo porque sé que tiene menos vida
  !ir_centro.
  
+friends_in_fov(ID,Type,Angle,Distance,Health,Position):health(H) & (H < Health | ammo(A) & A<=0) & termino_campear
  <-
  -termino_campear;
  +campear.

+friends_in_fov(ID,Type,Angle,Distance,Health,Position): campear //camino_campear
  <-
  .shoot(10,Position).

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): ID==1001 & health(H) & H<50 //salud
    <-
    .goto(Position);
    .wait(5000);
    !patrullar.
   

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): ID==1002 & ammo(A) & A<50 //municion
    <-
    .goto(Position);
    .wait(5000);
    !patrullar.
   

+campear: team(200) 
<-
  +esquina([[230,0,20],[220,0,220], [20,0,20],[20,0,230],[125,0,125]]);
  +destino_camp;
  ?position(P);
  ?esquina(E);
  .esquina_cercana(P,E,D);
  .goto(D);
  +miposicion(D).

 

+al_acecho: team(200) 
<-
  .wait(15000);
  .print("a matar");
  !ir_centro;
  -al_acecho.

+!patrullar: estado(E) & E<4
<-
  ?puntos_patrulla(L);
  .nth(E, L, P);
  .look_at(P);
  .wait(8000);
  -estado(_);
  +estado(E+1);
  !patrullar.
  
+!patrullar: estado(E) & E=4
<-
  -estado(_);
  +estado(0);
  !patrullar.

+!ir_centro: team(200) 
<-
  +dest_centro;
  .goto([125,0,125]).

  

