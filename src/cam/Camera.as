package cam {
	import cam.CameraZoom;
	import cam.CameraRotate;
	import cam.CameraQuake;
	import cam.CameraPan;
	import cam.CameraEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class Camera {
		public var target:Sprite;
		public var actions:Vector.<CameraEvent>;
		public var totalDelay:int;
		private var x:Number;
		private var y:Number;
		private var s:Number;
		private var rotX:Number;
		private var rotY:Number;
		private var rotZ:Number;
		
		public function Camera(tar:Sprite) {
			actions = new Vector.<CameraEvent>;
			target = tar;
			
			totalDelay = 0;
			
			s = 1;
			x = 0;
			y = 0;
			rotX = 0;
			rotY = 0;
			rotZ = 0;
		}
		
		public function wait(time:int):void {
			totalDelay += time;
		}
		
		public function quake(time:int, mag:int, style:Function):void {
			var tmpQuake:CameraQuake = new CameraQuake(this, time, totalDelay, mag, style);
			actions.push(tmpQuake);
		}
		
		public function zoom(time:int, amt:Number, style:Function):void {
			var tmpZoom:CameraZoom = new CameraZoom(this, time, totalDelay, amt, style);
			actions.push(tmpZoom);
		}
		
		public function pan(time:int, nx:Number, ny:Number, style:Function):void {
			var tmpPan:CameraPan = new CameraPan(this, time, totalDelay, nx, ny, style);
			actions.push(tmpPan);
		}
		
		public function panX(time:int, nx:Number, style:Function):void {
			var tmpPan:CameraPan = new CameraPan(this, time, totalDelay, nx, NaN, style);
			actions.push(tmpPan);
		}
		
		public function panY(time:int, ny:Number, style:Function):void {
			var tmpPan:CameraPan = new CameraPan(this, time, totalDelay, NaN, ny, style);
			actions.push(tmpPan);
		}
		
		public function rotate(time:int, rx:Number, ry:Number, rz:Number, style:Function):void {
			var tmpRot:CameraRotate = new CameraRotate(this, time, totalDelay, rx, ry, rz, style);
			actions.push(tmpRot);
		}
		
		public function rotateX(time:int, rx:Number, style:Function):void {
			var tmpRot:CameraRotate = new CameraRotate(this, time, totalDelay, rx, NaN, NaN, style);
			actions.push(tmpRot);
		}
		
		public function rotateY(time:int, ry:Number, style:Function):void {
			var tmpRot:CameraRotate = new CameraRotate(this, time, totalDelay, NaN, ry, NaN, style);
			actions.push(tmpRot);
		}
		
		public function rotateZ(time:int, rz:Number, style:Function):void {
			var tmpRot:CameraRotate = new CameraRotate(this, time, totalDelay, NaN, NaN, rz, style);
			actions.push(tmpRot);
		}
		
		public function onTick():void {
			for each (var action:CameraEvent in actions) {
				if (action.complete) {
					actions.splice(actions.indexOf(action), 1);
				}
				else {
					action.tick();
				}
			}
			if (actions.length == 0) {
				totalDelay = 0;
			}
			update();
		}
		
		public function getX():Number {
			return x;
		}
		
		public function setX(val:Number):void {
			x = val;
		}
		
		public function moveX(val:Number):void {
			setX(x + val);
		}
		
		public function getY():Number {
			return y;
		}
		
		public function setY(val:Number):void {
			y = val;
		}
		
		public function moveY(val:Number):void {
			y = (y + val);
		}
		
		public function getRotationX():Number {
			return rotX
		}
		
		public function moveRotationX(val:Number):void {
			rotX += val;
		}
		
		public function getRotationY():Number {
			return rotY
		}
		
		public function moveRotationY(val:Number):void {
			rotY += val;
		}
		
		public function getRotationZ():Number {
			return rotZ
		}
		
		public function moveRotationZ(val:Number):void {
			rotZ += val;
		}
		
		public function getZoom():Number {
			return s;
		}
		
		public function setZoom(val:Number):void {
			s = val;
		}
		
		public function update():void {
			target.x = 320 - x;
			target.y = 240 - y;
			target.scaleX = s;
			target.scaleY = s;
			target.rotationX = rotX;
			target.rotationY = rotY;
			target.rotationZ = rotZ;
		}
	}
}