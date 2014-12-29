package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Animation extends Bitmap {
		private var source:Bitmap;
		private var points:Array;
		private var interval:int;
		private var loop:Boolean;
		private var pointer:int;
		private var prev_pointer:int;
		private var frameCount:int;

		public function Animation(_source:Bitmap, width:int, height:int, _points:Array, _interval:int, _loop:Boolean) {
			source = _source;
			var b:BitmapData = new BitmapData(width, height, true, 0x00FF00FF);
			super(b);
			points = _points;
			interval = _interval;
			loop = _loop;
			pointer = 0;
			prev_pointer = -1;
			frameCount = 0;
		}

		public function update(delta:int = 1):void {
			if (loop) {
				pointer = frameCount / (interval / points.length) % points.length;
			} else {
				pointer = frameCount / (interval / points.length);
				if (pointer >= points.length) {
					pointer = points.length - 1;
				}
			}

			if (pointer != prev_pointer ) {
				var r:Rectangle = source.bitmapData.rect.clone();
				r.offsetPoint(points[pointer]);
				bitmapData.fillRect(bitmapData.rect, 0x00FF00FF);
				bitmapData.copyPixels(source.bitmapData, r, new Point(0, 0), null, null, true);
			}

			prev_pointer = pointer;
			frameCount += delta;
		}
	}
}
