public static class Keyboard {
   
   private static boolean[] keyDown = new boolean[128];
   
   public static void pressKey(int k) {
      keyDown[k] = true;
   }
   
   public static void releaseKey(int k) {
      keyDown[k] = false;
   }
   
   public static boolean isKeyDown(int k) {
      return keyDown[k];
   }
   
}

void keyPressed() {
   if (keyCode < 0 && keyCode > 90) return;
   Keyboard.pressKey(keyCode);
}

void keyReleased() {
   if (keyCode < 0 && keyCode > 90) return;
   Keyboard.releaseKey(keyCode);
}
