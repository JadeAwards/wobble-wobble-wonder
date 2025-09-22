package backend;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class FontButton extends FlxButton
{
	public var textField:FlxText;

	var hoverSize:Int = 28;
	var baseSize:Int = 24;

	public function new(x:Float, y:Float, label:String, callback:Void->Void)
	{
		super(x, y, null, callback);
		makeGraphic(100, 40, 0x00000000);

		textField = new FlxText(x, y, 0, label, baseSize);
		textField.setFormat(AssetPaths.font("comic-sans-bold"), baseSize, FlxColor.WHITE, "center");
		textField.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);

		updateTextPosition();

		if (FlxG.state != null)
			FlxG.state.add(textField);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (status == 1)
			textField.size = hoverSize;
		else
			textField.size = baseSize;

		updateTextPosition();
	}

	private function updateTextPosition():Void
	{
		textField.x = this.x + width / 2 - textField.width / 2;
		textField.y = this.y + height / 2 - textField.height / 2;
	}

	public function setLabel(newText:String):Void
	{
		textField.text = newText;
		updateTextPosition();
	}
}
