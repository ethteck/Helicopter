import powerup.Powerup;
package powerup pu {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class PowerupSlow extends Powerup {
		var baseGfx:SlowPowerupMC;
		var arrowGfx:SlowPowerupArrowMC;
		
		public function PowerupSlow() {
			super(200);
			
			gfx = new MovieClip();
			baseGfx = new SlowPowerupMC();
			arrowGfx = new SlowPowerupArrowMC();
			gfx.addChild(baseGfx);
			gfx.addChild(arrowGfx);
			
		}
		
	}

}