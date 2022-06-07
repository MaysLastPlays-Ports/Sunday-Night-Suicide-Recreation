package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class WarningSubstate extends MusicBeatSubstate
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	public function new(x:Float,y:Float)
	{
		super();

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			this song (and the next one) contain instensive shaking!\n
			Press ENTER to disable it now or go to Options Menu.\n
			Press ESCAPE to ignore this message.\n
			You've been warned!",
			32);
		warnText.setFormat("VCR OSD Mono", 16, FlxColor.RED, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

                #if android
	        addVirtualPad(NONE, A_B);
                #end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					close();
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					PlayState.instance.shaking = false;
					ClientPrefs.shaking = false;
					close();
				}
			}
		}
		super.update(elapsed);
	}
}
