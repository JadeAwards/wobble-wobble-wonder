package backend;

import Std;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import openfl.utils.Assets;
import states.IntroState;

class Preloader extends FlxState
{
	var progressBg:FlxSprite;
	var progressFill:FlxSprite;
	var progressText:FlxText;
	var files:Array<String>;
	var index:Int = 0;
	var dots:Int = 0;
	var tickTimer:FlxTimer;
	var blinkTimer:FlxTimer;
	var totalWidth:Int = 0;

	override public function create():Void
	{
		FlxG.mouse.visible = true;
		FlxG.mouse.unload();
		FlxG.mouse.load(Assets.getBitmapData(AssetPaths.image("cursor")), 1, 0);

		files = Assets.list();
		totalWidth = FlxG.width - 200;

		progressBg = new FlxSprite(100, FlxG.height / 2 - 10);
		progressBg.makeGraphic(totalWidth, 20, 0xFF444444);
		add(progressBg);

		progressFill = new FlxSprite(100, FlxG.height / 2 - 10);
		progressFill.makeGraphic(totalWidth, 20, 0xFFAAAAAA);
		progressFill.scale.set(0, 1);
		add(progressFill);

		progressText = new FlxText(0, FlxG.height / 2 + 20, FlxG.width, "Loading... 0%");
		progressText.setFormat(null, 16, 0xFFFFFFFF, "center");
		add(progressText);

		tickTimer = new FlxTimer();
		tickTimer.start(0.01, function(t:FlxTimer):Void
		{
			preloadStep();
			if (index >= files.length)
			{
				t.cancel();
				if (blinkTimer != null)
					blinkTimer.cancel();
				finishPreload();
			}
		}, 0);

		blinkTimer = new FlxTimer();
		blinkTimer.start(0.5, function(bt:FlxTimer):Void
		{
			dots = (dots + 1) % 4;
			updateProgressText();
		}, 0);
	}

	private function preloadStep():Void
	{
		if (index >= files.length)
			return;
		var file = files[index];

		if (hasExt(file, ".png"))
			Assets.getBitmapData(file);
		else if (hasExt(file, ".ogg"))
			Assets.getSound(file);
		else if (hasExt(file, ".ttf") || hasExt(file, ".otf"))
			Assets.getFont(file);
		else if (hasExt(file, ".json") || hasExt(file, ".txt") || hasExt(file, ".xml"))
			Assets.getText(file);

		if (hasExt(file, ".xml"))
		{
			var imgFile = file.substr(0, file.length - 4) + ".png";
			if (Assets.exists(imgFile))
				var _ = FlxAtlasFrames.fromSparrow(imgFile, file);
		}

		index++;
		var percent:Float = if (files.length > 0) index / files.length else 1;
		progressFill.scale.set(percent, 1);
		updateProgressText();
	}

	private function updateProgressText():Void
	{
		var percent:Int = Std.int((if (files.length > 0) index / files.length else 1) * 100);
		var dotStr:String = "";
		for (i in 0...dots)
			dotStr += ".";
		progressText.text = "Loading... " + percent + "%" + dotStr;
	}

	private function finishPreload():Void
	{
		progressFill.scale.set(1, 1);
		new FlxTimer().start(0.1, function(_)
		{
			FlxG.switchState(new IntroState());
		});
	}

	private static function hasExt(file:String, ext:String):Bool
	{
		var l = file.length;
		var el = ext.length;
		if (l < el)
			return false;
		return file.substr(l - el, el) == ext;
	}
}
