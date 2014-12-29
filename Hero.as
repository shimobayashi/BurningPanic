package {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import BurningPanic;
	import Animation;
	import Victim;
	
	public class Hero {
		[Embed(source="dat/hero.png")]
		private var HeroImage:Class;

		public var position:Point;
		public var velocity:Point;

		private var heroImage:Bitmap;
		private var walkAnim:Animation;
		private var carryingAnim:Animation;
		private var carrying:Victim;

		public function Hero() {
			heroImage = new HeroImage();
			var points:Array = generateAnimPoints(0);
			walkAnim = new Animation(heroImage, 32, 16, points, 30, true);
			points = generateAnimPoints(16);
			carryingAnim = new Animation(heroImage, 32, 16, points, 30, true);
			position = new Point(160 - 16, 240 - 16);
			velocity = new Point(0, 0);
		}

		private function generateAnimPoints(y:int):Array {
			var result:Array = new Array();

			for (var i:int = 0; i < 4; i++) {
				result.push(new Point(32 * i, y));
			}

			return result;
		}

		public function update():void {
			move();
			collision();
			if (carrying) {
				carryingAnim.update(Math.abs(velocity.x));
			} else {
				walkAnim.update(Math.abs(velocity.x));
			}
		}

		private function move():void {
			velocity.x += BurningPanic.instance.controller.delta / 90.0 * 2;
			velocity.x *= 0.9;
			position = position.add(velocity);
			if (position.x < 0) {
				position.x = 0;
			} else if (position.x > 320 - 32) {
				position.x = 320 - 32;
			}
		}

		private function collision():void {
			if (BurningPanic.instance.scene != BurningPanic.SCENE_PLAY) {
				return;
			}
			if (carrying) {
				var r:Rectangle = new Rectangle(248, 208, 56, 32);
				if (rect.intersects(r)) {
					BurningPanic.instance.score += 1;
					carrying = null;
				}
			} else {
				var a:Array = BurningPanic.instance.victims;
				for each (var v:Victim in a) {
					if (rect.intersects(v.rect)) {
						carrying = v;
						a.splice(a.indexOf(v), 1);
						break;
					}
				}
			}
		}

		public function get rect():Rectangle {
			return new Rectangle(position.x, position.y, 32, 16);
		}
		
		public function draw():void {
			if (carrying) {
				BurningPanic.instance.screen.bitmapData.copyPixels(carryingAnim.bitmapData, carryingAnim.bitmapData.rect, position, null, null, true);
			} else {
				BurningPanic.instance.screen.bitmapData.copyPixels(walkAnim.bitmapData, walkAnim.bitmapData.rect, position, null, null, true);
			}
		}
	}
}
