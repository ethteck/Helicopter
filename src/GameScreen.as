package {
	import input.InputManager;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class GameScreen extends Sprite{
		public function GameScreen() {
			
		}
		
		public function handleMouse(e:Event):void {
			//to be overridden
		}
		
		public function onTick(keysPressed:InputManager):void {
			//to be ticked
		}
	}
}