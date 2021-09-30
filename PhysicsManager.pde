public class PhysicsManager {
   
   private ArrayList<Point> points;
   private ArrayList<Link> links;
   private ArrayList<Wall> walls;
   
   private final int RELAXATION_ITERATIONS = 50;
   
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
         
         // Apply wall constraints to points
         for (Point point : points) {
            
            PVector pointPos = point.getPosition();
            
            ArrayList<Wall> nearWalls = walls; // TODO: Just check for collisions with walls near the point
            
            for (Wall wall : nearWalls) {
               
               float wallLeftX = wall.getPosition().x - wall.getDimensions().x / 2;
               float wallRightX = wall.getPosition().x + wall.getDimensions().x / 2;
               float wallTopZ = wall.getPosition().z - wall.getDimensions().z / 2;
               float wallBottomZ = wall.getPosition().z + wall.getDimensions().z / 2;
               
               // Check if point is inside wall
               if (pointPos.x >= wallLeftX && pointPos.x <= wallRightX && pointPos.z >= wallTopZ && pointPos.z <= wallBottomZ) {
                  
                  //canvas.rect();
                  
                  // Calculate the vector needed to project the point out each wall edge
                  PVector[] projs = {
                     new PVector(wallLeftX - pointPos.x, 0, 0),  // Project to left edge
                     new PVector(wallRightX - pointPos.x, 0, 0), // Project to right edge
                     new PVector(0, 0, wallTopZ - pointPos.z),   // Project to top edge
                     new PVector(0, 0, wallBottomZ - pointPos.z) // Project to bottom edge
                  };
                  
                  int minProjIndex = 0;
                  float minProjMag = projs[0].mag();
                  
                  for (int j = 0; j < projs.length; j++) {
                     float projMag = projs[j].mag();
                     if (projMag < minProjMag) {
                        minProjMag = projMag;
                        minProjIndex = j;
                     }
                  }
                  
                  PVector minProj = projs[minProjIndex];
                  
                  point.setPosition(pointPos.x + minProj.x, pointPos.y + minProj.y, pointPos.z + minProj.z);
                  
               }
               
            }
            
         }
         
         // Apply wall constraints to links
         for (Link link : links) {
         }
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
