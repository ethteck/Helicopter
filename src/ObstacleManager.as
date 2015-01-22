package  {
	import ObjectManager;
	import obj.Obstacle;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class ObstacleManager implements ObjectManager {
		private var game:HelicopterGame;
		private var boulderRate:int;
		private var boulderTick:int;
		
		public function ObstacleManager(game:HelicopterGame, levelData:Object) {
			this.game = game;
			boulderRate = levelData.boulderRate;
			
			getTicks();
		}
		
		public function tick():Obstacle {
			boulderTick--;
			//otherTicks here
			
			if (boulderInterval == 0) {
				return createBoulder();
				boulderInterval = boulderRate;
			}
		}
		
		private function getTicks():void {
			boulderInterval = boulderRate;
		}
		
		private function createBoulder();
		
	}

}