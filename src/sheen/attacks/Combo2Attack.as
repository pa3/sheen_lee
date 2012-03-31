package sheen.attacks {
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import sheen.Sheen;

public class Combo2Attack extends Attack {

    public static var DELAY:Number = 0.0;
    public static var COST:Number = 0.0;
    public static var KEYS:String = "";
    public static var DAMAGE:Number = 0.0;
    public static var KNOCK_OUT:Boolean = false;
    public static var UNBLOCKABLE:Boolean = false;

    [Embed(source='../../../data/sfx/kick2.mp3')]
    private var Kick:Class;
    private var _sound:FlxSound;


    public function Combo2Attack(sheen:Sheen) {
        super(sheen, COST, KEYS, DELAY, DAMAGE, KNOCK_OUT, UNBLOCKABLE, "combo2");
        nextPhase = new Combo3Attack(sheen);
        backAnimation = "combo2_back";

        _sound = new FlxSound();
        _sound.loadEmbedded(Kick);
    }

    override public function isItYourKeys():Boolean {
        return super.isItYourKeys();
    }


    override public function animChanged(animName:String, frameNumber:uint):void {
        if (animName == backAnimation && frameNumber == 2) {
            _sheen.dealDamage(damage, knockOut, unblockable);

        }
    }


    override public function get sound():FlxSound {
        return _sound;
    }
}
}