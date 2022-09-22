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

class ShakingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var warnText2:FlxText;
	override function create()
	{
		super.create();

   if(PlayState.isStoryMode && ClientPrefs.shaking) {
		warnText = new FlxText(0 + 300, 0 + 300, 0, FlxG.width, "This song and the next one contain shaking, proceed", 32); //you can edit text here like you want
    warnText2 = new FlxText(0 + 130, 0 + 350, 0, FlxG.width, "Press A to Proceed, Press B to turn shaking off", 32);
		}
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
		warnText2.setFormat("VCR OSD Mono", 32, FlxColor.RED, CENTER);
		warnText.screenCenter(Y);
		add(warnText2);

		#if android
		addVirtualPad(NONE, A_B);
		#end
	}

	override function update(elapsed:Float)
	    {
		if (FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonB.justPressed #end)
		{
			ClientPrefs.shaking = false;
			close();
		}

		if (FlxG.keys.justPressed.ENTER #if android || _virtualpad.buttonA.justPressed #end)
		{
			close();
		} else {
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					FlxG.save.data.shaking = true;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText && warnText2, 1, 0.1, false, true, function(flk:FlxFlicker) {
						#if android
						virtualPad.alpha = 0;
						#end
						new FlxTimer().start(0.5, function (tmr:FlxTimer);
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					#if android
					FlxTween.tween(virtualPad, {alpha: 0}, 1);
					#end
					FlxTween.tween(warnText && warnText2, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween);
					});
				}
			}
		}
		super.update(elapsed);
  	}
  }
}