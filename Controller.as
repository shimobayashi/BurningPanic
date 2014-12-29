package {
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.display.Graphics;

	import BurningPanic;

	public class Controller {
		public var delta:Number;
		private var points:Array;
		private var center:Point;
		private var shape:Shape;

		public function Controller() {
			delta = 0;
			points = new Array();
			center = new Point(0, 0);
			shape = new Shape();
		}

		public function update():void {
			var p:Point = new Point(BurningPanic.instance.stage.mouseX, BurningPanic.instance.stage.mouseY);
			if (points.length > 0) {
				var r1:Number = Math.atan2(points[points.length - 1].y - center.y, points[points.length - 1].x - center.x);
				var r2:Number = Math.atan2(p.y - center.y, p.x - center.x);
				r1 = r1 * 180 / Math.PI;
				r2 = r2 * 180 / Math.PI;
				var sub:Number = r2 - r1;
				sub -= Math.floor(sub / 360.0) * 360.0;
				if (sub < -180) {
					sub += 360;
				} else if (sub > 180) {
					sub -= 360;
				}
				if (Math.abs(sub) < 90) {
					delta = sub;
				} else {
					delta = 0;
				}
			}

			points.push(p);
			if (points.length > 15) {
				points.shift();
			}

			center.x = 0;
			center.y = 0;
			for each (p in points) {
				center.x += p.x;
				center.y += p.y;
			}
			center.x /= points.length;
			center.y /= points.length;
		}

		public function draw():void {
			var g:Graphics = shape.graphics;

			g.clear();
			g.lineStyle(1, 0xFFFFFFFF);
			g.moveTo(points[0].x, points[0].y);
			for each (var p:Point in points) {
				g.lineTo(p.x, p.y);
			}

			BurningPanic.instance.screen.bitmapData.draw(shape);

			g.clear();
			g.beginFill(0xFFFF0000);
			g.lineStyle(1, 0xFFFF0000);
			g.drawCircle(center.x, center.y, 4);
			g.endFill();

			BurningPanic.instance.screen.bitmapData.draw(shape);
		}
	}
}
