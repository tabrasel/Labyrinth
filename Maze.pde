import java.util.Stack;

public class Maze {
   
   private final int ROW_COUNT = 6;
   private final int COL_COUNT = 10;
   private final int CELL_SIZE = 24;
   private final int WALL_LENGTH = 24;
   private final int WALL_THICKNESS = 2;
   
   private MazeNode[][] nodes;
   private ArrayList<Wall> walls;
   
   public Maze(PhysicsManager pm) {
      nodes = new MazeNode[ROW_COUNT][COL_COUNT];
      for (int row = 0; row < ROW_COUNT; row++) {
         for (int col = 0; col < COL_COUNT; col++) {
            nodes[row][col] = new MazeNode(col, row);
         }
      }
      
      walls = new ArrayList<Wall>();
      
      generate();
      createWalls(pm);
   }
   
   public void generate() {
      MazeNode current = nodes[0][0];
      current.visited = true;
      
      Stack<MazeNode> nodeStack = new Stack<MazeNode>();
      nodeStack.push(current);
      
      while (!nodeStack.isEmpty()) {
         current = nodeStack.pop();
         MazeNode choice = current.makeChoice();
         if (choice != null) {
            nodeStack.push(current);
            
            // Connect the nodes
            current.connectTo(choice);
            choice.connectTo(current);
            
            choice.visited = true;
            nodeStack.push(choice);
         }
      }
   }
   
   public void createWalls(PhysicsManager pm) {
      for (int row = 0; row < ROW_COUNT; row++) {
         for (int col = 0; col < COL_COUNT; col++) {
            MazeNode node = nodes[row][col];
            
            float nodeX = col * CELL_SIZE + CELL_SIZE / 2;
            float nodeY = row * CELL_SIZE + CELL_SIZE / 2;
            
            if (node.west == null) {
               float x = nodeX - CELL_SIZE / 2;
               Wall wall = new Wall(new PVector(x, 0, nodeY), new PVector(WALL_THICKNESS, 0, WALL_LENGTH));
               walls.add(wall);
               pm.addWall(wall);
            }
            
            if (node.north == null) {
               float y = nodeY - CELL_SIZE / 2;
               Wall wall = new Wall(new PVector(nodeX, 0, y), new PVector(WALL_LENGTH, 0, WALL_THICKNESS));
               walls.add(wall);
               pm.addWall(wall);
            }
            
            if (node.east == null && col == COL_COUNT - 1) {
               float x = nodeX + CELL_SIZE / 2;
               Wall wall = new Wall(new PVector(x, 0, nodeY), new PVector(WALL_THICKNESS, 0, WALL_LENGTH));
               walls.add(wall);
               pm.addWall(wall);
            }
            
            if (node.south == null && row == ROW_COUNT - 1) {
               float y = nodeY + CELL_SIZE / 2;
               Wall wall = new Wall(new PVector(nodeX, 0, y), new PVector(WALL_LENGTH, 0, WALL_THICKNESS));
               walls.add(wall);
               pm.addWall(wall);
            }
         }
      }
   }
   
   public boolean isInBounds(int col, int row) {
      return col > -1 && col < COL_COUNT && row > -1 && row < ROW_COUNT;
   } //<>//
   
   public void display(PGraphics canvas, Camera camera) {
      canvas.noStroke();
      canvas.fill(200, 130, 0);
      for (Wall wall : walls) {
         wall.display(canvas, camera);
      }
   }
   
   private class MazeNode {
      
      public int col, row;
      public MazeNode north, south, east, west;
      public boolean visited;
      
      public MazeNode(int col, int row) {
         this.col = col;
         this.row = row;
      }
      
      public MazeNode makeChoice() {
         // Find all unvisited neighbors
         ArrayList<MazeNode> choices = new ArrayList<MazeNode>();
         if (isInBounds(col - 1, row) && !nodes[row][col - 1].visited)
            choices.add(nodes[row][col - 1]);
         if (isInBounds(col + 1, row) && !nodes[row][col + 1].visited)
            choices.add(nodes[row][col + 1]);
         if (isInBounds(col, row - 1) && !nodes[row - 1][col].visited)
            choices.add(nodes[row - 1][col]);
         if (isInBounds(col, row + 1) && !nodes[row + 1][col].visited)
            choices.add(nodes[row + 1][col]);
         
         if (choices.isEmpty()) return null;
         
         // Choose one
         int index = int(random(choices.size()));
         return choices.get(index);
      }
      
      public void connectTo(MazeNode target) {
         if (target.col == this.col - 1) this.west = target;
         if (target.col == this.col + 1) this.east = target;
         if (target.row == this.row - 1) this.north = target;
         if (target.row == this.row + 1) this.south = target;
      }
      
   }
   
}
