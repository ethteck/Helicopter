package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class Wall extends MovieClip
	{
		public var rnd:Rndm;
		
		public var screenHeight:int;
		
		public var gapHeight:Number;
		public var gapHeightChange:Number;
		public var gapStart:int;
		public var gapEnd:int;
		public var wallWidth:Number;
		
		public var wallContainer:Vector.<Wall>;
		
		public var P0:Point;
		public var P1:Point;
		public var P2:Point;
		
		public var wallTop:MovieClip;
		public var wallBottom:MovieClip;
		
		public function Wall(gpStart:int, gpHeight:Number, wWidth:Number, screenH:int, gpHeightChange:Number, wContainer:Vector.<Wall>, rand:Rndm) {
			wallTop = new MovieClip();
			wallBottom = new MovieClip();
			
			wallContainer = wContainer;
			
			gapStart = gpStart;
			gapHeight = gpHeight;
			gapHeightChange = gpHeightChange;
			wallWidth = wWidth;
			screenHeight = screenH;
			rnd = rand;
			
			if (wallContainer.length == 0) {
				gapStart = 50;//getRandomBetween(0, 400 - gapHeight)
				gapEnd = 100;
			}
			else {
				gapEnd = getGapEnd();
			}
			
			P0 = new Point(0, gapStart); 
			P2 = new Point(wallWidth, gapEnd);
			P1 = getAnchorPoint();
			
			var tmpT:Number = (P0.y - P1.y) / (P0.y -2*P1.y + P2.y);
			var tmpT2:int = 0;
			var tmpT3:int = 1;
			
			trace("t: " + (P0.y*Math.pow(1 - tmpT,2) + (P1.y * (2*tmpT - 2 * Math.pow(tmpT, 2))) + P2.y * Math.pow(tmpT, 2)), "0: " + (P0.y*Math.pow(1 - tmpT2,2) + (P1.y * (2*tmpT2 - 2 * Math.pow(tmpT2, 2))) + P2.y * Math.pow(tmpT2, 2)), "1: " + (P0.y*Math.pow(1 - tmpT3,2) + (P1.y * (2*tmpT3 - 2 * Math.pow(tmpT3, 2))) + P2.y * Math.pow(tmpT3, 2)))
			trace("tval: " + tmpT);
			
			wallTop.graphics.beginFill(0x5C3317);
			wallTop.graphics.moveTo(P2.x, P2.y);
			wallTop.graphics.lineTo(P2.x, 0);
			wallTop.graphics.lineTo(0, 0);
			wallTop.graphics.lineTo(P0.x, P0.y);
			wallTop.graphics.curveTo(P1.x, P1.y, P2.x, P2.y);
			wallTop.graphics.endFill();
			
			wallBottom.graphics.beginFill(0x5C3317);
			wallBottom.graphics.moveTo(P2.x, P2.y + gapHeight);
			wallBottom.graphics.lineTo(P2.x, screenHeight);
			wallBottom.graphics.lineTo(0, screenHeight);
			wallBottom.graphics.lineTo(P0.x, P0.y + gapHeight);
			wallBottom.graphics.curveTo(P1.x, P1.y + gapHeight, P2.x, P2.y + gapHeight + gpHeightChange);
			wallBottom.graphics.endFill();
			
			wallBottom.graphics.lineStyle(3, 0x00FF00);
			wallBottom.graphics.moveTo(0, 0);
			wallBottom.graphics.lineTo(0, screenHeight);
			
			wallBottom.graphics.lineStyle(0, 0);
			wallBottom.graphics.beginFill(0xFF0000, 1);
			wallBottom.graphics.drawRect(P1.x, P1.y, 10, 10);
			wallBottom.graphics.endFill();
			
			addChild(wallTop);
			addChild(wallBottom);
		}
		
		public function getGapEnd(anchorY:int = 0):Number {
			var tmpMin:Number = Math.max(gapStart - 100, 50);
			var tmpMax:Number = Math.min(gapStart + 100, screenHeight - gapHeight - 5);
			
			if (anchorY != 0) {
				tmpMin = -P0.y - (2 * anchorY);
				tmpMax = -P0.y - (2 * anchorY) - (4 * gapHeight) + (4 * screenHeight);
			}
			
			var tmpGap:Number = getRandomBetween(tmpMin, tmpMax);
			
			if (anchorY != 0) {
				var tmpTop:Number = (0.25 * P0.y) + (0.5 * anchorY) + (0.25 * tmpGap)
				trace(tmpMin, tmpMax, tmpTop);
			}
			
			return tmpGap;
		}
		
		public function getAnchorPoint(changing:Boolean = false):Point {
			var tmpX:Number = wallWidth * 0.5;
			
			if (wallContainer.length == 0) {
				return new Point(tmpX, (P0.y + P2.y) * 0.5);
				var tmpYMin:Number = 0.5 * (-P0.y - P2.y);
				var tmpYMax:Number = 0.5 * ( -P0.y - P2.y -(4 * gapHeight) + (4 * screenHeight));
				trace(tmpYMin, tmpYMax);
				
				return new Point(tmpX, getRandomBetween(tmpYMin, tmpYMax));
			}
			
			else {
				var tmpWall:Wall = wallContainer[wallContainer.length - 1];
				if (changing && wallContainer.length > 1) tmpWall = wallContainer[wallContainer.length - 2];
				var tmpM:Number = getSlope(P0.x, P0.y, tmpWall.P1.x, tmpWall.P1.y, P2.x, gapStart, 1);  //P2.y may need to be gapStart instead
				var tmpY:int = (tmpM * ( -tmpX) + gapStart);
				
				var tunnelTop:Number = (0.25 * P0.y) + (0.5 * tmpY) + (0.25 * P2.y);
				var tunnelBottom:Number = tunnelTop + gapHeight;
				
				if (tunnelTop < 0 || tunnelBottom > screenHeight) {
					trace("problem!");
					P2.y = getGapEnd(tmpY);
					return getAnchorPoint();
				}
				
				return new Point(tmpX, tmpY);
			}
		}
		
		public function getSlope(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, t:Number):Number {
			y0 = screenHeight - y0;
			y1 = screenHeight - y1;
			y2 = screenHeight - y2;
			
			var dy:Number = -y0 + y1 + t * (y0 -2 * y1 + y2);
			var dx:Number = -x0 + x1 + t * (x0 -2 * x1 + x2);
			return (dy / dx);
		}
		
		public function getRandomBetween(min:Number, max:Number):int {
			return (rnd.random() * (max + 1 - min)) + min;
		}
		
		public function changeGapHeight(amt:int):void {
			gapEnd += amt;
			trace(gapEnd);
			
			removeChild(wallTop);
			removeChild(wallBottom);
			
			wallTop = new MovieClip();
			wallBottom = new MovieClip();
			
			P0 = new Point(0, gapStart);
			P2 = new Point(wallWidth, gapEnd);
			P1 = getAnchorPoint(true);
			
			var tmpT:Number = (P0.y - P1.y) / (P0.y -2*P1.y + P2.y);
			var tmpT2:int = 0;
			var tmpT3:int = 1;
			
			trace("t: " + (P0.y*Math.pow(1 - tmpT,2) + (P1.y * (2*tmpT - 2 * Math.pow(tmpT, 2))) + P2.y * Math.pow(tmpT, 2)), "0: " + (P0.y*Math.pow(1 - tmpT2,2) + (P1.y * (2*tmpT2 - 2 * Math.pow(tmpT2, 2))) + P2.y * Math.pow(tmpT2, 2)), "1: " + (P0.y*Math.pow(1 - tmpT3,2) + (P1.y * (2*tmpT3 - 2 * Math.pow(tmpT3, 2))) + P2.y * Math.pow(tmpT3, 2)))
			trace("tval: " + tmpT);
			
			wallTop.graphics.beginFill(0x5C3317);
			wallTop.graphics.moveTo(P2.x, P2.y);
			wallTop.graphics.lineTo(P2.x, 0);
			wallTop.graphics.lineTo(0, 0);
			wallTop.graphics.lineTo(P0.x, P0.y);
			wallTop.graphics.curveTo(P1.x, P1.y, P2.x, P2.y);
			wallTop.graphics.endFill();
			
			wallBottom.graphics.beginFill(0x5C3317);
			wallBottom.graphics.moveTo(P2.x, P2.y + gapHeight);
			wallBottom.graphics.lineTo(P2.x, screenHeight);
			wallBottom.graphics.lineTo(0, screenHeight);
			wallBottom.graphics.lineTo(P0.x, P0.y + gapHeight);
			wallBottom.graphics.curveTo(P1.x, P1.y + gapHeight, P2.x, P2.y + gapHeight + gapHeightChange);
			wallBottom.graphics.endFill();
			
			wallBottom.graphics.lineStyle(5, 0x00FF00);
			wallBottom.graphics.moveTo(0, 0);
			wallBottom.graphics.lineTo(0, screenHeight);
			
			addChild(wallTop);
			addChild(wallBottom);
		}
	}
}