package sheen.attacks {
import ai.AIPlayer;

import flash.utils.Dictionary;

import org.flixel.FlxSound;

import sheen.Sheen;

public class FlightKickAttack extends Attack {

    public static var DELAY:Number = 0.0;
    public static var COST:Number = 0.0;
    public static var KEYS:String = "";
    public static var DAMAGE:Number = 0.0;
    public static var KNOCK_OUT:Boolean = false;
    public static var UNBLOCKABLE:Boolean = false;

    private var hurtedEnemies:Dictionary = new Dictionary();

    [Embed(source='../../../data/sfx/kick3.mp3')]
    private var Kick:Class;
    private var _sound:FlxSound;


    public function FlightKickAttack(sheen:Sheen) {
        super(sheen, COST, KEYS, DELAY, DAMAGE, KNOCK_OUT, UNBLOCKABLE, "flight_kick");
        _sound = new FlxSound();
        _sound.loadEmbedded(Kick);
    }

    override public function isItYourKeys():Boolean {
        if (super.isItYourKeys()) {
            if (_sheen.velocity.y != 0) {
                return true;
            }
        }
        return false;
    }

    public function hurting(enemy:AIPlayer):void {
        hurtedEnemies[enemy] = true;
    }

    public function alreadyHurted(enemy:AIPlayer):Boolean {
        return (hurtedEnemies[enemy] != null);
    }

    override public function animChanged(animName:String, frameNumber:uint):void {
        hurtedEnemies = new Dictionary();
    }

    override public function get sound():FlxSound {
        return _sound;
    }

}
}
