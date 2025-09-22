package states;

import backend.FontButton;
import backend.SaveDataHandler;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

class OptionsMenuState extends FlxState
{
	var subtitleButton:FontButton;

	public static var subtitlesEnabled:Bool = true;

	override public function create():Void
	{
		subtitleButton = new FontButton(FlxG.width / 2 - 50, FlxG.height / 2 - 20, "Subtitles: " + (SaveDataHandler.subtitlesEnabled ? "ON" : "OFF"), function()
		{
			SaveDataHandler.toggleSubtitles();
			subtitleButton.setLabel("Subtitles: " + (SaveDataHandler.subtitlesEnabled ? "ON" : "OFF"));
		});
		add(subtitleButton);

		var backButton = new FontButton(FlxG.width / 2 - 50, FlxG.height / 2 + 40, "Back", function()
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.switchState(new MainMenuState());
			});
		});
		add(backButton);
	}
}
