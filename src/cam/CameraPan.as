package cam {
	import cam.Camera;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class CameraPan extends CameraEvent {
		private var normalMoveX:Number;
		private var normalMoveY:Number;
		private var newX:Number;
		private var newY:Number;
		private var distance:Point;
		private var direction:String;
		
		public function CameraPan(cam:Camera, time:int, delay:int, nx:Number, ny:Number, style:Function) {
			super(cam, time, delay, style);
			
			newX = nx;
			newY = ny;
			
			direction = "";
			
			if (!isNaN(newX)) {
				direction += "x";
			}
			if (!isNaN(newY)) {
				direction += "y";
			}
		}
		
		override public function start():void {
			acting = true;
			
			updateProgress();
			distance = new Point(newX - camera.getX(), newY - camera.getY())
			
			normalMoveX = distance.x / runTime;
			normalMoveY = distance.y / runTime;
		}
		
		override public function act():void {
			var xMove:Number;
			var yMove:Number;
			
			xMove = normalMoveX * progress;
			yMove = normalMoveY * progress;
			
			if (direction != "y") {
				camera.moveX(xMove);
			}
			if (direction != "x") {
				camera.moveY(yMove);
			}
		}
	}
}