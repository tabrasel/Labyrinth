public class Clew {
   
   private ArrayList<Point> points;
   private ArrayList<Spring> springs;
   
   private Point looseEnd, theseusEnd;
   
   private final int springCount = 30;
   private final float springTargetLength = 8;
   private final float springStrength = 0.5;
   private final float springDamping = 0.1;
   
   public Clew(PhysicsManager pm) {
      points = new ArrayList<Point>();
      springs = new ArrayList<Spring>();
      
      looseEnd = new Point(0, 0, 100, 20, 3);
      points.add(looseEnd);
      pm.addPoint(looseEnd);
      
      for (int i = 1; i < springCount; i++) {
         Point point = new Point(i * springTargetLength, 0, 100, 1, 2);
         points.add(point);
         pm.addPoint(point);
      }
      
      theseusEnd = new Point((springCount + 1) * springTargetLength, 0, 100, 500, 5);
      points.add(theseusEnd);
      pm.addPoint(theseusEnd);
      
      for (int i = 0; i < springCount; i++) {
         Spring spring = new Spring(points.get(i), points.get(i + 1), springTargetLength, springStrength, springDamping);
         springs.add(spring);
         pm.addSpring(spring);
      }
   }
   
   public void display(PGraphics canvas) {
      if (Keyboard.isKeyDown(UP)) {
         looseEnd.applyForce(0, 0, -2.5);
      }
      
      if (Keyboard.isKeyDown(DOWN)) {
         looseEnd.applyForce(0, 0, 2.5);
      }
      
      if (Keyboard.isKeyDown(LEFT)) {
         looseEnd.applyForce(-2.5, 0, 0);
      }
      
      if (Keyboard.isKeyDown(RIGHT)) {
         looseEnd.applyForce(2.5, 0, 0);
      }
      
      for (Spring spring : springs) {
         spring.display(canvas);
      }
      
      canvas.fill(255, 0, 0);
      looseEnd.display(canvas);
      
      canvas.fill(0, 255, 0);
      theseusEnd.display(canvas);
   }
}
