package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;

	[SWF(backgroundColor="0x333333", frameRate="30", width="320", height="240")]

	public class Main extends Sprite {
		private var scene:BurningPanic;

		public function Main() {
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			scene = new BurningPanic();
			addChild(scene);
		}
	}
}
