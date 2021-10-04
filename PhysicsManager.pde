public class PhysicsManager {
   
   private ArrayList<Point> points;
   private ArrayList<Link> links;
   private ArrayList<Wall> walls;
   
   private final int RELAXATION_ITERATIONS = 10;
   
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
            ArrayList<Wall> nearWalls = walls; // TODO: Only collide with neighboring walls
            
            for (Wall wall : nearWalls) {          
               // Get the normal of each separating axis
               ArrayList<PVector> separatingAxisNormals = getSeparatingAxesNormals(point, wall);
               
               // A list to store all the vectors that could be used to push the point out of the wall
               ArrayList<PVector> pushVectors = new ArrayList<PVector>();
               
               // For each separating axis normal
               for (PVector separatingAxisNormal : separatingAxisNormals) {                  
                  // Project the point along the separating axis normal
                  float[] pointProj = projectPointAlongAxis(point, separatingAxisNormal);
                  
                  // Project the wall along the separating axis normal
                  float[] wallProj = projectWallAlongAxis(wall, separatingAxisNormal);
                  
                  // If the point and wall projections don't overlap for one axis, then they aren't colliding at all
                  if (!projectionsOverlap(pointProj, wallProj)) break;
                  
                  // If the projections *do* overlap, create a push vector in whichever direction is shortest
                  if (abs(wallProj[0] - pointProj[1]) < abs(wallProj[1] - pointProj[0])) {
                     float pushVectorMag = wallProj[0] - pointProj[1];
                     PVector pushVector = separatingAxisNormal.copy().mult(pushVectorMag);
                     pushVectors.add(pushVector);
                  } else {
                     float pushVectorMag = wallProj[1] - pointProj[0];
                     PVector pushVector = separatingAxisNormal.copy().mult(pushVectorMag);
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
                  point.setPosition(
                     point.getPosition().x + shortestPushVector.x,
                     point.getPosition().y + shortestPushVector.y,
                     point.getPosition().z + shortestPushVector.z
                  );
               }
            }
         }
         
         
         // Apply wall constraints to links
         for (Link link : links) {
            ArrayList<Wall> nearWalls = walls; // TODO: Only collide with neighboring walls
            
            for (Wall wall : walls) {
               // Get the normal of each separating axis
               ArrayList<PVector> separatingAxisNormals = getSeparatingAxesNormals(link, wall);
               
               // A list to store all the vectors that could be used to push the link out of the wall
               ArrayList<PVector> pushVectors = new ArrayList<PVector>();
               
               // For each separating axis normal
               for (PVector separatingAxisNormal : separatingAxisNormals) {                  
                  // Project the link along the separating axis normal
                  float[] linkProj = projectLinkAlongAxis(link, separatingAxisNormal);
                  
                  // Project the wall along the separating axis normal
                  float[] wallProj = projectWallAlongAxis(wall, separatingAxisNormal);
                  
                  // If the link and wall projections don't overlap for one axis, then they aren't colliding at all
                  if (!projectionsOverlap(linkProj, wallProj)) break;
                  
                  // If the projections *do* overlap, create a push vector to push the link out with. Must choose push direction too (forward/backward).
                  if (abs(wallProj[0] - linkProj[1]) < abs(wallProj[1] - linkProj[0])) {
                     float pushVectorMag = wallProj[0] - linkProj[1];
                     PVector pushVector = separatingAxisNormal.copy().mult(pushVectorMag);
                     pushVectors.add(pushVector);
                  } else {
                     float pushVectorMag = wallProj[1] - linkProj[0];
                     PVector pushVector = separatingAxisNormal.copy().mult(pushVectorMag);
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
                  
                  // Apply the shortest push vector to the link's end points
                  Point p1 = link.getP1();
                  Point p2 = link.getP2();
                  
                  p1.setPosition(
                     p1.getPosition().x + shortestPushVector.x,
                     p1.getPosition().y + shortestPushVector.y,
                     p1.getPosition().z + shortestPushVector.z
                  );
                  
                  p2.setPosition(
                     p2.getPosition().x + shortestPushVector.x,
                     p2.getPosition().y + shortestPushVector.y,
                     p2.getPosition().z + shortestPushVector.z
                  );
               }
            }
         }
      }
   }
   
   /**
    * Gets the normal of each separating axis between a point and a wall.
    */
   public ArrayList<PVector> getSeparatingAxesNormals(Point point, Wall wall) {
      ArrayList<PVector> separatingAxesNormals = new ArrayList<PVector>();
      
      // Include normal of axis between point and horizontal wall edges
      PVector wallHorizontalEdgesNormal = new PVector(0, 0, 1);
      separatingAxesNormals.add(wallHorizontalEdgesNormal);
      
      // Include normal of axis between point and vertical wall edges
      PVector wallVerticalEdgesNormal = new PVector(1, 0, 0);
      separatingAxesNormals.add(wallVerticalEdgesNormal);
      
      // Include normal of axis between point and closest wall corner
      float wallLeftX = wall.getPosition().x - wall.getDimensions().x / 2;
      float wallRightX = wall.getPosition().x + wall.getDimensions().x / 2;
      float wallTopZ = wall.getPosition().z - wall.getDimensions().z / 2;
      float wallBottomZ = wall.getPosition().z + wall.getDimensions().z / 2;
      
      // NOTE: Assumes the wall is axis-aligned. Otherwise would have to calculate distances to each corner
      float closestCornerX = constrain(point.getPosition().x, wallLeftX, wallRightX);
      float closestCornerZ = constrain(point.getPosition().z, wallTopZ, wallBottomZ);
      PVector betweenPointAndCornerNormal = new PVector(point.getPosition().x - closestCornerX, 0, point.getPosition().z - closestCornerZ).normalize();
      separatingAxesNormals.add(betweenPointAndCornerNormal);
      
      return separatingAxesNormals;
   }
   
   /**
    * Gets the normal of each separating axis between a link and a wall.
    */
   public ArrayList<PVector> getSeparatingAxesNormals(Link link, Wall wall) {
      ArrayList<PVector> separatingAxesNormals = new ArrayList<PVector>();
      
      
      // Include normal of axis between point and horizontal wall edges
      PVector wallHorizontalEdgesNormal = new PVector(0, 0, 1);
      separatingAxesNormals.add(wallHorizontalEdgesNormal);
      
      // Include normal of axis between point and vertical wall edges
      PVector wallVerticalEdgesNormal = new PVector(1, 0, 0);
      separatingAxesNormals.add(wallVerticalEdgesNormal);
      
      
      // Include normal of axis between link and closest wall corner (literally just the link normal)      
      PVector betweenLinkAndCornerNormal = link.getNormal().normalize();
      separatingAxesNormals.add(betweenLinkAndCornerNormal);
      
      return separatingAxesNormals;
   }
   
   /**
    * Calculates the projection of a point along an axis.
    * @param point the point to project.
    * @param axis the axis to project along. Must be a unit vector.
    */
   public float[] projectPointAlongAxis(Point point, PVector axis) {
      // Find point extremeties
      PVector extremety1 = point.getPosition().copy().add(axis.copy().mult(point.getRadius()));
      PVector extremety2 = point.getPosition().copy().sub(axis.copy().mult(point.getRadius()));
      
      // Calculate each extremety's projection along the axis
      float extremety1Proj = extremety1.dot(axis);
      float extremety2Proj = extremety2.dot(axis);
      
      // Find the min/max projection
      float projMin = min(extremety1Proj, extremety2Proj);
      float projMax = max(extremety1Proj, extremety2Proj);
      
      // Return the min/max projections
      float[] projection = { projMin, projMax };
      return projection;
   }
   
   /**
    * Calculates the projection of a link along an axis.
    * @param link the link to project.
    * @param axis the axis to project along. Must be a unit vector.
    */
   public float[] projectLinkAlongAxis(Link link, PVector axis) {
      // Find link extremeties
      PVector extremety1 = link.getP1().getPosition().copy();
      PVector extremety2 = link.getP2().getPosition().copy();
      
      // Calculate each extremety's projection along the axis
      float extremety1Proj = extremety1.dot(axis);
      float extremety2Proj = extremety2.dot(axis);
      
      // Find the min/max projection
      float projMin = min(extremety1Proj, extremety2Proj);
      float projMax = max(extremety1Proj, extremety2Proj);
      
      // Return the min/max projections
      float[] projection = { projMin, projMax };
      return projection;
   }
   
   /**
    * Calculates the projection of a wall along an axis.
    * @param wall the wall to project.
    * @param axis the axis to project along. Must be a unit vector.
    */
   public float[] projectWallAlongAxis(Wall wall, PVector axis) {
      float wallLeftX = wall.getPosition().x - wall.getDimensions().x / 2;
      float wallRightX = wall.getPosition().x + wall.getDimensions().x / 2;
      float wallTopZ = wall.getPosition().z - wall.getDimensions().z / 2;
      float wallBottomZ = wall.getPosition().z + wall.getDimensions().z / 2;
               
      // Find wall extremeties
      PVector extremety1 = new PVector(wallLeftX, 0, wallTopZ);
      PVector extremety2 = new PVector(wallLeftX, 0, wallBottomZ);
      PVector extremety3 = new PVector(wallRightX, 0, wallTopZ);
      PVector extremety4 = new PVector(wallRightX, 0, wallBottomZ);
      
      // Calculate each extremety's projection along the axis
      float[] extremetyProjs = { extremety1.dot(axis), extremety2.dot(axis), extremety3.dot(axis), extremety4.dot(axis) };
      
      // Find the min/max projections
      float projMin = min(extremetyProjs);
      float projMax = max(extremetyProjs);
      
      // Return the min/max projections
      float[] projection = { projMin, projMax }; 
      return projection;
   }
   
   /**
    * Test if two projections overlap.
    */
   public boolean projectionsOverlap(float[] proj1, float[] proj2) {
      float proj1Min = proj1[0];
      float proj1Max = proj1[1];
      float proj2Min = proj2[0];
      float proj2Max = proj2[1];
      return proj1Max > proj2Min && proj1Min < proj2Max;
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
