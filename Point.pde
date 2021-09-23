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
      // Apply friction force
      float frictionForceX = velocity.x * -1 * mass * 0.04;
      float frictionForceY = velocity.y * -1 * mass * 0.04;
      float frictionForceZ = velocity.z * -1 * mass * 0.04;
      applyForce(frictionForceX, frictionForceY, frictionForceZ);
      
      // Calculate acceleration
      PVector acceleration = netForce.div(mass);
      
      // Update velocity and position
      velocity.add(acceleration);
      
      //velocity.mult(0.98);
      
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
