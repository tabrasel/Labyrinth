public class Link {
   
   private Point p1, p2;
   private float targetLength;
   
   public Link(Point p1, Point p2, float targetLength) {
      this.p1 = p1;
      this.p2 = p2;
      this.targetLength = targetLength;
   }
   
   public void update() {
      PVector p1Position = p1.getPosition();
      PVector p2Position = p2.getPosition();
      
      float positionDeltaX = p2Position.x - p1Position.x;
      float positionDeltaY = p2Position.y - p1Position.y;
      float positionDeltaZ = p2Position.z - p1Position.z;
      
      float positionDeltaMag = sqrt(sq(positionDeltaX) + sq(positionDeltaY) + sq(positionDeltaZ));

      float diffRatio = (positionDeltaMag - targetLength) / positionDeltaMag;
      
      // Update point positions
      p1Position.add(positionDeltaX * 0.5 * diffRatio, positionDeltaY * 0.5 * diffRatio, positionDeltaZ * 0.5 * diffRatio);
      p2Position.sub(positionDeltaX * 0.5 * diffRatio, positionDeltaY * 0.5 * diffRatio, positionDeltaZ * 0.5 * diffRatio);
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
