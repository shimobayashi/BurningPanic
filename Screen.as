package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Screen extends Bitmap {
		private var fillColor:uint;

		public function Screen(width:int, height:int, _fillColor:uint = 0xFFFFFFFF) {
			fillColor = _fillColor;
			var b:BitmapData = new BitmapData(width, height, false, fillColor);
			super(b);
		}

		public function clear():void {
			bitmapData.fillRect(bitmapData.rect, fillColor);
		}
	}
}
