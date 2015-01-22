package obj {
	import flash.geom.Point;
	import input.InputManager;
	import obj.Boulder;
	import obj.Laser;
	import obj.Player;
	import obj.VehicleType;
	import obj.Wall;
	import random.Rndm;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class BunnyShip extends Player {
		public var gunRotateSpeed:Number = 10;
		public var maxSpeed:Number = 7; //5
		public var rand:Rndm;
		
		public var gunGfx:ShipGunMC;
		
		public function BunnyShip(level:Object) {
			super(level);
			
			vehicleType = VehicleType.BUNNYSHIP;
			
			if (levelData.playerRotation == 0) {
				autoRotate = false;
			}
			else {
				autoRotate = true;
			}
			
			autoPlaying = false;
			
			rand = new Rndm();
			
			gfx = new BunnyShipMC();
			gunGfx = new ShipGunMC();
			gunGfx.x = -10;
			gunGfx.y = 10;
			gfx.addChild(gunGfx);
			addChild(gfx);
		}
		
		override public function move(wallVector:Vector.<Wall>, keysPressed:InputManager, gameSpeed:Number):void {
			if (!autoPlaying) {
				targetX = parent.mouseX;
				targetY = parent.mouseY;
			}
			
			var dx:int = targetX - gfx.x;
			var dy:int = targetY - gfx.y;
			
			xSpeed = dx / 5;
			ySpeed = dy / 5;
			
			if (xSpeed > maxSpeed) {
				xSpeed = maxSpeed;
			}
			if (xSpeed < -maxSpeed) {
				xSpeed = -maxSpeed;
			}
			if (ySpeed > maxSpeed) {
				ySpeed = maxSpeed;
			}
			if (ySpeed < -maxSpeed) {
				ySpeed = -maxSpeed;
			}
			
			//gfx.x += xSpeed * gameSpeed;
			gfx.y += ySpeed * gameSpeed;
			
			if (autoRotate){
				gfx.rotation = getCaveRotation(wallVector);
			}
			
			rotateGun(gameSpeed);
		}
		
		private function rotateGun(gameSpeed:Number):void {
			var dx:int = parent.mouseX - gfx.x - gunGfx.x;
			var dy:int = parent.mouseY - gfx.y - gunGfx.y;
			
			var angle:Number = Math.atan2(dy, dx);
			var gunRotation:Number = gunGfx.rotation + gfx.rotation + 180;
			var targetRotation:Number = Common.toDegrees(angle) + 180;

			var rotationDifference:Number = Math.abs(gunRotation - targetRotation);
			var rotationDifferencePlus:Number = Math.abs(gunRotation - targetRotation + 360);
			var rotationDifferenceMinus:Number = Math.abs(gunRotation - targetRotation - 360);
			
			if (rotationDifference <= gunRotateSpeed || rotationDifferencePlus <= gunRotateSpeed || rotationDifferenceMinus <= gunRotateSpeed) {
				gunRotation = targetRotation;
			}
			else {
				if (gunRotation > 180) {
					if (targetRotation > gunRotation - 180 && targetRotation < gunRotation) {
						
						gunRotation -= gunRotateSpeed;
					}
					else {
						gunRotation += gunRotateSpeed;
					}
				}
				else {
					if (targetRotation < gunRotation + 180 && targetRotation > gunRotation) {
						gunRotation += gunRotateSpeed;
					}
					else {
						gunRotation -= gunRotateSpeed;
					}
				}
			}
			gunGfx.rotation = gunRotation - gfx.rotation - 180;
		}
		
		override public function autoPlay(wallVector:Vector.<Wall>, wallNum:int, keysPressed:InputManager, boulderVector:Vector.<Boulder>):void {
			var currentWall:Wall = Common.getWallAtX(wallVector, gfx.x);
			minY = Common.getY(currentWall, gfx.x) + (gfx.height * 0.5) + 5;
			maxY = Common.getY(currentWall, gfx.x) + Common.getGapHeight(wallNum, levelData) - (gfx.height * 0.5) - 5;
			
			targetY = getTargetY(wallVector, wallNum, boulderVector);
		}
		
		public function shoot():Laser {
			var shootAngle:Number = Common.toRadians(gunGfx.rotation + gfx.rotation)
			
			var ptX:Number = 30 * Math.cos(shootAngle);
			var ptY:Number = 30 * Math.sin(shootAngle);
			var pt:Point = new Point(ptX, ptY);
			
			var laser:Laser = new Laser(pt);
			laser.gfx.x = gfx.x + gunGfx.x;
			laser.gfx.y = gfx.y + gunGfx.y;
			laser.gfx.rotation = gunGfx.rotation + gfx.rotation;
			
			return laser;
		}
	}
}