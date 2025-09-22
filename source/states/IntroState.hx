package states;

import backend.SaveDataHandler;
import backend.SubtitleManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class IntroState extends FlxState
{
	var dingleIntro:FlxSprite;
	var title:FlxText;
	var overlay:FlxSprite;

	override public function create():Void
	{
		SaveDataHandler.init();

		var sky = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/sky"));
		sky.scale.set(1.07, 1.07);
		add(sky);

		var city = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/city"));
		city.scale.set(1.07, 1.07);
		add(city);

		var behindTrain = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/behindTrain"));
		behindTrain.scale.set(1.07, 1.07);
		add(behindTrain);

		dingleIntro = new FlxSprite();
		dingleIntro.frames = AssetPaths.spritesheet("dingleIntro");
		dingleIntro.animation.addByPrefix("loop", "dingle", 24, true);
		dingleIntro.animation.play("loop");
		dingleIntro.screenCenter();
		add(dingleIntro);

		title = new FlxText(0, dingleIntro.y - 120, FlxG.width, "Wobble Wobble Wonder!");
		title.setFormat(AssetPaths.font("comic-sans-bold"), 32, FlxColor.WHITE, "center");
		title.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		add(title);

		FlxTween.tween(title, {y: title.y - 10}, 1, {type: FlxTweenType.PINGPONG});
		startRainbowTween();

		FlxG.sound.playMusic(AssetPaths.sound("intro"), 1, false);

		overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 1;
		add(overlay);

		new FlxTimer().start(2, function(_)
		{
			overlay.alpha = 0;
			FlxG.camera.flash(FlxColor.WHITE, 0.5);

			var subtitles:SubtitleManager = new SubtitleManager();
			add(subtitles);

			subtitles.show('Hello player! Welcome to "Wobble Wobble Wonder!"', 5);
		});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				FlxG.switchState(new MainMenuState());
			});
		}
	}

	private function startRainbowTween():Void
	{
		var colors = [
			FlxColor.RED,
			FlxColor.ORANGE,
			FlxColor.YELLOW,
			FlxColor.GREEN,
			FlxColor.BLUE,
			FlxColor.PURPLE
		];
		var duration = 0.6;
		var index = 0;

		function nextTween():Void
		{
			FlxTween.color(title, duration, title.color, colors[index], {
				onComplete: function(_)
				{
					index = (index + 1) % colors.length;
					nextTween();
				}
			});
		}

		nextTween();
	}
}
