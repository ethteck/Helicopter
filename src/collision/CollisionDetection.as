package collision {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class CollisionDetection {
		public static function testObjects(obj1:DisplayObject, obj2:DisplayObject, commonParent:DisplayObject):Boolean {
			// get bounding boxes in common parent's coordinate space
			var rect1:Rectangle = obj1.getBounds(commonParent);
			var rect2:Rectangle = obj2.getBounds(commonParent);
			
			// find the intersection of the two bounding boxes
			var intersectionRect:Rectangle = rect1.intersection(rect2);
			
			// size of rect needs to be integer size for bitmap data
			intersectionRect.x = int(intersectionRect.x);
			intersectionRect.y = int(intersectionRect.y);
			intersectionRect.width = (intersectionRect.width == 0) ? 0 : int(intersectionRect.width) + 1;
			intersectionRect.height = (intersectionRect.height == 0) ? 0 : int(intersectionRect.height) + 1;
			
			// if the rect is empty, we're done
			if (intersectionRect.isEmpty()) return false;
			
			// calculate the transform for the display object relative to the common parent
			var parentXformInvert:Matrix = commonParent.transform.concatenatedMatrix.clone();
			parentXformInvert.invert();
			var target1Xform:Matrix = obj1.transform.concatenatedMatrix.clone();
			target1Xform.concat(parentXformInvert);
			var target2Xform:Matrix = obj2.transform.concatenatedMatrix.clone();
			target2Xform.concat(parentXformInvert);
			
			// translate the target into the rect's space
			target1Xform.translate(-intersectionRect.x, -intersectionRect.y);
			target2Xform.translate( -intersectionRect.x, -intersectionRect.y);
			
			// combine the display objects
			var bd:BitmapData = new BitmapData(intersectionRect.width, intersectionRect.height, false);
			bd.draw(obj1, target1Xform, new ColorTransform(1, 1, 1, 1, 255, -255, -255, 0), BlendMode.NORMAL);
			bd.draw(obj2, target2Xform, new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0), BlendMode.DIFFERENCE);
			
			// find overlap
			var overlapRect:Rectangle = bd.getColorBoundsRect(0xffffffff, 0xff00ffff);
			overlapRect.offset(intersectionRect.x, intersectionRect.y);
			
			if (overlapRect != null && overlapRect.size.length> 0) return true;
			return false;
		}
	}
}