package sheen.attacks {
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import sheen.Sheen;

public class BicycleAttack extends Attack {

    public static var DELAY:Number = 0.0;
    public static var COST:Number = 0.0;
    public static var KEYS:String = "";
    public static var DAMAGE:Number = 0.0;
    public static var KNOCK_OUT:Boolean = false;
    public static var UNBLOCKABLE:Boolean = false;

    [Embed(source='../../../data/sfx/kick3.mp3')]
    private var Kick:Class;
    private var _sound1:FlxSound;
    private var _sound2:FlxSound;


    public function BicycleAttack(sheen:Sheen) {
        super(sheen, COST, KEYS, DELAY, DAMAGE, KNOCK_OUT,UNBLOCKABLE,  "bicycle_kick");
        _sound1 = new FlxSound();
        _sound1.loadEmbedded(Kick);
        _sound2 = new FlxSound();
        _sound2.loadEmbedded(Kick);
    }


    override public function animChanged(animName:String, frameNumber:uint):void {

        switch (frameNumber) {
            case 3:
                _sound1.play();
                _sheen.dealDamage(damage, knockOut, unblockable);
                break;
            case 6:
                _sheen.dealDamage(damage, knockOut, unblockable);
                _sound2.play();
                break;
        }
        _sheen.velocity.x = (_sheen.facing == FlxSprite.LEFT ? -120 : 120);
    }
}
}