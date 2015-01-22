package cam {
	import cam.CameraEvent;
	import cam.Camera;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Ethan Roseman and Lee Berman
	 */
	public class CameraEvent {
		public var camera:Camera;
		public var tickTime:int;
		public var runTime:int;
		public var acting:Boolean = false;
		public var complete:Boolean = false;
		public var progress:Number;
		public var style:Function;
		
		public function CameraEvent(cam:Camera, time:int, delay:int, styl:Function) {
			camera = cam;
			runTime = time;
			tickTime = -delay - 1;
			style = styl;
		}
		
		public function start():void {
			acting = true;
		}
		
		private function finish():void {
			acting = false;
			complete = true;
			finished();
		}
		
		public function tick():void {
			tickTime++;
			if (tickTime == 0) {
				start();
			}
			else if (acting) {
				updateProgress();
				act();
				if (tickTime >= runTime) {
					finish();
				}
			}
		}
		
		public function updateProgress():void {
			progress = style(tickTime / runTime);
			trace(progress);
		}
		
		public function act():void {
			
		}
		
		public function finished():void { //DO WE NEED THIS | ...many days later, //YES
			
		}
	}
}