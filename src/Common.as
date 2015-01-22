package  {
	import flash.geom.Point;
	import obj.Wall;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class Common {
		public static const GAMEWIDTH:int = 640;
		public static const GAMEHEIGHT:int = 480;
		
		public static function getWallWidth(wallNum:int, data:Object):int {
			return data.widthStart + (wallNum * data.widthChange);
		}
		
		public static function getGapHeight(wallNum:int, levelData:Object):Number {
			switch (levelData.heightChangeRate) {
				case "none":
					return levelData.heightStart;
				case "slight":
					return (levelData.heightStart - levelData.heightMin) * Math.pow(Math.E, -0.01 * wallNum) + levelData.heightMin;
				case "normal":
					return (levelData.heightStart - levelData.heightMin) * Math.pow(Math.E, -0.02 * wallNum) + levelData.heightMin;
			}
			trace("Error: invalid heightChangeRate string");
			return NaN;
		}
		
		public static function getSlope(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, t:Number):Number {
			var dy:Number = y0 - y1 + t * (-y0 -2 * -y1 - y2);
			var dx:Number = -x0 + x1 + t * (x0 -2 * x1 + x2);
			return (dy / dx);
		}
		
		public static function getY(wall:Wall, x:Number):Number {
			var t:Number = (x - wall.x) / wall.wallWidth;
			return (wall.P0.y * (1-t) * (1-t)) + (wall.P1.y * ((2 * t) - (2 * t * t))) + (wall.P2.y * t * t);
		}
		
		public static function getWallNumAtX(wallVector:Vector.<Wall>, xPos:Number):int {
			for (var i:int = 0; i < wallVector.length; i++) {
				if (xPos >= wallVector[i].x && xPos <= wallVector[i].x + wallVector[i].wallWidth) {
					return i;
				}
			}
			throw new Error("Cannot get wall number at x position " + xPos);
			return NaN;
		}
		
		public static function getWallAtX(wallVector:Vector.<Wall>, xPos:Number):Wall {
			return wallVector[getWallNumAtX(wallVector, xPos)];
		}
		
		public static function roundToDecimal(num:Number, places:int):Number {
			return Math.round(num * Math.pow(10, places)) / Math.pow(10, places);
		}
		
		public static function toDegrees(rad:Number):Number {
			return rad * 180 / Math.PI;
		}
		
		public static function toRadians(deg:Number):Number {
			return deg / 180 * Math.PI;
		}
	}
}