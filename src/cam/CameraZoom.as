package cam {
	import cam.Camera;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class CameraZoom extends CameraEvent {
		private var oldScale:Number;
		private var newScale:Number;
		private var scaleDiff:Number;
		
		public function CameraZoom(cam:Camera, time:int, delay:int, scale:Number, style:Function) {
			super(cam, time, delay, style);
			
			oldScale = camera.getZoom();
			newScale = scale;
			scaleDiff = newScale - oldScale;
		}
		
		override public function act():void {
			var currentScale:Number = ((tickTime / runTime) * scaleDiff) + oldScale;
			
			camera.setZoom(currentScale);
		}	
	}
}