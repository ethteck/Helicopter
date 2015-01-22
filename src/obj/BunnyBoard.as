package obj{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import input.InputKey;
	import input.InputManager;
	import obj.Boulder;
	import obj.BunnyBoard;
	import obj.Player;
	import obj.VehicleType;
	import random.Rndm;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class BunnyBoard extends Player {
		public var acceleration:Number = 2;
		public var maxSpeed:Number = 6;
		
		public var boardGfx:BunnyBoardMC;
		public var fuzzleGfx:FuzzleMC;
		
		public var jitterBase:Number = 0;
		
		public var pulseTime:Number = 3;
		public var pulseSpeed:Number = 0.2;
		
		public var jitterAmount:int = 1;
		
		public var direction:int;
		
		public var rand:Rndm;
		
		public function BunnyBoard(level:Object) {
			super(level);
			
			vehicleType = VehicleType.BUNNYBOARD;
			
			rand = new Rndm();
			gfx = new MovieClip();
			
			direction = 0;
			autoPlaying = false;
			
			drawBoard();
			drawFuzzle();
			addChild(gfx);
		}
		
		public function drawBoard():void {
			boardGfx = new BunnyBoardMC();
			boardGfx.width = 100;
			boardGfx.x = -boardGfx.width * 0.5;
			gfx.addChild(boardGfx);
		}
		
		public function drawFuzzle():void {
			fuzzleGfx = new FuzzleMC();
			fuzzleGfx.y = -15;
			gfx.addChild(fuzzleGfx);
			
			fuzzleGfx.filters = new Array(new GlowFilter(0xFF00FF, 1, 3, 3, 1, 3));
		}
		
		override public function move(wallVec:Vector.<Wall>, keysPressed:InputManager, gameSpeed:Number):void {
			updatePulse(gameSpeed);
			calculateJitter();
			
			if (!autoPlaying) {
				direction = 0;
				if (keysPressed.isKeyPressed(InputKey.UP)) {
					direction += -1;
				}
				if (keysPressed.isKeyPressed(InputKey.DOWN)) {
					direction += 1;
				}
			}
			
			ySpeed += acceleration * direction;
			if (Math.abs(ySpeed) > Math.abs(maxSpeed)) {
				ySpeed = maxSpeed * direction;
			}
			
			ySpeed /= 1.1;
			
			gfx.x += xSpeed * gameSpeed;
			gfx.y += (ySpeed + jitterBase) * gameSpeed;
		}
		
		override public function autoPlay(wallVector:Vector.<Wall>, wallNum:int, keysPressed:InputManager, boulderVector:Vector.<Boulder>):void {
			var currentWall:Wall = Common.getWallAtX(wallVector, gfx.x);
			var lowestPoint:Number = Math.max(Common.getY(currentWall, gfx.x), Common.getY(currentWall, gfx.x + (gfx.width * 0.5)), Common.getY(currentWall, gfx.x - (gfx.width * 0.5)));
			
			minY = lowestPoint + (gfx.height * 0.5) + 25;
			maxY = lowestPoint + Common.getGapHeight(wallNum, levelData) - (gfx.height * 0.5) - 25;
			
			targetY = getTargetY(wallVector, wallNum, boulderVector);
			
			if (gfx.y > targetY) {
				direction = -1;
			}
			if (gfx.y < targetY) {
				direction = 1;
			}
			if (Math.abs(gfx.y - targetY) < 20) {
				direction = 0;
			}
			if (maxY - gfx.y < 15) {
				direction = -1;
			}
			if (gfx.y - minY < 15) {
				direction = 1;
			}
		}
		
		private function updatePulse(gameSpeed:Number):void {
			pulseTime += pulseSpeed * gameSpeed;;
			if(pulseTime > 5 || pulseTime < 3){
				pulseSpeed *= -1;
			}
			boardGfx.filters = new Array(new GlowFilter(0x00009C, 1, pulseTime * 3, pulseTime, (pulseTime / 4) + 1, 3));
		}
		
		private function calculateJitter():void {
			var randomJitter:Number = rand.float(-jitterAmount, jitterAmount);
			jitterBase += randomJitter;
			
			if (jitterBase > jitterAmount) {
				jitterBase = jitterAmount;
			}
			if (jitterBase < -jitterAmount) {
				jitterBase = -jitterAmount;
			}
		}
	}
}