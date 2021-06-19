class Boundary {

  float x;
  float y;
  float w;
  float h;
  float r;
  float c;
  boolean delete;
  
  SpriteSheet animacion;
  String id = "";
  int valor = 0;
    
  Body b;

  Boundary(float x_,float y_, float w_, float h_, float c_, boolean delete_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    r = 0;
    c = c_;
    delete = delete_;

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
  
   Boundary(float x_,float y_, float r_,String _id, int _valor) {
    x = x_;
    y = y_;
    r = r_;
    w = 0;
    h = 0;
    c = 0;
    id = _id;
    valor = _valor;
    
    if (id.equals("obstaculo")) {
      animacion = new SpriteSheet("shell_", 15, "png");}
    else if (id.equals("estrella")){
      animacion = new SpriteSheet("starfish_", 34, "png");
    }
    else if (id.equals("home")){
      animacion = new SpriteSheet("home_", 13, "png");
    }
    animacion.noLoop();
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    b.createFixture(cs,1);
    b.setUserData(this);
     
  }
   
  String getId() {
    return id;
  }
   
  int getValor() {
    return valor;
  }
  
  void animar() {
    animacion.play();
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    
    noStroke();
    if (id.isEmpty()) {
      if (r == 0) {
        fill(#c1b376);
        rectMode(CENTER);
        rect(x,y,w,h,c);
      }  
    }
    else {
      noFill();
      ellipseMode(CENTER);
      circle(x,y,r*2);
      imageMode(CENTER);
      animacion.display(x,y);
    
    }
  }
  
  boolean isDelete() {
    return delete;
  }
}
