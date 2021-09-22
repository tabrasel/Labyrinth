public class PhysicsManager {
   
   private ArrayList<Point> points;
   private ArrayList<Spring> springs;
   
   public PhysicsManager() {
      points = new ArrayList<Point>();
      springs = new ArrayList<Spring>();
   }
   
   public void update() {
      for (Spring spring : springs) {
         spring.update();
      }
      
      for (Point point : points) {
         point.update();
      }
   }
   
   public void addPoint(Point point) {
      points.add(point);
   }
   
   public void addSpring(Spring spring) {
      springs.add(spring);
   }
}
