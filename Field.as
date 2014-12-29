package {
	import flash.display.Bitmap;
	import flash.geom.Point;

	public class Field {
		[Embed(source="dat/background.png")]
		private var BackgroundImage:Class;

		private var backgroundImage:Bitmap;

		public function Field() {
			backgroundImage = new BackgroundImage();
		}

		public function update():void {
		}

		public function draw():void {
			BurningPanic.instance.screen.bitmapData.copyPixels(backgroundImage.bitmapData, backgroundImage.bitmapData.rect, new Point(0, 0));
		}
	}
}
