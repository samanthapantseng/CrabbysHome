class Crabby {

  float x,y,r;
  PImage crabbyBola;
  int puntos;
  
  Body body;

  Crabby(float x_,float y_ ,float r_) {
    x = x_;
    y = y_;
    r = r_;
    
    makeBody(new Vec2(x,y),r);
    body.setUserData(this);
    crabbyBola = loadImage("crabbyBola.png");
    
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
    
    //Parameters that affect physcis
    fd.density =1;
    fd.friction = 0.3;
    fd.restitution =0.5;
   
    body.createFixture(fd);

    body.setLinearVelocity(new Vec2(0,-150));
    body.setAngularVelocity(0);  
  }
  
  void ganarPuntos (int _pts) {
    puntos += _pts;
  }
  
  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
       
   
    ellipseMode(CENTER);
    noFill();
    //fill(250);
    noStroke();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    circle(0,0,r*2);
    popMatrix();
    image(crabbyBola,pos.x,pos.y);
    
    text("Puntaje: "+puntos, 200,100);
   }
  
}
