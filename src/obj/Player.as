package obj {
	import obj.Wall;
	import obj.Boulder;
	import input.InputManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point
	
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class Player extends Sprite {
		public var levelData:Object;
		
		public var vehicleType:int;
		
		public var xSpeed:Number;
		public var ySpeed:Number;
		
		public var targetX:Number;
		public var targetY:Number;
		
		public var minY:Number;
		public var maxY:Number;
		
		public var range:Vector.<Point>;
		
		public var autoPlaying:Boolean;
		public var autoRotate:Boolean;
		
		public var gfx:MovieClip;
		
		public function Player(level:Object) {
			levelData = level;
			
			xSpeed = 0;
			ySpeed = 0;
		}
		
		public function move(wallVec:Vector.<Wall>, keysPressed:InputManager, gameSpeed:Number):void {
			//To be overridden
		}
		
		public function autoPlay(wallVec:Vector.<Wall>, wallNum:int, keysPressed:InputManager, boulderVector:Vector.<Boulder>):void {
			//To be overridden
		}
		
		//Returns a target y-value for autoplay
		public function getTargetY(wallVector:Vector.<Wall>, wallNum:int, boulderVector:Vector.<Boulder>):Number {
			var currentBoulder:Boulder;
			var maxRange:Point;
			
			if (boulderVector.length == 0) {
				targetY = minY + maxY - gfx.y;
			}
			else {
				for (var i:int = boulderVector.length - 1; i > -1; i--) {
					var playerCutoff:Number = gfx.x - (gfx.width * 0.5) - (boulderVector[i].width * 0.5); //fix this? (refer to todo)
					if (boulderVector[i].x > playerCutoff) {
						currentBoulder = boulderVector[i];
					}
				}
				
				range = new Vector.<Point>;
					
				var boulderWall:Wall = Common.getWallAtX(wallVector, currentBoulder.x);
				var boulderCaveY:Number = Common.getY(boulderWall, currentBoulder.x);
					
				range.push(new Point(boulderCaveY, currentBoulder.y - (currentBoulder.gfx.height * 0.5)));
				range.push(new Point(currentBoulder.y + (currentBoulder.gfx.height * 0.5), boulderCaveY + boulderWall.gapHeight));
				
				maxRange = range[0];
				
				for (i = 0; i < range.length; i++) {
					if (range[i].y - range[i].x > maxRange.y - maxRange.x) {
						maxRange = range[i];
					}
				}
				
				targetY = (maxRange.y + maxRange.x) * 0.5;
				
				if (targetY < minY) {
					targetY = minY;
				}
				if (targetY > maxY) {
					targetY = maxY;
				}
			}
			return targetY;
		}
		
		//Returns a rotation amount so that the vehicle's rotation matches the slope of the cave
		public function getCaveRotation(wallVec:Vector.<Wall>):Number {
			var currentWall:int = Common.getWallNumAtX(wallVec, gfx.x);
			
			var tmpT:Number = (gfx.x - wallVec[currentWall].x) / wallVec[currentWall].wallWidth
			var tmpWall:Wall = wallVec[currentWall];
			
			var tmpSlope:Number = Common.getSlope(0, tmpWall.gapStart, tmpWall.P1.x, tmpWall.P1.y, tmpWall.width, tmpWall.gapEnd, tmpT);
			var tmpRotation:Number = -(Math.atan(tmpSlope) * 180 / Math.PI) - 1;
			return tmpRotation;
		}
	}
}