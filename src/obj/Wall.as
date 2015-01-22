package obj {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import obj.Wall;
	import random.Rndm;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class Wall extends MovieClip
	{
		public var wallNumber:int;
		public var rand:Rndm;
		public var wallData:Object;
		
		public var gapHeight:Number;
		public var gapStart:int;
		public var gapEnd:int;
		public var wallWidth:Number;
		public var wallBuffer:int;
		public var maxGapChange:int;
		
		public var P0:Point;
		public var P1:Point;
		public var P2:Point;
		
		public var wallTop:MovieClip;
		public var wallBottom:MovieClip;
		
		public function Wall(rand:Rndm, num:int, levelData:Object, previousWall:Wall = null) {
			wallNumber = num;
			this.rand = rand;
			wallData = levelData;
			
			wallTop = new MovieClip();
			wallBottom = new MovieClip();
			
			//add an initialize function (or create or something)
			gapHeight = Common.getGapHeight(wallNumber, wallData);
			wallWidth = Common.getWallWidth(wallNumber, wallData);
			
			wallBuffer = wallData.buffer;
			maxGapChange = wallData.maxMove;
			
			if (previousWall == null) {
				gapStart = rand.integer(wallBuffer, Common.GAMEHEIGHT - gapHeight - wallBuffer);
				P0 = new Point(0, gapStart);
				
				P1 = new Point(wallWidth * 0.5, rand.integer((gapStart + gapEnd * 0.5) + wallBuffer,(gapStart + gapEnd * 0.5) - wallBuffer));
				//P1 = new Point(wallWidth * 0.5, 100);
				gapEnd = rand.integer(Math.max(gapStart - wallBuffer, wallBuffer), Math.min(gapStart + wallBuffer, Common.GAMEHEIGHT - gapHeight - wallBuffer));
			}
			else {
				gapStart = previousWall.gapEnd;
				P0 = new Point(0, gapStart);
				P1 = getAnchorPoint(previousWall.P1);
				gapEnd = getGapEnd();
			}
			
			P2 = new Point(wallWidth, gapEnd);
			
			wallTop.graphics.beginFill(0x5C3317);
			wallTop.graphics.moveTo(P2.x, P2.y);
			wallTop.graphics.lineTo(P2.x, 0);
			wallTop.graphics.lineTo(0, 0);
			wallTop.graphics.lineTo(P0.x, P0.y);
			wallTop.graphics.curveTo(P1.x, P1.y, P2.x, P2.y);
			wallTop.graphics.endFill();
			
			wallBottom.graphics.beginFill(0x5C3317);
			wallBottom.graphics.moveTo(P2.x, P2.y + gapHeight);
			wallBottom.graphics.lineTo(P2.x, Common.GAMEHEIGHT);
			wallBottom.graphics.lineTo(0, Common.GAMEHEIGHT);
			wallBottom.graphics.lineTo(P0.x, P0.y + gapHeight);
			wallBottom.graphics.curveTo(P1.x, P1.y + gapHeight, P2.x, P2.y + Common.getGapHeight(wallNumber + 1, wallData));
			wallBottom.graphics.endFill();
			
			//lines
			/*wallBottom.graphics.lineStyle(5, 0x00FF00);
			wallBottom.graphics.moveTo(0, 0);
			wallBottom.graphics.lineTo(0, HelperMethods.GAMEHEIGHT);*/
			
			addChild(wallTop);
			addChild(wallBottom);
		}
		
		//This function returns a y coordinate for P2, which I call "gap end"
		public function getGapEnd():Number {
			var maxStep:int = 3;
			var maxNumTries:int = 100;
			var currentTry:int = 0;
			var testP2:Point;
			while (currentTry++ < maxNumTries) {
				testP2 = new Point(wallWidth, rand.integer(Math.min(gapStart + maxGapChange, Common.GAMEHEIGHT - Common.getGapHeight(wallNumber + 1, wallData) - wallBuffer), Math.max(gapStart - maxGapChange, wallBuffer)));
				if (tryCave(P0, P1, testP2, maxStep, maxStep)){
					return testP2.y;
				}
			}
			trace("IMPOSSIBLE CURVE SET, ATTEMPTING TO WORK THROUGH IT ANYWAY");
			return testP2.y;
		}
		
		public function tryCave(oldP0:Point, oldP1:Point, oldP2:Point, step:int, maxStep:int):Boolean {
			if (step <= 0)
				return true;
			
			var maxNumTries:int = 1000;
			var currentTry:int = 0;
			
			var lastCurveEndSlope:Number = Common.getSlope(oldP0.x, oldP0.y, oldP1.x, oldP1.y, oldP2.x, oldP2.y, 1);
			
			while (currentTry++ < maxNumTries) {
				var tmpWidth:Number = Common.getWallWidth(wallNumber + (maxStep - step), wallData);
				var tmpGapHeight:Number = Common.getGapHeight(wallNumber + (maxStep - step), wallData);
				
				var tmpMin:int = Math.max(oldP2.y - maxGapChange, wallBuffer);
				var tmpMax:int = Math.min(oldP2.y + maxGapChange, Common.GAMEHEIGHT - tmpGapHeight - wallBuffer);
				
				var p2:Point = new Point(tmpWidth, rand.integer(tmpMin, tmpMax));
				var p0:Point = new Point(0, oldP2.y);
				
				var p1X:Number = (p2.x + p0.x) * 0.5;
				var p1Y:Number = (lastCurveEndSlope * -p1X) + oldP2.y;
				
				var p1:Point = new Point(p1X, p1Y);
				var t:Number = (p0.y - p1.y) / (p0.y - 2 * p1.y + p2.y);
				
				//used to calculate whether the curve will go off screen
				var tmpPOI:Number = (p0.y * Math.pow(1 - t, 2)) + (p1.y * ((2 * t) - (2 * (t * t)))) + (p2.y * t * t);
				
				if ((t < 0 || t > 1) || (tmpPOI < Common.GAMEHEIGHT - tmpGapHeight - wallBuffer && tmpPOI > wallBuffer)) {		
					return tryCave(p0, p1, p2, step - 1, maxStep);
				}
			}
			return false;
		}
		
		public function getAnchorPoint(wallPoint:Point):Point {
			var tmpX:Number = wallWidth * 0.5;
			var tmpM:Number = Common.getSlope(P0.x, P0.y, wallPoint.x, wallPoint.y, wallWidth, gapStart, 1);
			var tmpY:int = (tmpM * ( -tmpX) + gapStart);
			return new Point(tmpX, tmpY);
		}
	}
}