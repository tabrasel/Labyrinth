public class PhysicsManager {
   
   private ArrayList<Point> points;
   private ArrayList<Spring> springs;
   
   public PhysicsManager() {
      points = new ArrayList<Point>();
      springs = new ArrayList<Spring>();
      
      Point p1 = new Point(200, 0, 140, 1, 1);
      Point p2 = new Point(200, 0, 160, 1, 1);
      Spring s = new Spring(p1, p2, 30, 0.05, 0.05);
      
      points.add(p1);
      points.add(p2);
      springs.add(s);
   }
   
   public void update() {
      for (Spring spring : springs) {
         spring.update();
      }
      
      for (Point point : points) {
         point.update();
      }
   }
}
