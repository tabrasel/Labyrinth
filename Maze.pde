import java.util.Stack;

public class Maze {
   
   private final int ROW_COUNT = 12;
   private final int COL_COUNT = 14;
   private final int CELL_SIZE = 20;
   
   private MazeNode[][] nodes;
   
   public Maze(PhysicsManager pm) {
      nodes = new MazeNode[ROW_COUNT][COL_COUNT];
      
      for (int row = 0; row < ROW_COUNT; row++) {
         for (int col = 0; col < COL_COUNT; col++) {
            nodes[row][col] = new MazeNode(col, row);
         }
      }
      
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
            
            if (node.west == null) {
               float x = col * CELL_SIZE - CELL_SIZE / 2;
               canvas.line(x, row * CELL_SIZE - CELL_SIZE / 2, x, row * CELL_SIZE + CELL_SIZE / 2);
            }
            
            if (node.north == null) {
               float y = row * CELL_SIZE - CELL_SIZE / 2;
               canvas.line(col * CELL_SIZE - CELL_SIZE / 2, y, col * CELL_SIZE + CELL_SIZE / 2, y);
            }
            
            if (node.south == null && row == ROW_COUNT - 1) {
               float y = row * CELL_SIZE + CELL_SIZE / 2;
               canvas.line(col * CELL_SIZE - CELL_SIZE / 2, y, col * CELL_SIZE + CELL_SIZE / 2, y);
            }
            
            if (node.east == null && col == COL_COUNT - 1) {
               float x = col * CELL_SIZE + CELL_SIZE / 2;
               canvas.line(x, row * CELL_SIZE - CELL_SIZE / 2, x, row * CELL_SIZE + CELL_SIZE / 2);
            }
            
         }
      }
   }
   
   public boolean isInBounds(int col, int row) {
      return col > -1 && col < COL_COUNT && row > -1 && row < ROW_COUNT;
   } //<>//
   
   public void display(PGraphics canvas) {
      canvas.stroke(200, 130, 0);
      for (int row = 0; row < ROW_COUNT; row++) {
         for (int col = 0; col < COL_COUNT; col++) {
            MazeNode node = nodes[row][col];
            
            if (node.west == null) {
               float x = col * CELL_SIZE - CELL_SIZE / 2;
               canvas.line(x, row * CELL_SIZE - CELL_SIZE / 2, x, row * CELL_SIZE + CELL_SIZE / 2);
            }
            
            if (node.north == null) {
               float y = row * CELL_SIZE - CELL_SIZE / 2;
               canvas.line(col * CELL_SIZE - CELL_SIZE / 2, y, col * CELL_SIZE + CELL_SIZE / 2, y);
            }
            
            if (node.south == null && row == ROW_COUNT - 1) {
               float y = row * CELL_SIZE + CELL_SIZE / 2;
               canvas.line(col * CELL_SIZE - CELL_SIZE / 2, y, col * CELL_SIZE + CELL_SIZE / 2, y);
            }
            
            if (node.east == null && col == COL_COUNT - 1) {
               float x = col * CELL_SIZE + CELL_SIZE / 2;
               canvas.line(x, row * CELL_SIZE - CELL_SIZE / 2, x, row * CELL_SIZE + CELL_SIZE / 2);
            }
            
         }
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
