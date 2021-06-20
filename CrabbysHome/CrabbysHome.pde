//proyecto final - Crabby's Home
//panSamantha - seguraElke

import gifAnimation.*;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import ddf.minim.*;
 
Minim minim;
AudioPlayer mE1, mE2, mE3;
AudioSample sfxChoque, sfxStarfish, sfxShoot, sfxHome;

// A reference to our box2d world
Box2DProcessing box2d;

PFont font;

PImage[] animation;
Gif loopingE1;
Gif loopingE3;

long instanteRestart;
int esperaRestart;

PImage E2;
int escenario;

ArrayList<Boundary> paredes;
ArrayList<Boundary> obstaculos;

Surface arco;
Surface inclinada;

ArrayList<Crabby> crabbies;

ArrayList<Windmill> windmills;
Windmill windmill;

Flipper fl;
Flipper fr;

String posHome;
boolean lflip;
boolean rflip;

int puntos;

long keyDown, keyUp;
boolean disparando;

void setup() {
  size(504, 800);
  smooth();
  imageMode(CENTER);
  frameRate(60);
  
  minim = new Minim(this);  
  mE1 = minim.loadFile("mE1.mp3");
  mE2 = minim.loadFile("mE2.mp3");
  mE3 = minim.loadFile("mE3.mp3");
    
  sfxChoque = minim.loadSample("sfxChoque.mp3");
  sfxStarfish = minim.loadSample("sfxStarfish.mp3");
  sfxShoot = minim.loadSample("sfxShoot.mp3");
  sfxHome = minim.loadSample("sfxHome.mp3");
  
  mE1.play();
  mE1.loop();

  E2 = loadImage("E2.png");
  loopingE1 = new Gif(this, "loopingE1.gif"); 
  loopingE3 = new Gif(this, "loopingE3.gif");
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0, -20);
  
  //Paredes
  arco = new Surface(width/2, 255, 250, 180, 360);
  paredes = new ArrayList<Boundary>();
  paredes.add(new Boundary(width/2,height-5,width,10,7, false));
  paredes.add(new Boundary(width-5,height/2,10,height,7, false));
  paredes.add(new Boundary(5,height/2,10,height,7, false));
  //Cañon de disparo
  paredes.add(new Boundary(width-80,height/2+105,10,350,7, false));  
  //Barra delete
  paredes.add(new Boundary(0, height/2+270,2*width-180,10,7, true));
  //Barra secreta
  paredes.add(new Boundary(0, height/2+280,2*width-180,0.1 ,7, false));
  //Barra inclinada
  inclinada = new Surface();
  
  //conchas-obstaculos
  obstaculos = new ArrayList<Boundary>(); 
  obstaculos.add(new Boundary(width-150,150,8,"obstaculo",20));  
  obstaculos.add(new Boundary(width/2.5,350,8,"obstaculo",20));  
  obstaculos.add(new Boundary(50,340,8,"obstaculo",20));
  obstaculos.add(new Boundary(width-170,height/2,8,"obstaculo",20));
  obstaculos.add(new Boundary(width-120,height-240,8,"obstaculo",20));

  //estrellas-obstaculos
  obstaculos.add(new Boundary(width/4,200,8,"estrella",50));
  obstaculos.add(new Boundary(width/2,height-340,8,"estrella",50));
 
  //portal-obstaculos
  obstaculos.add(new Boundary(width/2,height/4,10,"home",-10));
  obstaculos.add(new Boundary(width-130,height-320,10,"home",-10));
  
  //Crabbies
  crabbies = new ArrayList<Crabby>();
  crabbies.add (new Crabby(width-40,height-80,30));
  crabbies.add (new Crabby(width-100,height-80,30));
  crabbies.add (new Crabby(width-150,height-80,30));
  //crabbies.add (new Crabby(width-200,height-80,30));
  //crabbies.add (new Crabby(width-250 ,height-80,30));
  
  //windmills
  windmills = new ArrayList<Windmill>();  
  windmills.add (new Windmill(width-width/3.8, height/2.5, -1));
  windmills.add (new Windmill(width/9, 480, 1));  
  
  //flippers
  fr = new Flipper(width/2 + 70, height - 200, 25, -QUARTER_PI/2, QUARTER_PI, false, 15, 10, 60);
  fl = new Flipper(width/2 - 120, height - 200, 25, -QUARTER_PI/2 - radians(15), QUARTER_PI - radians(20), true, 15, 10, 60);  
  rflip = false;
  
  escenario = 1;
  
  font = createFont("crabbytype.ttf",width/50);
  textFont(font);
  
  disparando = false;
  
  esperaRestart = 16500;
}


void draw() {
  box2d.step();
  
  if (escenario == 1)
    escenario1();
  else if (escenario == 2)
    escenario2();
  else if (escenario == 3)
    escenario3();
}

void escenario1() {    
  loopingE1.loop();
  image(loopingE1, width/2, height/2, width, height);
}

void escenario2() {  
  
  image(E2, width/2, height/2, width, height);
  arco.display();
  inclinada.display();
  
  for (Boundary pared : paredes) {
    pared.display();
  }
  
  for (Boundary obs : obstaculos) {
    obs.display();
  }

  textSize(width/25);
  textAlign(CENTER);
  text("SCORE: "+puntos, width/2, height/7);
  
  for (int i = 0; i < crabbies.size(); i++) {
    crabbies.get(i).display();
    if (crabbies.get(i).done()) {
      crabbies.remove(i);
    }
  } 
 
  for (Crabby crabbie : crabbies) {
    if (crabbie.getActivarPortal()) {
      if (posHome == "a") {
        crabbie.portal(width/2, height/4);   
      }       
      else if (posHome == "b") {
        crabbie.portal(width-130, height-320);    
      }
    }
  }
  
  for (Windmill windmill : windmills) {
    windmill.display();
  }

  fr.display();
  fl.display();
  
  rflip = true;
  lflip = true; 
  
//se acaba el juego
  if (crabbies.size() == 0) {
    escenario = 3;
    instanteRestart = millis();
    mE2.pause();
    mE2.rewind();
    mE3.play();
    mE3.loop();
  }
}

void escenario3() {
  loopingE3.loop();
  image(loopingE3, width/2, height/2, width, height);
  
  textSize(width/12);
  textAlign(CENTER);
  text("YOUR SCORE: "+puntos,  width/2, 2*height/3 + height/10);
  
  if (millis() - instanteRestart > esperaRestart) {
    escenario = 1;
    mE3.pause();
    mE3.rewind();
    mE1.play();
    mE1.loop();
  }
}

void keyPressed() {    
  if (key == 's' && escenario == 1) {
    escenario = 2;
    mE1.pause();
    mE1.rewind();
    mE2.play();
    mE2.loop();
  }
  
  if (keyCode == RIGHT && rflip) {
    fr.reverseSpeed();
    rflip = false;
  }
  
  if (keyCode == LEFT && lflip) {
    fl.reverseSpeed();
    lflip = false;
  }  
  
  if (key == ' ' && escenario == 2) {
    if (disparando == false) {
      keyDown = millis();
      disparando = true;   
    }  
  }
}


void keyReleased( ) {
  if (key == ' ' && escenario == 2) {
    
    keyUp = millis();
    long difeTiempo = keyUp - keyDown;
    float potencia = map(constrain(difeTiempo, 0 , 7000), 0, 7000, 75, 175);    
    crabbies.get(0).shoot(potencia);
    sfxShoot.trigger();
    disparando = false;
  }
  
  if(keyCode == RIGHT && rflip) {
    fr.reverseSpeed();
    rflip = true;
  }
  
  if(keyCode == LEFT && lflip) {
    fl.reverseSpeed();
    lflip = true;
  }
}
  
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();  
  Object o2 = b2.getUserData();
  
  if (o1 == null || o2 == null) {
    return;
  }

  if (o1.getClass() == Crabby.class && o2.getClass() == Boundary.class) {
    Boundary tmpObs = (Boundary) o2;
    Crabby tmpCrabby = (Crabby) o1;
    if (tmpObs.getId().equals("obstaculo")){      
       puntos +=(tmpObs.getValor());
       tmpObs.animar();
       sfxChoque.trigger();        
    }
    else if  (tmpObs.getId().equals("estrella")){      
       puntos +=(tmpObs.getValor());
       tmpObs.animar();
       sfxStarfish.trigger();        
    }
    
    else if  (tmpObs.getId().equals("home")){
       tmpCrabby.teletransportar();
       puntos +=(tmpObs.getValor());
       tmpObs.animar();
       sfxHome.trigger(); 
       if (tmpObs.getPos() > height/2 ){
         posHome = "a";
       }
       
       else if (tmpObs.getPos() < height/2 ){
         posHome = "b";
       }
    }
      
    
    if (tmpObs.isDelete() == true) {
      tmpCrabby.delete();
    }        
  }
  
  if (o1.getClass() == Boundary.class && o2.getClass() == Crabby.class) {
    Boundary tmpObs = (Boundary) o1;
    Crabby tmpCrabby = (Crabby) o2;    
    if (tmpObs.getId().equals("obstaculo")){
       puntos +=(tmpObs.getValor());
       tmpObs.animar();
       sfxChoque.trigger();        
    }
    else if  (tmpObs.getId().equals("estrella")){      
       puntos +=(tmpObs.getValor());
       tmpObs.animar();
       sfxStarfish.trigger();        
    }
    else if  (tmpObs.getId().equals("home")){
       tmpCrabby.teletransportar();
       puntos +=(tmpObs.getValor());
       tmpObs.animar();
       sfxHome.trigger();
       if (tmpObs.getPos() > height/2 ){
         posHome = "a";
       }
       
       else if (tmpObs.getPos() < height/2 ){
         posHome = "b";
       }
    }
    
    
    if (tmpObs.isDelete() == true) {
      tmpCrabby.delete();
    }     
  }  
}

 //Objects stop touching each other
void endContact(Contact cp) {
}
