package cam {
	import cam.Camera;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class CameraQuake extends CameraEvent {
		private var offset:Point;
		private var oldOffset:Point;
		private var intensity:Number;
		private var maxIntensity:Number;
		private var intensityOffset:Number;
		
		public function CameraQuake(cam:Camera, time:int, delay:int, intensity:Number, style:Function) {
			super(cam, time, delay, style);
			
			offset = new Point();
			oldOffset = new Point();
			maxIntensity = intensity;
			
			intensityOffset = intensity / 2;
		}
		
		override public function start():void {
			acting = true;
			
			updateProgress();
			intensity = progress * maxIntensity;
		}
		
		override public function act():void {
			intensity = progress * maxIntensity;
			
			offset = new Point(Math.random() * intensity - intensityOffset, Math.random() * intensity - intensityOffset);
			
			camera.moveX(offset.x - oldOffset.x);
			camera.moveY(offset.y - oldOffset.y);
			
			oldOffset = offset;
		}	
		
		override public function finished():void {
			camera.moveX(-oldOffset.x);
			camera.moveY(-oldOffset.y);
		}
	}
}