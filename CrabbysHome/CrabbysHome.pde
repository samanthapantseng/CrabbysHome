//tarea#9 - Crabby's Home
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
AudioPlayer mE1, mE2;
AudioSample sfxChoque, sfxObs;


// A reference to our box2d world
Box2DProcessing box2d;

PFont font;

PImage[] animation;
Gif loopingE1;

PImage bgEsc02;
int escenario;

ArrayList<Boundary> paredes;

ArrayList<Boundary> obstaculos;

ArrayList<Surface> homes;
Surface arco;
Surface inclinada;

ArrayList<Crabby> crabbies;

ArrayList<Windmill> windmills;
Windmill windmill;

Flipper fl;
Flipper fr;

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
    
  sfxChoque = minim.loadSample("sfxChoque.mp3");
  sfxObs = minim.loadSample("sfxObs.mp3");
  
  mE1.play();
  mE1.loop();

  bgEsc02 = loadImage("bgEsc02.png");
  loopingE1 = new Gif(this, "loopingE1.gif"); 

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
  paredes.add(new Boundary(0, height/2+280,2*width-180,1,7, false));
  //Barra inclinada
  inclinada = new Surface();
  
  //conchas-obstaculos
  obstaculos = new ArrayList<Boundary>();
  obstaculos.add(new Boundary(width-150,150,8));
  obstaculos.add(new Boundary(100,200,8));
  obstaculos.add(new Boundary(50,340,8));
  obstaculos.add(new Boundary(width-170,height/2,8));
  obstaculos.add(new Boundary(width-120,height-240,8));
  
  Boundary obstaculo1 = new Boundary(width-150,150,8);
  obstaculo1.setCaracteristica("obstaculo",300);
  obstaculos.add(obstaculo1);
  
  Boundary obstaculo2 = new Boundary(100,200,8);
  obstaculo2.setCaracteristica("obstaculo",100);
  obstaculos.add(obstaculo2);
  
  Boundary obstaculo3 = new Boundary(50,340,8);
  obstaculo3.setCaracteristica("obstaculo",200);
  obstaculos.add(obstaculo3);
  
  Boundary obstaculo4 = new Boundary(width-170,height/2,8);
  obstaculo4.setCaracteristica("obstaculo",150);
  obstaculos.add(obstaculo4);
  
  Boundary obstaculo5 = new Boundary(width-120,height-240,8);
  obstaculo5.setCaracteristica("obstaculo",200);
  obstaculos.add(obstaculo5);
  
  //crabs homes
  //homes = new ArrayList<Surface>();
  //homes.add(new Surface(240,450, 30, 0, 180));
  //homes.add(new Surface(90,430, 30, 0, 180));
  //homes.add(new Surface(160,270, 30, 0, 180));
  //homes.add(new Surface(300,260, 30, 0, 180));
  //homes.add(new Surface(230,120, 30, 0, 180));
  
  //Crabbies
  crabbies = new ArrayList<Crabby>();
  crabbies.add (new Crabby(width-50,height-80,30));
  crabbies.add (new Crabby(width-100,height-80,30));
  crabbies.add (new Crabby(width-150,height-80,30));
  crabbies.add (new Crabby(width-200,height-80,30));
  crabbies.add (new Crabby(width-250 ,height-80,30));
  
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
}


void draw() {
  box2d.step();
  
  if (escenario == 1){
    escenario1();
  }
  else if (escenario == 2){
    escenario2();
  }
}

void escenario1() {    
  loopingE1.loop();
  image(loopingE1, width/2, height/2, width, height);
}


void escenario2() {
  
  
  image(bgEsc02, width/2, height/2, width, height);
  arco.display();
  inclinada.display();
  
  for (Boundary pared : paredes) {
    pared.display();
  }
  
  for (Boundary obs : obstaculos) {
    obs.display();
  }
  
  //for (Surface home : homes) {
  //  home.display();
  //}
  
  textSize(width/25);
  textAlign(CENTER);
  text("SCORE: "+puntos, width/2, height/7);
  
  for (int i = 0; i < crabbies.size(); i++) {
    crabbies.get(i).display();
    if (crabbies.get(i).done()) {
      crabbies.remove(i);
    }
  }  
  
  for (Windmill windmill : windmills) {
    windmill.display();
  }

  fr.display();
  fl.display();
  
  rflip = true;
  lflip = true;  
}


void keyPressed() {    
  if (key == 's') {
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
  
  if (key == ' ') {
    if (disparando == false) {
      keyDown = millis();
      disparando = true;   
    }  
  }
}

void keyReleased( ) {
  if (key == ' ') {
    keyUp = millis();
    long difeTiempo = keyUp - keyDown;
    float potencia = map(constrain(difeTiempo, 0 , 7000), 0, 7000, 50, 150);    
    crabbies.get(0).shoot(potencia);
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
      sfxChoque.trigger();        

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
      sfxChoque.trigger();        

    }
    if (tmpObs.isDelete() == true) {
      tmpCrabby.delete();
    }     
  }  
}

 //Objects stop touching each other
void endContact(Contact cp) {
}
