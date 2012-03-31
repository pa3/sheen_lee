
package sheen.attacks {
import org.flixel.FlxSound;

import sheen.ComboKeys;
import sheen.Sheen;


public class Attack {

    public var _sheen:Sheen;
    
    public var cost:Number;
    public var keys:String;
    public var delay:Number;

    public var damage:Number;
    public var knockOut:Boolean;
    public var unblockable:Boolean;
    public var animation:String;
    public var backAnimation:String = null;
    public var nextPhase:Attack;


    public function Attack(sheen:Sheen, cost:Number, keys:String, delay:Number, damage:Number, knockOut:Boolean, unblockable:Boolean, animation:String, nextPhase:Attack = null) {
        _sheen = sheen;
        this.cost = cost;
        this.keys = keys;
        this.delay = delay;
        this.damage = damage;
        this.knockOut = knockOut;
        this.unblockable = unblockable;
        this.animation = animation;
        this.nextPhase = nextPhase;
    }


    public function isItYourKeys():Boolean {
        var keysToCheck:String = ComboKeys.getInstance().getCombination(delay);
        if (keysToCheck.indexOf(keys) == 0 && !(_sheen._attackManager.getCurrentAttack() is FlightKickAttack) && !_sheen.isSitting) {
            return true;
        }
        return false;
    }

    public function animChanged(animName:String, frameNumber:uint):void {
        
    }

    public function get sound():FlxSound {
        return null;
    }
}


}