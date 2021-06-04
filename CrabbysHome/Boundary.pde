class Boundary {

  float x;
  float y;
  float w;
  float h;
  float r;
  float c;
  PImage shell;
  
  
  Body b;


  Boundary(float x_,float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    r = 0;
    c = c_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
    b.setUserData(this);
  }
  
   Boundary(float x_,float y_, float r_) {
    x = x_;
    y = y_;
    r = r_;
    w = 0;
    h = 0;
    c = 0;
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    b.createFixture(cs,1);
    b.setUserData(this);
    
    shell = loadImage("shell.png");
    
  }
  

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    
    noStroke();
    
    if (r == 0) {
      fill(#c1b376);
      rectMode(CENTER);
      rect(x,y,w,h,c);
    }
    else {
      noFill();
      ellipseMode(CENTER);
      circle(x,y,r*2);
      image(shell,x,y);
    }
  }

}
