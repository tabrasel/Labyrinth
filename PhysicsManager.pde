public class PhysicsManager {
   
   private ArrayList<Point> points;
   private ArrayList<Link> links;
   private ArrayList<Wall> walls;
   
   private final int RELAXATION_ITERATIONS = 30;
   
   public PhysicsManager() {
      points = new ArrayList<Point>();
      links = new ArrayList<Link>();
      walls = new ArrayList<Wall>();
   }
   
   public void update() {
      for (Point point : points) {
         point.update();
      }
      
      // Iteratively apply constraints
      for (int i = 0; i < RELAXATION_ITERATIONS; i++) {
         
         // Apply link constraints
         for (Link link : links) {
            link.update();
         }
         
         // Apply wall constraints
         
      }
   }
   
   public void addPoint(Point point) {
      points.add(point);
   }
   
   public void addLink(Link link) {
      links.add(link);
   }
   
   public void addWall(Wall wall) {
      walls.add(wall);
   }
}
