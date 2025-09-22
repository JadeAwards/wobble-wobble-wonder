package states;

import backend.Characters;
import backend.SubtitleManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import states.MainMenuState;

class PlayState extends FlxState
{
	var stuffToFind:Array<String> = ["apple", "basketball", "dog", "flower", "kite"];
	var objectSpr:Array<FlxSprite>;

	var targetObject:String;
	var isAudioPlaying:Bool = false;
	var lives:Int = 3;

	var promptTxt:FlxText;
	var findTxt:FlxText;
	var livesTxt:FlxText;
	var overlay:FlxSprite;
	var winTxt:FlxText;

	override public function create():Void
	{
		super.create();

		var sky = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/sky"));
		sky.scale.set(1.07, 1.07);
		add(sky);

		var city = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/city"));
		city.scale.set(1.07, 1.07);
		add(city);

		var behindTrain = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/behindTrain"));
		behindTrain.scale.set(1.07, 1.07);
		add(behindTrain);

		promptTxt = new FlxText(0, 10, FlxG.width, "Can you find the:");
		promptTxt.setFormat(AssetPaths.font("comic-sans-bold"), 32, FlxColor.WHITE, "center");
		promptTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		add(promptTxt);

		findTxt = new FlxText(0, 60, FlxG.width, "");
		findTxt.setFormat(AssetPaths.font("comic-sans-bold"), 48, FlxColor.WHITE, "center");
		findTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		add(findTxt);

		livesTxt = new FlxText(10, 10, 0, "Lives: " + lives);
		livesTxt.setFormat(AssetPaths.font("comic-sans-bold"), 24, FlxColor.WHITE, "left");
		livesTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		add(livesTxt);

		overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0;

		winTxt = new FlxText(0, FlxG.height / 2 - 50, FlxG.width, "CONGRATS!");
		winTxt.setFormat(AssetPaths.font("comic-sans-bold"), 64, FlxColor.LIME, "center");
		winTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
		winTxt.visible = false;

		objectSpr = [];

		startNewRound();
	}

	private function startNewRound():Void
	{
		for (sprite in objectSpr)
			remove(sprite, true);
		objectSpr = [];

		isAudioPlaying = false;
		targetObject = FlxG.random.getObject(stuffToFind);

		findTxt.text = "";
		promptTxt.text = "Can you find the:";

		FlxG.sound.play(AssetPaths.sound("canYouFindThe"), 2, false, null, function()
		{
			findTxt.text = targetObject;
			setupGame();
		});
	}

	private function setupGame():Void
	{
		var shuffledStuff:Array<String> = stuffToFind.slice(0);
		shuffledStuff.remove(targetObject);

		var displayStuff:Array<String> = [targetObject];
		displayStuff = displayStuff.concat(shuffledStuff.slice(0, 3));

		FlxG.random.shuffleArray(displayStuff, displayStuff.length);

		var startX = (FlxG.width / 2) - 140;
		var startY = 150;
		var spacingX = 200;
		var spacingY = 200;

		for (i in 0...displayStuff.length)
		{
			var objectName = displayStuff[i];
			var col = i % 2;
			var row = Std.int(i / 2);

			var xPos = startX + col * spacingX;
			var yPos = startY + row * spacingY;

			var imageSpr = new FlxSprite(xPos, yPos);
			imageSpr.loadGraphic(AssetPaths.image('objects/$objectName'));
			imageSpr.scale.set(0.25, 0.25);
			imageSpr.updateHitbox();
			add(imageSpr);
			objectSpr.push(imageSpr);

			imageSpr.ID = (objectName == targetObject) ? 1 : 0;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				FlxG.switchState(new MainMenuState());
			});
			return;
		}

		if (!isAudioPlaying && FlxG.mouse.justPressed)
		{
			for (sprite in objectSpr)
			{
				if (FlxG.mouse.overlaps(sprite))
				{
					if (sprite.ID == 1)
					{
						sprite.color = FlxColor.LIME;
						overlay.alpha = 0.62;
						add(overlay);
						winTxt.visible = true;
						add(winTxt);
						FlxG.sound.play(AssetPaths.sound("congrats"), 1, false);
						new FlxTimer().start(3, (t) ->
						{
							winTxt.visible = false;
							overlay.alpha = 0;
							startNewRound();
						});
					}
					else
					{
						sprite.color = FlxColor.RED;
						FlxG.sound.play(AssetPaths.sound("oopsTryAgain"), 1, false);

						var subtitles:SubtitleManager = new SubtitleManager();
						add(subtitles);
						subtitles.show("Oops! Try again!", 1.75);

						new FlxTimer().start(1, (t) -> sprite.color = FlxColor.WHITE);

						lives--;
						livesTxt.text = "Lives: " + lives;
						if (lives <= 0)
						{
							FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
							{
								FlxG.switchState(new MainMenuState());
							});
						}
					}
				}
			}
		}
	}
}
