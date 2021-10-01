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
               
               /*
               // If the point center isn't inside the wall
               if (pointPos.x >= wallLeftX && pointPos.x <= wallRightX && pointPos.z >= wallTopZ && pointPos.z <= wallBottomZ) {
                  // Find the wall corner closest to the point
                  float closestCornerX = constrain(pointPos.x, wallLeftX, wallRightX);
                  float closestCornerZ = constrain(pointPos.z, wallTopZ, wallBottomZ);
                  
                  // Calculate the normal of the axis between the point and the corner closest to it
                  PVector pointToCornerNormal = new PVector(-(pointPos.z - closestCornerZ), 0, pointPos.x - closestCornerX);
                  separatingAxisNormals.add(pointToCornerNormal);
               }
               */
               
               PVector wallHorizontalEdgesNormal = new PVector(0, 0, 1); // Normal of axis between point and horizontal wall edges
               PVector wallVerticalEdgesNormal = new PVector(1, 0, 0); // Normal of axis between point and vertical wall edges
               
               // Create a list of all separating axis normals
               ArrayList<PVector> separatingAxisNormals = new ArrayList<PVector>();
               separatingAxisNormals.add(wallHorizontalEdgesNormal);
               separatingAxisNormals.add(wallVerticalEdgesNormal);
               
               // A list to store all the vectors that could be used to push the point out of the wall
               ArrayList<PVector> pushVectors = new ArrayList<PVector>();
               
               // For each separating axis normal
               for (PVector axisNormal : separatingAxisNormals) {
                  
                  // Project the point onto the axis normal
                  
                  //// Find point extremeties
                  PVector pointExtremety1 = pointPos.copy().add(axisNormal.copy().mult(point.getRadius()));
                  PVector pointExtremety2 = pointPos.copy().sub(axisNormal.copy().mult(point.getRadius()));
                  
                  //// Calculate the projection magnitude of each point extremety on the axis normal
                  float pointExtremety1Proj = pointExtremety1.dot(axisNormal);
                  float pointExtremety2Proj = pointExtremety2.dot(axisNormal);
                  
                  //// Find the min and max point projection magnitudes
                  float pointMinProj = min(pointExtremety1Proj, pointExtremety2Proj);
                  float pointMaxProj = max(pointExtremety1Proj, pointExtremety2Proj);
                  
                  // Project the wall onto the axis normal
                  
                  //// Find wall extremeties
                  PVector wallExtremety1 = new PVector(wallLeftX, 0, wallTopZ);
                  PVector wallExtremety2 = new PVector(wallLeftX, 0, wallBottomZ);
                  PVector wallExtremety3 = new PVector(wallRightX, 0, wallTopZ);
                  PVector wallExtremety4 = new PVector(wallRightX, 0, wallBottomZ);
                  
                  //// Calculate the projection magnitude of each wall extremety on the axis normal
                  float[] wallExtremetyProjs = { wallExtremety1.dot(axisNormal), wallExtremety2.dot(axisNormal), wallExtremety3.dot(axisNormal), wallExtremety4.dot(axisNormal) };
                  
                  //// Find the min and max wall projection magnitudes
                  float wallMinProj = min(wallExtremetyProjs);
                  float wallMaxProj = max(wallExtremetyProjs);
                  
                  // If the point and wall projections don't overlap, then they aren't colliding
                  if (pointMaxProj < wallMinProj || pointMinProj > wallMaxProj) break;
                  
                  // If the projections *do* overlap, create a push vector in whichever direction is shortest
                  if (abs(wallMinProj - pointMaxProj) < abs(wallMaxProj - pointMinProj)) {
                     float pushVectorMag = wallMinProj - pointMaxProj;
                     PVector pushVector = axisNormal.copy().mult(pushVectorMag);
                     pushVectors.add(pushVector);
                  } else {
                     float pushVectorMag = wallMaxProj - pointMinProj;
                     PVector pushVector = axisNormal.copy().mult(pushVectorMag);
                     pushVectors.add(pushVector);
                  }
               }
               
               // There is only a collision if there is overlap on *all* separating axis normals
               if (pushVectors.size() == separatingAxisNormals.size()) {
                  // Find shortest push vector
                  PVector shortestPushVector = pushVectors.get(0);
                  for (PVector pushVector : pushVectors) {
                     if (pushVector.mag() < shortestPushVector.mag()) {
                        shortestPushVector = pushVector;
                     }
                  }
                  
                  // Apply the shortest push vector to the point position
                  point.setPosition(pointPos.x + shortestPushVector.x, pointPos.y + shortestPushVector.y, pointPos.z + shortestPushVector.z);
               }
               
               /*
               float wallLeftX = wall.getPosition().x - wall.getDimensions().x / 2;
               float wallRightX = wall.getPosition().x + wall.getDimensions().x / 2;
               float wallTopZ = wall.getPosition().z - wall.getDimensions().z / 2;
               float wallBottomZ = wall.getPosition().z + wall.getDimensions().z / 2;
               
               // Check if point is inside wall
               if (pointPos.x >= wallLeftX && pointPos.x <= wallRightX && pointPos.z >= wallTopZ && pointPos.z <= wallBottomZ) {
                  // Calculate the vectors needed to project the point out of each wall edge
                  PVector[] projs = {
                     new PVector(wallLeftX - pointPos.x, 0, 0),  // Project to left edge
                     new PVector(wallRightX - pointPos.x, 0, 0), // Project to right edge
                     new PVector(0, 0, wallTopZ - pointPos.z),   // Project to top edge
                     new PVector(0, 0, wallBottomZ - pointPos.z) // Project to bottom edge
                  };
                  
                  // Find the shortest projection vector
                  int minProjIndex = 0;
                  float minProjMag = projs[0].mag();
                  for (int j = 0; j < projs.length; j++) {
                     float projMag = projs[j].mag();
                     if (projMag < minProjMag) {
                        minProjMag = projMag;
                        minProjIndex = j;
                     }
                  }
                  
                  // Project the point out
                  PVector minProj = projs[minProjIndex];
                  point.setPosition(pointPos.x + minProj.x, pointPos.y + minProj.y, pointPos.z + minProj.z);
               }  
               */
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
