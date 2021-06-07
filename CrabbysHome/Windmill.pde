class Windmill {

  RevoluteJoint joint;
  Box box1;
  Box box2;
  
  Windmill(float x, float y) {
  
    box1 = new Box(x, y, width/6, 3.5, false);
    box2 = new Box(x, y, 1, 3.5, true);
    
    RevoluteJointDef rjd = new RevoluteJointDef();
    
    rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter());
    
    rjd.motorSpeed = -PI*2;       
    rjd.maxMotorTorque = 30000.0; 
    rjd.enableMotor = true;   
    
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
  }
    
  void display() {
    box1.display();
    
    Vec2 anchor = box2d.coordWorldToPixels(box1.body.getWorldCenter());
    fill(#c1b376);
    stroke(#294D3E);
    ellipse(anchor.x, anchor.y, 4, 4);      
  }
}
