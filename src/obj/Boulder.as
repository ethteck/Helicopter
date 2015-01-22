
package obj {
	import obj.Obstacle;
	import random.Rndm;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class Boulder extends Obstacle{
		public var rotateAmount:Number;
		
		public function Boulder(rand:Rndm) {
			gfx = new SmallBoulderMC();
			addChild(gfx);
			
			rotateAmount = rand.float(2, 6);
			rotateAmount *= rand.sign();
		}
		
	}

}