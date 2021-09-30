public class Clew {
   
   private ArrayList<Point> points;
   private ArrayList<Link> links;
   
   private Point looseEnd, theseusEnd;
   
   private final int linkCount = 30;
   private final float linkTargetLength = 3;
   
   public Clew(float x, float z, PhysicsManager pm) {
      points = new ArrayList<Point>();
      links = new ArrayList<Link>();
      
      looseEnd = new Point(x, 0, z, 1, 2);
      points.add(looseEnd);
      pm.addPoint(looseEnd);
      
      for (int i = 1; i < linkCount; i++) {
         Point point = new Point(x + i % 2, 0, z, 0.05, 1);
         points.add(point);
         pm.addPoint(point);
      }
      
      theseusEnd = new Point(x, 0, z, 10, 5);
      points.add(theseusEnd);
      pm.addPoint(theseusEnd);
      
      for (int i = 0; i < linkCount; i++) {
         Link link = new Link(points.get(i), points.get(i + 1), linkTargetLength);
         links.add(link);
         pm.addLink(link);
      }
   }
   
   public void display(PGraphics canvas, Camera camera) {
      if (Keyboard.isKeyDown(UP)) {
         looseEnd.applyForce(0, 0, -0.2);
      }
      
      if (Keyboard.isKeyDown(DOWN)) {
         looseEnd.applyForce(0, 0, 0.2);
      }
      
      if (Keyboard.isKeyDown(LEFT)) {
         looseEnd.applyForce(-0.2, 0, 0);
      }
      
      if (Keyboard.isKeyDown(RIGHT)) {
         looseEnd.applyForce(0.2, 0, 0);
      }
      
      canvas.strokeWeight(1);
      for (Link link : links) {
         link.display(canvas, camera);
      }
      
      canvas.fill(255, 0, 0);
      looseEnd.display(canvas, camera);
      
      canvas.fill(0, 255, 0);
      theseusEnd.display(canvas, camera);
   }
}
