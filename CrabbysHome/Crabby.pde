class Crabby {

  float x,y,r;
  PImage crabbyBola;
  //int puntos;
  
  boolean delete = false;
  boolean activarPortal;
  
  Body body;

  Crabby(float x_,float y_ ,float r_) {
    x = x_;
    y = y_;
    r = r_;
    
    activarPortal = false;
    
    makeBody(new Vec2(x,y),r);
    body.setUserData(this);
    crabbyBola = loadImage("crabbyBola.png");    
  }
  
  void teletransportar() {
    activarPortal = true;
  }
  
  boolean getActivarPortal() {
    return activarPortal;
  }
  
  void portal(float _x, float _y) {
    body.setTransform(box2d.coordPixelsToWorld(new Vec2(_x, _y)), 0);
    activarPortal = false;
  }

 


  void makeBody(Vec2 center, float r){
    
    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    //Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    
    //Parameters that affect physics
    fd.density =0.5;
    fd.friction = 0.03;
    fd.restitution =0.75;
   
    body.createFixture(fd);

  }
  
  
  void shoot(float potencia) {  
    body.setLinearVelocity(new Vec2(0, potencia));
    body.setAngularVelocity(random(-10, 10));    
  }

  void killBody() {
    box2d.destroyBody(body);
  }
  
  void delete() {
    delete = true;  
  }

  boolean done() {
    if (delete == true) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();       
   
    ellipseMode(CENTER);
    noFill();
    noStroke();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    circle(0,0,r*2);
    popMatrix();
    image(crabbyBola,pos.x,pos.y);
    
    //textSize(width/25);
    //textAlign(CENTER);
    //text("SCORE: "+puntos, width/2, height/7);
  }  
}
