package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
class ShakingWarningState extends MusicBeatSubstate
{
	public static var warningtext:FlxText;
	public static var warningtext2:FlxText;
	public static var cameras:FlxCamera;
	public function new(x:Float, y:Float)
	public static var leftState:Bool = false;
    {
        super();
		warningtext = new FlxText(0 + 300, 0 + 300, 0, "", 32);
		warningtext2 = new FlxText(0 + 130, 0 + 350, 0, "Press A to Procceed, Press B to turn shaking off", 32);
		if(PlayState.isStoryMode && ClientPrefs.shaking) {
			warningtext.text = "This song and the next one contain shaking, procced?";
			warningtext.x -= 131; //60 + 71 == 131
		}
		else if(!PlayState.isStoryMode && ClientPrefs.shaking) {
			warningtext.text = "This song contains Shaking!, procced?";
		}
		warningtext.scrollFactor.set();
		warningtext.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.RED);
		warningtext.updateHitbox();
		warningtext2.scrollFactor.set();
		warningtext2.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.RED);
		warningtext2.updateHitbox();
		add(warningtext);
		add(warningtext2);
    }

    override public function update(elapsed:Float):Void
    {
		if (FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonB.justPressed #end)
		{
			ClientPrefs.shaking = false;
			close();
		}

		if (FlxG.keys.justPressed.ENTER #if android || _virtualpad.buttonA.justPressed #end)
		{
			close();
		}

                #if android
                addVirtualPad(NONE, A_B);
                #end
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
