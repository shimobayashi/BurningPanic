package {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import BurningPanic;
	import Animation;

	public class Victim {
		[Embed(source="dat/victim.png")]
		private var VictimImage:Class;

		public var position:Point;
		public var velocity:Point;

		private var victimImage:Bitmap;
		private var anim:Animation;

		public function Victim(x:int, y:int) {
			victimImage = new VictimImage();
			anim = new Animation(victimImage, 16, 16, [new Point(0, 0), new Point(16, 0)], 15, true);
			position = new Point(x, y);
			velocity = new Point(0, -2);
		}

		public function update():void {
			velocity.y += 0.1;
			velocity.y *= 0.99;
			position = position.add(velocity);
			if (position.y > 240 - 8) {
				position.y = 240 - 8;
			} else {
				anim.update();
			}
		}

		public function draw():void {
			BurningPanic.instance.screen.bitmapData.copyPixels(anim.bitmapData, anim.bitmapData.rect, position, null, null, true);
		}

		public function get rect():Rectangle {
			return new Rectangle(position.x, position.y, 16, 16);
		}

		public function isDead():Boolean {
			return position.y >= 240 - 8;
		}
	}
}
