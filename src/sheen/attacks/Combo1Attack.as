package sheen.attacks {
import org.flixel.FlxG;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import sheen.Sheen;

public class Combo1Attack extends Attack {

    public static var DELAY:Number = 0.0;
    public static var COST:Number = 0.0;
    public static var KEYS:String = "";
    public static var DAMAGE:Number = 0.0;
    public static var KNOCK_OUT:Boolean = false;
    public static var UNBLOCKABLE:Boolean = false;


    [Embed(source='../../../data/sfx/kick3.mp3')]
    private var Punch1:Class;
    [Embed(source='../../../data/sfx/kick2.mp3')]
    private var Punch2:Class;

    private var _sound1:FlxSound;
    private var _sound2:FlxSound;


    public function Combo1Attack(sheen:Sheen) {
        super(sheen, COST, KEYS, DELAY, DAMAGE, KNOCK_OUT, UNBLOCKABLE, "combo1");
        nextPhase = new Combo2Attack(sheen);
        backAnimation = "combo1_back";
        _sound1 = new FlxSound();
        _sound2 = new FlxSound();
        _sound1.loadEmbedded(Punch1);
        _sound2.loadEmbedded(Punch2);
    }


    override public function isItYourKeys():Boolean {
        return super.isItYourKeys();
    }

    override public function animChanged(animName:String, frameNumber:uint):void {
        if (frameNumber == 1) {
            _sheen.dealDamage(damage, knockOut, unblockable);
        }
    }


    override public function get sound():FlxSound {
        if (Math.random() > 0.5) {
            return _sound1;
        } else {
            return _sound2;
        }

    }
}
}