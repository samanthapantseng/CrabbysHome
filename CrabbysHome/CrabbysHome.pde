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

PImage[] animation;
Gif loopingE1;

PImage bgEsc02;
int escenario;

ArrayList<Boundary> paredes;
ArrayList<Boundary> obstaculos;
ArrayList<Surface> homes;
Surface arco;

Surface inclinada;

void setup() {
  size(504, 702);
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
  
  // Add some boundaries
  arco = new Surface(width/2, 255, 250, 180, 360);
  paredes = new ArrayList<Boundary>();
  paredes.add(new Boundary(width/2,height-5,width,10,7));
  paredes.add(new Boundary(width-5,height/2,10,height,7));
  paredes.add(new Boundary(5,height/2,10,height,7));
  //Barra cañon de disparo
  paredes.add(new Boundary(width-80,height/2+60,10,350,7));
  //Barras de puntaje
  paredes.add(new Boundary(width/4-30,height-150,10,70,7));
  paredes.add(new Boundary(width/2-50,height-150,10,70,7));
  paredes.add(new Boundary(width-190,height-150,10,70,7));
  //Barra inclinada
  inclinada = new Surface();
  
  
  //conchas-obstaculos
  obstaculos = new ArrayList<Boundary>();
  obstaculos.add(new Boundary(width-150,150,8));
  obstaculos.add(new Boundary(100,200,8));
  obstaculos.add(new Boundary(50,340,8));
  obstaculos.add(new Boundary(width-170,height/2,8));
  obstaculos.add(new Boundary(width-120,height-240,8));
  
  //crabs homes
  homes = new ArrayList<Surface>();
  homes.add (new Surface(240,450, 30, 0, 180));
  homes.add (new Surface(90,430, 30, 0, 180));
  homes.add (new Surface(160,270, 30, 0, 180));
  homes.add (new Surface(300,260, 30, 0, 180));
  homes.add (new Surface(230,120, 30, 0, 180));
  
  escenario = 1;  
}


void draw() {
  background(250);
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
  for (Surface home : homes) {
    home.display();
  }
}


void keyPressed() {    
  if (key == 's') {
    escenario = 2;
  }  
}
