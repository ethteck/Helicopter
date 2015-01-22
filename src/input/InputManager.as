package input {
	import input.InputKey;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class InputManager {
		public static var keys:Vector.<int>;
		
		public function InputManager() {
			keys = new Vector.<int>;
		}
		
		public function add(key:int):void {
			if (keys.indexOf(key) == -1) {
				keys.push(key);
			}
		}
		
		public function remove(key:int):void {
			if (keys.indexOf(key) != -1){
				keys.splice(keys.indexOf(key), 1);
			}
		}
		
		public function isMouseDown():Boolean {
			return isKeyPressed(InputKey.MOUSELEFT);
		}
		
		public function isKeyPressed(key:int):Boolean {
			if (keys.indexOf(key) != -1) {
				return true;
			}
			return false;
		}
	}
}