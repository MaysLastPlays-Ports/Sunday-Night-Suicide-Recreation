package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.FlxCamera;
class ShakingWarningSubState extends MusicBeatSubstate
{
	public static var warningtext:FlxText;
	public static var warningtext2:FlxText;
	public static var cmaera:FlxCamera;
	public function new(x:Float, y:Float)
    {
        super();
		warningtext = new FlxText(0 + 300, 0 + 300, 0, "", 32);
		warningtext2 = new FlxText(0 + 130, 0 + 350, 0, "Press Enter to Procceed, Press CTRL to turn shaking off", 32);
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
		if (FlxG.keys.justPressed.CONTROL)
		{
			ClientPrefs.shaking = false;
			close();
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			close();
		}

        super.update(elapsed);
    }
}

                #if android
                addVirtualPad(NONE, A_B);
                addPadCamera();
                #end

		super.create();
	}