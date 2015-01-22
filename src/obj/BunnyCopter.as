package obj {
	import flash.display.MovieClip;
	import input.InputManager;
	import obj.Boulder;
	import obj.Player;
	import obj.VehicleType;
	import obj.Wall;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class BunnyCopter extends Player {
		public var gravity:Number = 0.5; //0.5
		public var liftAcceleration:Number = 1; //1.5
		
		public var maxLiftSpeed:Number = 7; //7
		public var maxFallSpeed:Number = 10; //12
		
		public var heliBodyGfx:BunnyCopterMC;
		public var propellerGfx:HeliPropellerMC;
		public var tailPropellerGfx:HeliTailMC;
		public var propellerContainer:MovieClip;
		public var rotationContainer:MovieClip;
		
		public var propellerHeight:int = 10;
		
		public var down:Boolean;
		
		public function BunnyCopter(level:Object) {
			super(level);
			
			vehicleType = VehicleType.BUNNYCOPTER;
			
			if (levelData.playerRotation == 0) {
				autoRotate = false;
			}
			else {
				autoRotate = true;
			}
			
			autoPlaying = false;
			
			gfx = new MovieClip();
			rotationContainer = new MovieClip();
			drawHelicopterBody();
			drawPropeller();
			drawTailPropeller();
			gfx.addChild(rotationContainer);
			addChild(gfx);
			
			rotationContainer.x -= (heliBodyGfx.width * 0.5) - 2;
			rotationContainer.y -= (heliBodyGfx.height * 0.5) - 20;
		}
		
		public function drawHelicopterBody():void {
			heliBodyGfx = new BunnyCopterMC();
			rotationContainer.addChild(heliBodyGfx);
		}
		
		public function drawPropeller():void {
			propellerGfx = new HeliPropellerMC();
			propellerContainer = new MovieClip();
			
			propellerContainer.addChild(propellerGfx);
			propellerContainer.height = 16;
			rotationContainer.addChild(propellerContainer);
			
			propellerGfx.x = 28;
			propellerGfx.y = -10 * propellerHeight;
			
			rotationContainer.graphics.lineStyle(1, 0x990000);
			rotationContainer.graphics.moveTo(29, -17);
			rotationContainer.graphics.lineTo(29, -17 - propellerHeight);
		}
		
		public function drawTailPropeller():void {
			tailPropellerGfx = new HeliTailMC();
			
			tailPropellerGfx.x = -20;
			tailPropellerGfx.y = 6;
			
			rotationContainer.graphics.lineStyle(1, 0x990000);
			rotationContainer.graphics.moveTo(tailPropellerGfx.x, 6);
			rotationContainer.graphics.lineTo(tailPropellerGfx.x + 20, 6);
			
			rotationContainer.addChild(tailPropellerGfx);
		}
		
		override public function move(wallVector:Vector.<Wall>, keysPrsesed:InputManager, gameSpeed:Number):void {
			if (!autoPlaying) {
				down = false;
				if (keysPrsesed.isMouseDown()) {
					down = true;
				}
			}
			
			if (down) {
				ySpeed -= liftAcceleration * gameSpeed;
				if (ySpeed < -maxLiftSpeed) {
					ySpeed = -maxLiftSpeed;
				}
			}
			
			ySpeed += gravity * gameSpeed;
			if (ySpeed >= maxFallSpeed) {
				ySpeed = maxFallSpeed;
			}
			
			gfx.x += xSpeed * gameSpeed;
			gfx.y += ySpeed * gameSpeed;
			
			if (autoRotate){
				gfx.rotation = getCaveRotation(wallVector);
			}
			
			var tmpRot:Number = propellerGfx.rotation;
			propellerGfx.rotation += 20 * gameSpeed;
			tailPropellerGfx.rotation += 50 * gameSpeed;
		}
		
		override public function autoPlay(wallVector:Vector.<Wall>, wallNum:int, keysPressed:InputManager, boulderVector:Vector.<Boulder>):void {
			var currentWall:Wall = Common.getWallAtX(wallVector, gfx.x);
			var wallY:Number = Common.getY(currentWall, gfx.x);
			
			minY = wallY + (gfx.height * 0.5) + 25;
			maxY = wallY + Common.getGapHeight(wallNum, levelData) - (gfx.height * 0.5) - 25;
			
			targetY = getTargetY(wallVector, wallNum, boulderVector);
			
			if (gfx.y > targetY) {
				down = true;
			}
			if (gfx.y < targetY) {
				down = false;
			}
		}
	}
}