public class Point {
   
   private PVector position;
   private PVector velocity;
   private PVector netForce;
   private float mass;
   private float radius;
   
   public Point(float x, float y, float z, float mass, float radius) {
      this.position = new PVector(x, y, z);
      this.velocity = new PVector();
      this.netForce = new PVector();
      this.mass = mass;
      this.radius = radius;
   }
   
   public void update() {
      // Calculate acceleration
      PVector acceleration = netForce.div(mass);
      
      // Update velocity and position
      velocity.add(acceleration);
      position.add(velocity);
      
      // Reset net force
      netForce.set(0, 0, 0);
   }
   
   public void applyForce(PVector force) {
      netForce.add(force);
   }
   
   public void applyForce(float fX, float fY, float fZ) {
      netForce.add(fX, fY, fZ);
   }
   
   public void display() {
      noStroke();
      fill(255);
      ellipse(position.x, position.y, radius * 2, radius * 2);
   }
   
   public PVector getPosition() {
      return position;
   }
   
   public PVector getVelocity() {
      return velocity;
   }
}
