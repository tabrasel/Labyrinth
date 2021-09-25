public class PhysicsManager {
   
   private ArrayList<Point> points;
   private ArrayList<Spring> springs;
   private ArrayList<Link> links;
   
   public PhysicsManager() {
      points = new ArrayList<Point>();
      springs = new ArrayList<Spring>();
      links = new ArrayList<Link>();
   }
   
   public void update() {
      for (Spring spring : springs) {
         //spring.update();
      }
      
      for (Point point : points) {
         point.update();
      }
      
      // Iteratively apply constraints
      for (int i = 0; i < 50; i++) {
         // Apply world constraints
         //points.get(0).getPosition().set(100, 0, 10);
         
         // Apply link constraints
         for (Link link : links) {
            link.update();
         }
         
         
      }
   }
   
   public void addPoint(Point point) {
      points.add(point);
   }
   
   public void addSpring(Spring spring) {
      springs.add(spring);
   }
   
   public void addLink(Link link) {
      links.add(link);
   }
}
