package backend;

import EReg;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.utils.Assets;

class Characters extends FlxSprite
{
	public var animOffsets:Map<String, Array<Float>>;
	public var characterName:String;

	public function new(x:Float = 0, y:Float = 0, name:String)
	{
		super(x, y);
		characterName = name;
		animOffsets = new Map<String, Array<Float>>();
		setupAnimations();
		loadOffsets();

		if (animation.exists("idle"))
			playAnim("idle");
	}

	private function setupAnimations():Void
	{
		switch (characterName)
		{
			case "dingle":
				frames = AssetPaths.spritesheet("new_dingle");
				animation.addByPrefix("idle", "idle", 24, false);
				animation.addByPrefix("talk", "up", 24, false);
				animation.addByPrefix("danceLeft", "left", 24, false);
				animation.addByPrefix("danceRight", "right", 24, false);
				animation.addByPrefix("fail", "down", 24, false);
			default:
				makeGraphic(50, 50, FlxColor.RED);
		}
	}

	private function loadOffsets():Void
	{
		var path = AssetPaths.charsOffsets(characterName);
		if (!Assets.exists(path))
			return;
		var raw:String = Assets.getText(path);
		var trimReg:EReg = new EReg("^\\s+|\\s+$", "g");
		var lines = raw.split("\n");
		for (line in lines)
		{
			line = trimReg.replace(line, "");
			if (line.length == 0)
				continue;
			if (line.charAt(0) == "#")
				continue;
			var parts = line.split(" ");
			var tokens = new Array<String>();
			for (p in parts)
			{
				if (p != null)
				{
					var pp = trimReg.replace(p, "");
					if (pp.length > 0)
						tokens.push(pp);
				}
			}
			if (tokens.length >= 3)
			{
				var anim = tokens[0];
				var x = Std.parseFloat(tokens[1]);
				var y = Std.parseFloat(tokens[2]);
				addOffset(anim, x, y);
			}
		}
	}

	public function playAnim(prefix:String):Void
	{
		if (animOffsets.exists(prefix) && animation.exists(prefix))
		{
			animation.play(prefix);
			var offset = animOffsets.get(prefix);
			if (offset != null)
				this.offset.set(offset[0], offset[1]);
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0):Void
	{
		animOffsets.set(name, [x, y]);
	}

	public function addAnimation(prefix:String, offset:Array<Float> = null, playNow:Bool = false):Void
	{
		if (offset == null)
			offset = [0, 0];
		addOffset(prefix, offset[0], offset[1]);
		animation.addByPrefix(prefix, prefix, 24, false);
		if (playNow)
			playAnim(prefix);
	}
}
