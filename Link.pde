public class Link {
   
   private Point p1, p2;
   private float targetLength;
   private PVector normal;
   
   public Link(Point p1, Point p2, float targetLength) {
      this.p1 = p1;
      this.p2 = p2;
      this.targetLength = targetLength;
      this.normal = new PVector();
      updateNormal();
   }
   
   public void update() {
      PVector p1Position = p1.getPosition();
      PVector p2Position = p2.getPosition();
      
      float p1InvMass = 1.0 / p1.getMass();
      float p2InvMass = 1.0 / p2.getMass();
      
      float positionDeltaX = p2Position.x - p1Position.x;
      float positionDeltaY = p2Position.y - p1Position.y;
      float positionDeltaZ = p2Position.z - p1Position.z;
      
      float positionDeltaMag = sqrt(sq(positionDeltaX) + sq(positionDeltaY) + sq(positionDeltaZ));

      float diffRatio = (positionDeltaMag - targetLength) / (positionDeltaMag * (p1InvMass + p2InvMass));
      
      // Update point positions
      p1Position.add(p1InvMass * positionDeltaX * diffRatio, p1InvMass * positionDeltaY * diffRatio, p1InvMass * positionDeltaZ * diffRatio);
      p2Position.sub(p2InvMass * positionDeltaX * diffRatio, p2InvMass * positionDeltaY * diffRatio, p2InvMass * positionDeltaZ * diffRatio);
      
      updateNormal();
   }
   
   public void display(PGraphics canvas, Camera camera) {
      // Get endpoint positions
      PVector p1Pos = p1.getPosition();
      PVector p2Pos = p2.getPosition();
      
      float canvasTopLeftX = camera.getPosition().x - camera.getDimensions().x / 2;
      float canvasTopLeftY = camera.getPosition().z - camera.getDimensions().y / 2;
      
      float canvasX1 = p1Pos.x - canvasTopLeftX;
      float canvasY1 = p1Pos.z - canvasTopLeftY;
      float canvasX2 = p2Pos.x - canvasTopLeftX;
      float canvasY2 = p2Pos.z - canvasTopLeftY;
      
      // Draw spring
      canvas.stroke(255, 0, 0);
      canvas.line(canvasX1, canvasY1, canvasX2, canvasY2);
   }
   
   public void updateNormal() {
      PVector p1Pos = p1.getPosition();
      PVector p2Pos = p2.getPosition();
      this.normal.set(-(p2Pos.z - p1Pos.z), 0, p2Pos.x - p1Pos.x);
      this.normal.normalize();
   }
   
   public Point getP1() {
      return p1;
   }
   
   public Point getP2() {
      return p2;
   }
   
   public PVector getNormal() {
      return normal;
   }
}
