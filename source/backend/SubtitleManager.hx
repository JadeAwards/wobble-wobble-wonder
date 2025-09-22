package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class SubtitleManager extends FlxGroup
{
	public var subtitle:FlxText;
	public var box:FlxSprite;

	var hideTimer:FlxTimer;

	public function new()
	{
		super();

		subtitle = new FlxText(0, FlxG.height - 50, FlxG.width, "");
		subtitle.setFormat(AssetPaths.font("comic-sans-bold"), 20, FlxColor.WHITE, "center");
		subtitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1);
		subtitle.scrollFactor.set();
		subtitle.visible = false;

		box = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		box.alpha = 0.7;
		box.scrollFactor.set();
		box.visible = false;

		FlxG.state.add(box);
		FlxG.state.add(subtitle);

		hide();
	}

	public function show(text:String, ?duration:Float = -1):Void
	{
		if (!SaveDataHandler.subtitlesEnabled)
		{
			hide();
			return;
		}

		subtitle.text = text;
		box.visible = true;
		subtitle.visible = true;

		subtitle.screenCenter(X);
		subtitle.y = FlxG.height - subtitle.height - 30;

		var actualWidth:Float = subtitle.textField.textWidth + 20;
		var actualHeight:Float = subtitle.textField.textHeight + 10;

		var w:Int = Std.int(actualWidth);
		var h:Int = Std.int(actualHeight);

		box.makeGraphic(w, h, FlxColor.BLACK);
		box.alpha = 0.7;
		box.x = (FlxG.width - w) / 2;
		box.y = subtitle.y - 5;

		if (duration > 0)
		{
			if (hideTimer != null)
				hideTimer.cancel();

			hideTimer = new FlxTimer().start(duration, function(_)
			{
				hide();
			});
		}
	}

	public function hide():Void
	{
		box.visible = false;
		subtitle.visible = false;
	}
}
