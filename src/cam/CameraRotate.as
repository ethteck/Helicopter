package cam {
	import cam.Camera;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class CameraRotate extends CameraEvent {
		private var normalMoveX:Number;
		private var normalMoveY:Number;
		private var normalMoveZ:Number;
		private var newX:Number;
		private var newY:Number;
		private var newZ:Number;
		private var xDistance:Number;
		private var yDistance:Number;
		private var zDistance:Number;
		private var xBool:Boolean;
		private var yBool:Boolean;
		private var zBool:Boolean;
		
		public function CameraRotate(cam:Camera, time:int, delay:int, nx:Number, ny:Number, nz:Number, style:Function) {
			super(cam, time, delay, style);
			
			newX = nx;
			newY = ny;
			newZ = nz;
			
			if (!isNaN(newX)) {
				xBool = true;
			}
			if (!isNaN(newY)) {
				yBool = true;
			}
			if (!isNaN(newZ)) {
				zBool = true;
			}
		}
		
		override public function start():void {
			acting = true;
			
			updateProgress();
			if (xBool) {
				xDistance = newX - camera.getRotationX();
				normalMoveX = xDistance / runTime;
			}
			if (yBool) {
				yDistance = newY - camera.getRotationY();
				normalMoveY = yDistance / runTime;
			}
			if (zBool) {
				zDistance = newZ - camera.getRotationZ();
				normalMoveZ = zDistance / runTime;
			}
		}
		
		override public function act():void {
			if (xBool) {
				camera.moveRotationX(normalMoveX * progress);
			}
			if (yBool) {
				camera.moveRotationY(normalMoveY * progress);
			}
			if (zBool) {
				camera.moveRotationZ(normalMoveZ * progress);
			}
		}
	}
}