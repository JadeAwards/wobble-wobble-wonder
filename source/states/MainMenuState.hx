package states;

import backend.Characters;
import backend.FontButton;
import backend.SubtitleManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	var dingleChar:Characters;
	var mainMenuSound:FlxSound;

	override public function create():Void
	{
		var sludd = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/sludd"));
		sludd.scale.set(1.07, 1.07);
		add(sludd);

		var water = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/water"));
		water.scale.set(1.07, 1.07);
		add(water);

		var sand = new FlxSprite().loadGraphic(AssetPaths.image("backgrounds/sand"));
		sand.scale.set(1.07, 1.07);
		sand.x -= 900;
		add(sand);

		dingleChar = new Characters(-93, 0, "dingle");
		add(dingleChar);

		mainMenuSound = FlxG.sound.play(AssetPaths.sound("mainMenu"), 1, false);
		if (mainMenuSound != null)
			mainMenuSound.play();

		FlxG.sound.playMusic(AssetPaths.music("mainSong"), 0.3, true);

		var playButton = new FontButton(FlxG.width - 160, FlxG.height / 2 - 30, "Play", function()
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.switchState(new PlayState());
			});
		});
		add(playButton);

		var optionsButton = new FontButton(FlxG.width - 160, FlxG.height / 2 + 50, "Options", function()
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.switchState(new OptionsMenuState());
			});
		});
		add(optionsButton);

		var subtitles:SubtitleManager = new SubtitleManager();
		add(subtitles);

		subtitles.show("Welcome to the world of Frust! What would you like to do?", 5.5);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (mainMenuSound != null && mainMenuSound.playing)
		{
			if (dingleChar.animation.curAnim == null || dingleChar.animation.curAnim.name != "talk")
				dingleChar.playAnim("talk");
		}
		else
		{
			if (dingleChar.animation.curAnim == null || dingleChar.animation.curAnim.name != "idle")
				dingleChar.playAnim("idle");
		}

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.switchState(new IntroState());
		}
	}
}
