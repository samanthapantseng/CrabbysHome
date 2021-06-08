//tarea#8 - Crabby's Home
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

void setup() {
  size(504, 800);
  smooth();
  imageMode(CENTER);
  frameRate(60);
  
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
  
  escenario = 2;
  
  font = createFont("crabbytype.ttf",width/50);
  textFont(font);
}


void draw() {
  box2d.step();
  
  if (escenario == 1)
    escenario1();
  else if (escenario == 2)
    escenario2();
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
  }
  
  if (keyCode == RIGHT && rflip) {
    fr.reverseSpeed();
    rflip = false;
  }
  
  if (keyCode == LEFT && lflip) {
    fl.reverseSpeed();
    lflip = false;
  }
  
  
  if (keyCode == ' ') {
    crabbies.get(0).shoot();   
  }
}

void keyReleased( ) {
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
  
  //if (o1.getClass() == Crabby.class && o2.getClass() == Surface.class) {
  //  Surface tmpHome = (Surface) o2;
  //  if (tmpHome.getId().equals("home")){
  //    Crabby tmpCrabby = (Crabby) o1;
  //    tmpCrabby.ganarPuntos(tmpHome.getValor());
  //  }   
  //}
  
  //if (o1.getClass() == Surface.class && o2.getClass() == Crabby.class) {
  //  Surface tmpHome = (Surface) o1;
  //  if (tmpHome.getId().equals("home")){
  //    Crabby tmpCrabby = (Crabby) o2;
  //    tmpCrabby.ganarPuntos(tmpHome.getValor());
  //  }
  //}
  
  if (o1 == null || o2 == null){
    return;
  }
  
  if (o1.getClass() == Boundary.class && o2.getClass() == Crabby.class) {
    Crabby c = (Crabby) o2;
    Boundary b = (Boundary) o1;
    if (b.isDelete() == true) {
      c.delete();
    }
  }
  if (o2.getClass() == Boundary.class && o1.getClass() == Crabby.class) {
    Crabby c = (Crabby) o1;
    Boundary b = (Boundary) o2;
    if (b.isDelete() == true) {
      c.delete();
    }
  }  
}

 //Objects stop touching each other
void endContact(Contact cp) {
}
