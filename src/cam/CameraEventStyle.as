package cam {
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class CameraEventStyle {
		public static function normal(progress:Number):Number {
			return 1;
		}
		
		public static function accelerate(progress:Number):Number {
			//return (1 - Math.cos(progress * Math.PI * 0.5));
			return 0.5 * Math.PI * Math.sin(Math.PI * progress * 0.5);
		}
		
		public static function decelerate(progress:Number):Number {
			//return Math.sin(progress * Math.PI * 0.5);
			return 0.5 * Math.PI * Math.cos(Math.PI * progress * 0.5);
		}
		
		public static function ease(progress:Number):Number {
			//return (1 - Math.cos(progress * Math.PI)) * 0.5;
			return 0.5 * Math.PI * Math.sin(Math.PI * progress);
		}
	}
}