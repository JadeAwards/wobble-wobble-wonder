package backend;

import flixel.FlxG;

class SaveDataHandler
{
	public static var subtitlesEnabled:Bool = true;

	public static function init():Void
	{
		FlxG.save.bind("WobbleWobbleSave");
		load();
	}

	public static function save():Void
	{
		FlxG.save.data.subtitlesEnabled = subtitlesEnabled;
		FlxG.save.flush();
	}

	public static function load():Void
	{
		if (FlxG.save.data.subtitlesEnabled != null)
		{
			subtitlesEnabled = FlxG.save.data.subtitlesEnabled;
		}
		else
		{
			subtitlesEnabled = true;
		}
	}

	public static function toggleSubtitles():Void
	{
		subtitlesEnabled = !subtitlesEnabled;
		save();
	}
}
