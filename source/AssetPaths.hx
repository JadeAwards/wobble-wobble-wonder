package;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;

class AssetPaths
{
	public static inline function data(file:String, ext:String = "json"):String
		return 'assets/data/$file.$ext';

	public static inline function image(file:String, ext:String = "png"):String
		return 'assets/images/$file.$ext';

	public static inline function font(file:String, ext:String = "ttf"):String
		return 'assets/fonts/$file.$ext';

	public static inline function sound(file:String, ext:String = "ogg"):String
		return 'assets/sounds/$file.$ext';

	public static inline function music(file:String, ext:String = "ogg"):String
		return 'assets/music/$file.$ext';

	public static inline function spritesheet(name:String, imgExt:String = "png", xmlExt:String = "xml"):FlxAtlasFrames
		return FlxAtlasFrames.fromSparrow('assets/images/$name.$imgExt', 'assets/images/$name.$xmlExt');

	public static inline function charsOffsets(characterName:String):String
		return 'assets/data/charsOffsets/' + characterName + '.txt';

	public static inline function exists(path:String):Bool
		return Assets.exists(path);
}
