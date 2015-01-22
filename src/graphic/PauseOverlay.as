package graphic {
	import obj.VehicleType;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class PauseOverlay extends Sprite
	{
		private var gfx:PauseMenuMC;
		private var unpauseText:TextField;
		
		public function PauseOverlay(shipType:int) {
			gfx = new PauseMenuMC();
			gfx.x = 120;
			gfx.y = 80;
			addChild(gfx);
			
			drawUnpauseText(shipType);
		}
		
		private function drawUnpauseText(shipType:int):void {
			unpauseText = new TextField();
			
			var tmpUnpauseString:String;
			if (shipType == VehicleType.BUNNYBOARD) {
				tmpUnpauseString = "Press one of the arrow keys";
			}
			else {
				tmpUnpauseString = "Left click";
			}
			unpauseText.text = tmpUnpauseString + " or press 'P' to unpause.";
			
			unpauseText.selectable = false;
			unpauseText.x = 200;
			unpauseText.y = 200;
			unpauseText.width = 200;
			
			addChild(unpauseText);
		}
		
	}

}