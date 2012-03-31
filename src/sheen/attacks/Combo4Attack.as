package sheen.attacks {
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import sheen.Sheen;

public class Combo4Attack extends Attack {

    public static var DELAY:Number = 0.0;
    public static var COST:Number = 0.0;
    public static var KEYS:String = "";
    public static var DAMAGE:Number = 0.0;
    public static var KNOCK_OUT:Boolean = false;
    public static var UNBLOCKABLE:Boolean = false;

    [Embed(source='../../../data/sfx/kick.mp3')]
    private var Kick:Class;
    private var _sound:FlxSound;


    public function Combo4Attack(sheen:Sheen) {
        super(sheen, COST, KEYS, DELAY, DAMAGE, KNOCK_OUT,UNBLOCKABLE,  "combo4");
        _sound = new FlxSound();
        _sound.loadEmbedded(Kick);
    }

    override public function isItYourKeys():Boolean {
        return super.isItYourKeys();
    }


    override public function animChanged(animName:String, frameNumber:uint):void {
        if (frameNumber == 2 || frameNumber == 3) {
            _sheen.dealDamage(damage, knockOut, unblockable);
        }
        _sheen.velocity.x = (_sheen.facing == FlxSprite.LEFT ? -60 : 60);

    }


    override public function get sound():FlxSound {
        return _sound;
    }
}
}