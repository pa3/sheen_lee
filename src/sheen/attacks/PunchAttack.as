package sheen.attacks {
import org.flixel.FlxG;
import org.flixel.FlxSound;

import sheen.Sheen;

public class PunchAttack extends Attack {

    public static var DELAY:Number = 0.0;
    public static var COST:Number = 0.0;
    public static var KEYS:String = "";
    public static var DAMAGE:Number = 0.0;
    public static var KNOCK_OUT:Boolean = false;
    public static var UNBLOCKABLE:Boolean = false;
    
    private var _sound0:FlxSound;
    private var _sound1:FlxSound;

    [Embed(source='../../../data/sfx/kick.mp3')]
    private var Punch1:Class;
    [Embed(source='../../../data/sfx/kick2.mp3')]
    private var Punch2:Class;

    public function PunchAttack(sheen:Sheen) {
        super(sheen, COST, KEYS, DELAY, DAMAGE, KNOCK_OUT, UNBLOCKABLE, "punch");
        _sound0 = new FlxSound();
        _sound1 = new FlxSound();
        _sound0.loadEmbedded(Punch1);
        _sound1.loadEmbedded(Punch2);
        //_sound.loadEmbedded(Punch4);
        //_sound.loadEmbedded(Punch4);
        nextPhase = new Combo1Attack(sheen);
        backAnimation = "punch_back";
    }

    override public function animChanged(animName:String, frameNumber:uint):void {
        if (animName == this.animation) {
            if (frameNumber == 1) {
                _sheen.dealDamage(damage, knockOut, unblockable);
            }
        }
    }

    override public function get sound():FlxSound {
        if (Math.random() > 0.5) {
            return _sound0;
        } else {
            return _sound1;
        }
    }
}
}