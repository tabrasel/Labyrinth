public class Point {
   
   private PVector position;
   private PVector oldPosition;
   private PVector velocity;
   private PVector netForce;
   private float mass;
   private float radius;
   
   public Point(float x, float y, float z, float mass, float radius) {
      this.position = new PVector(x, y, z);
      this.oldPosition = new PVector(x, y, z);
      this.velocity = this.position.copy().sub(this.oldPosition);
      this.netForce = new PVector();
      this.mass = mass;
      this.radius = radius;
   }
   
   public void update() {
      applyForce(velocity.x * -0.005, velocity.y * -0.005, velocity.z * -0.005);
      
      // Calculate acceleration
      PVector acceleration = netForce.div(mass);
      
      //acceleration.add(0, 0, 0.1);
      
      // Store current position
      float tempPositionX = position.x;
      float tempPositionY = position.y;
      float tempPositionZ = position.z;
      
      velocity.set(position.x - oldPosition.x, position.y - oldPosition.y, position.z - oldPosition.z);
      
      // Update position
      position.x += (position.x - oldPosition.x) + acceleration.x;
      position.y += (position.y - oldPosition.y) + acceleration.y;
      position.z += (position.z - oldPosition.z) + acceleration.z;
      
      // Update old position
      oldPosition.set(tempPositionX, tempPositionY, tempPositionZ);
      
      // Reset net force
      netForce.set(0, 0, 0);
   }
   
   public void applyForce(PVector force) {
      netForce.add(force);
   }
   
   public void applyForce(float fX, float fY, float fZ) {
      netForce.add(fX, fY, fZ);
   }
   
   public void display(PGraphics canvas) {
      canvas.noStroke();
      canvas.ellipse(position.x, position.z, radius * 2, radius * 2);
   }
   
   public PVector getPosition() {
      return position;
   }
   
   public PVector getVelocity() {
      return velocity;
   }
}
