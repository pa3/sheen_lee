package sheen.attacks {
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import sheen.Sheen;

public class FireKick extends Attack {

    public static var DELAY:Number = 0.0;
    public static var COST:Number = 0.0;
    public static var KEYS:String = "";
    public static var DAMAGE:Number = 0.0;
    public static var KNOCK_OUT:Boolean = false;
    public static var UNBLOCKABLE:Boolean = false;

    [Embed(source='../../../data/sfx/kick2.mp3')]
    private var Kick:Class;
    private var _sound:FlxSound;


    public function FireKick(sheen:Sheen) {
        super(sheen, COST, KEYS, DELAY, DAMAGE, KNOCK_OUT,UNBLOCKABLE,  "fire_kick");
        _sound = new FlxSound();
        _sound.loadEmbedded(Kick);
    }


    override public function animChanged(animName:String, frameNumber:uint):void {
        if (frameNumber == 3) {
            _sheen.dealDamage(damage, knockOut, unblockable);
        }

    }


    override public function get sound():FlxSound {
        return _sound;
    }
}
}