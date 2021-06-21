class Surface {

  ArrayList<Vec2> surface;


  //Constructor para construir arcos
  Surface(float _x, float _y, float _r, int _beginAngle, int _endAngle) {
    surface = new ArrayList<Vec2>();

    ChainShape chain = new ChainShape();

    for (float x = _beginAngle; x < _endAngle; x += 5) {
      float pX = _x + cos(radians(x))*_r;
      float pY = _y + sin(radians(x))*_r;
      surface.add(new Vec2(pX,pY));
    }

    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface.get(i));
      vertices[i] = edge;
    }
    
    chain.createChain(vertices,vertices.length);
    
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    Body body = box2d.createBody(bd);
    body.createFixture(chain,1);
    body.setUserData(this);
  }
   
   //Constructor para construir linea inclinada 
  Surface() {
    surface = new ArrayList<Vec2>();

    surface.add(new Vec2(width-80,height-20));
    surface.add(new Vec2(0,height-60));

    ChainShape chain = new ChainShape();

    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));     
    }
    
    chain.createChain(vertices,vertices.length);
 
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain,1);
  }
  
   
   
   void display() {
   
     strokeWeight(10);
     stroke(#c1b376);
     noFill();
     beginShape();
     for (Vec2 v: surface) {
       vertex(v.x,v.y);
    }
    //vertex(0,height);
    //vertex(width,height);
    endShape();
  } 
}
