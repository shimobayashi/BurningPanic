package {
	import Math;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Font {
		private var bitmap:BitmapData;
		private var width:int;
		private var height:int;

		public function Font(_bitmap:BitmapData, _width:int, _height:int) {
			bitmap = _bitmap;
			width = _width;
			height = _height;
		}

		public function render(str:String):BitmapData {
			var strs:Array = str.split("\n");
			var hor:int = 0;
			var ver:int = strs.length;
			for each (var s:String in strs) {
				if (hor < s.length) {
					hor = s.length;
				}
			}
			var w:int = hor * width;
			var h:int = ver * height;

			var tmp:BitmapData = new BitmapData(w, h, true, 0x00FF00FF);
			var p:Point = new Point(0, 0);
			for each (s in strs) {
				for (var i:int = 0; i < s.length; i++) {
					var c:Number = s.charCodeAt(i) - 0x20;
					//trace("A".charCodeAt(0));
					var r:Rectangle = new Rectangle((c % 0x10) * width, Math.floor(c / 0x10) * height, width, height);
					tmp.copyPixels(bitmap, r, p);
					p.x += width;
				}
				p.x = 0;
				p.y += height;
			}

			return tmp;
		}
	}
}
