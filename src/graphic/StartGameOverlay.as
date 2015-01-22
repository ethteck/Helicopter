package graphic {
	import obj.VehicleType;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class StartGameOverlay extends Sprite
	{
		private var gfx:StartGameMC;
		private var startText:TextField;
		
		public function StartGameOverlay(shipType:int) {
			gfx = new StartGameMC();
			gfx.x = 200;
			gfx.y = 150;
			addChild(gfx);
			
			gfx.mouseEnabled = false;
			gfx.mouseChildren = false;
			mouseEnabled = false;
			mouseChildren = false;
			
			drawUnpauseText(shipType);
		}
		
		private function drawUnpauseText(shipType:int):void {
			startText = new TextField();
			
			var tmpButtonString:String;
			if (shipType == VehicleType.BUNNYBOARD) {
				tmpButtonString = "Press one of the arrow keys";
			}
			else {
				tmpButtonString = "Left click";
			}
			
			startText.defaultTextFormat = new TextFormat(null, 12, 0xFFFFFF);
			startText.selectable = false;
			startText.x = 210;
			startText.y = 220;
			startText.width = 200;
			startText.text = tmpButtonString + " to start!";
			
			addChild(startText);
		}
	}
}