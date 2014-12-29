package {
	import Math;

	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import Screen;
	import Field;
	import Hero;
	import Controller;
	import Victim;
	import Font;

	public class BurningPanic extends Sprite {
		[Embed(source="dat/font8x8.png")]
		private var FontImage:Class;

		static public const SCENE_TITLE:int = 0;
		static public const SCENE_PLAY:int = 1;
		static public const SCENE_GAMEOVER:int = 2;

		static public var instance:BurningPanic;

		public var scene:int;
		public var screen:Screen;
		public var field:Field;
		public var hero:Hero;
		public var controller:Controller;
		public var victims:Array;
		public var font:Font;
		public var score:int;

		private var frame_count:int;
		private var last_spawn:int;

		private var titleImage:BitmapData;
		private var gameoverImage:BitmapData;


		public function BurningPanic() {
			instance = this;

			screen = new Screen(320, 240, 0x00000000);
			addChild(screen);
			field = new Field();
			init();
			controller = new Controller();
			font = new Font(new FontImage().bitmapData, 8, 8);
			titleImage = font.render("Click To Start");
			gameoverImage = font.render("   Game Over   \nClick To Return");
			scene = SCENE_TITLE;

			addEventListener(Event.ADDED, onAdded);
			addEventListener(Event.REMOVED, onRemoved);
		}

		private function init():void {
			hero = new Hero();
			victims = new Array();
			frame_count = 0;
			last_spawn = 0;
			score = 0;
		}

		private function onAdded(event:Event):void {
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onRemoved(event:Event):void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onMouseDown(event:MouseEvent):void {
			switch (scene) {
				case SCENE_TITLE:
					init();
					scene = SCENE_PLAY;
					break;
				case SCENE_PLAY:
					break;
				case SCENE_GAMEOVER:
					scene = SCENE_TITLE;
					break;
			}
		}

		private function onEnterFrame(event:Event):void	{
			spawn();
			update();
			draw();
			if (scene == SCENE_PLAY) {
				frame_count += 1;
			}
		}

		private function spawn():void {
			if (scene != SCENE_PLAY) {
				return;
			}
			if (frame_count - last_spawn > (1 - rank + 0.5) * 150) {
				var x:int = 48 + 48 * Math.floor(Math.random() * 4) + - 8 + 16 * Math.random();
				var y:int = 56 + 48 * Math.floor(Math.random() * 2) + 8;
				victims.push(new Victim(x, y));
				last_spawn = frame_count;
			}
		}

		public function get rank():Number {
			return Math.min(frame_count / (1 * 60 * 30), 1.0);
		}

		private function update():void {
			controller.update();

			field.update();
			var n:int = 0;
			if (scene == SCENE_PLAY) {
				for each (var v:Victim in victims) {
					v.update();
					if (v.isDead()) {
						n += 1;
					}
				}
				if (n >= 3) {
					scene = SCENE_GAMEOVER;
				}
			}

			hero.update();
		}

		private function draw():void {
			screen.clear();
			field.draw();
			for each (var v:Victim in victims) {
				v.draw();
			}
			hero.draw();
			controller.draw();

			var s:BitmapData = font.render("Score:" + String(score));
			screen.bitmapData.copyPixels(s, s.rect, new Point(2, 2));
			switch (scene) {
				case SCENE_TITLE:
					screen.bitmapData.copyPixels(titleImage, titleImage.rect, new Point((320 - titleImage.rect.width) / 2, 120 - 4));
					break;
				case SCENE_PLAY:
					break;
				case SCENE_GAMEOVER:
					screen.bitmapData.copyPixels(gameoverImage, gameoverImage.rect, new Point((320 - gameoverImage.rect.width) / 2, 120 - 8));
					break;
			}
		}
	}
}
