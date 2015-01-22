package obj {
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class Laser extends Sprite{
		public var gfx:LaserMC;
		public var vector:Point;
		
		public function Laser(vec:Point) {
			vector = vec;
			gfx = new LaserMC();
			addChild(gfx);
			
			filters = new Array(new GlowFilter(0x0000FF, 1, 0, 6 , 1, BitmapFilterQuality.MEDIUM));
		}
		
	}

}