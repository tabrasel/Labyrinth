public class Spring {

   private Point p1, p2;
   private float strength;
   private float damping;
   private float targetLength;
   
   public Spring(Point p1, Point p2, float targetLength, float strength, float damping) {
      this.p1 = p1;
      this.p2 = p2;
      this.targetLength = targetLength;
      this.strength = strength;
      this.damping = damping;
   }

   public void applyForce() {
      // Get endpoint positions
      PVector p1Pos = p1.getPosition();
      PVector p2Pos = p2.getPosition();
      
      // Get endpoint velocities
      PVector p1Vel = p1.getVelocity();
      PVector p2Vel = p2.getVelocity();
      
      // Calculate displacement between endpoints
      float displacementX = p2Pos.x - p1Pos.x;
      float displacementY = p2Pos.y - p1Pos.y;
      float displacementZ = p2Pos.z - p1Pos.z;

      // Calculate distance between endpoints
      float distance = sqrt(sq(displacementX) + sq(displacementY) + sq(displacementZ));

      // Determine the target point for each endpoint based on the spring's target length
      float p1TargetX = p2Pos.x - displacementX / distance * targetLength;
      float p1TargetY = p2Pos.y - displacementY / distance * targetLength;
      float p1TargetZ = p2Pos.z - displacementZ / distance * targetLength;
      
      float p2TargetX = p1Pos.x + displacementX / distance * targetLength;
      float p2TargetY = p1Pos.y + displacementY / distance * targetLength;
      float p2TargetZ = p1Pos.z + displacementZ / distance * targetLength;

      // Calculate the relative velocities of the endpoints
      float p1RelVelX = p1Vel.x - p2Vel.x;
      float p1RelVelY = p1Vel.y - p2Vel.y;
      float p1RelVelZ = p1Vel.z - p2Vel.z;
      
      float p2RelVelX = p2Vel.x - p1Vel.x;
      float p2RelVelY = p2Vel.y - p1Vel.y;
      float p2RelVelZ = p2Vel.z - p1Vel.z;
      
      // Calculate the spring's force on its endpoints 
      float p1ForceX = strength * (p1TargetX - p1Pos.x) - p1RelVelX * damping;
      float p1ForceY = strength * (p1TargetY - p1Pos.y) - p1RelVelY * damping;
      float p1ForceZ = strength * (p1TargetZ - p1Pos.z) - p1RelVelZ * damping;
      
      float p2ForceX = strength * (p2TargetX - p2Pos.x) - p2RelVelX * damping;
      float p2ForceY = strength * (p2TargetY - p2Pos.y) - p2RelVelY * damping;
      float p2ForceZ = strength * (p2TargetZ - p2Pos.z) - p2RelVelZ * damping;

      // Apply spring force on endpoints
      p1.applyForce(p1ForceX, p1ForceY, p1ForceZ);
      p2.applyForce(p2ForceX, p2ForceY, p2ForceZ);
   }

   public void display(PGraphics canvas) {
      // Get endpoint positions
      PVector p1Pos = p1.getPosition();
      PVector p2Pos = p2.getPosition();
      
      // Draw spring
      canvas.stroke(255, 0, 0);
      canvas.line(p1Pos.x, p1Pos.z, p2Pos.x, p2Pos.z);
   }
}
