public class Wall {
   
   private PVector position;
   private PVector dimensions;
   
   public Wall(PVector position, PVector dimensions) {
      this.position = position;
      this.dimensions = dimensions;
   }
   
   public void display(PGraphics canvas, Camera camera) {
      float canvasTopLeftX = camera.getPosition().x - camera.getDimensions().x / 2;
      float canvasTopLeftY = camera.getPosition().z - camera.getDimensions().y / 2;
      
      float topLeftX = (position.x - dimensions.x / 2) - canvasTopLeftX;
      float topLeftY = (position.z - dimensions.z / 2) - canvasTopLeftY;
      
      noStroke();
      canvas.rect(topLeftX, topLeftY, dimensions.x, dimensions.z);
   }
   
   public PVector getPosition() {
      return position;
   }
   
   public PVector getDimensions() {
      return dimensions;
   }
   
}
