package sheen {
import ai.AIPlayer;

import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSound;

import org.flixel.FlxSprite;
import org.flixel.data.FlxAnim;

import sheen.attacks.Attack;
import sheen.attacks.BicycleAttack;
import sheen.attacks.Combo4Attack;
import sheen.attacks.FireKick;
import sheen.attacks.FlightKickAttack;
import sheen.attacks.PunchAttack;

public class SheenAttackManager extends FlxObject {

    public var _currentAttack:Attack = null;
    public var attacks:Vector.<Attack> = new Vector.<Attack>();

    public function SheenAttackManager(sheen:Sheen) {
        attacks.push(new FlightKickAttack(sheen));
        attacks.push(new FireKick(sheen));
        attacks.push(new BicycleAttack(sheen));
        attacks.push(new PunchAttack(sheen));
    }


    override public function update():void {
        super.update();
        if (_currentAttack == null) {
            for each (var a:Attack in attacks) {
                if (a.isItYourKeys() && !a._sheen.isStandingUpAfterKnockOut) {

                    for each (var enemyForDamage:AIPlayer in a._sheen._enemies.members) {
                        if (Math.abs(enemyForDamage.x - a._sheen.x) < 50) {
                            if (((enemyForDamage.x > a._sheen.x) && a._sheen.facing == FlxSprite.RIGHT) || ((enemyForDamage.x <= a._sheen.x) && a._sheen.facing == FlxSprite.LEFT)) {
                                if (!enemyForDamage.dying && !enemyForDamage.dead && enemyForDamage.facing != a._sheen.facing) {
                                    enemyForDamage.iGonaKickYourAss();
                                }
                            }
                        }
                    }

                    _currentAttack = a;
                    if (_currentAttack.sound)
                        _currentAttack.sound.play();
                    a._sheen.play(a.animation);
                    break;
                }
            }
        }
    }

    public function animEnded(animName:String):Attack {
        if (_currentAttack) {
            var nextPhase:Attack = _currentAttack.nextPhase;
            if (nextPhase && nextPhase.isItYourKeys()) {
                _currentAttack = nextPhase;
                _currentAttack._sheen.play(_currentAttack.animation);
                if (_currentAttack.sound)
                    _currentAttack.sound.play();
            } else {
                if (_currentAttack.backAnimation && _currentAttack.backAnimation != animName) {
                    _currentAttack._sheen.play(_currentAttack.backAnimation);
                } else {
                    _currentAttack = null;
                }
                ComboKeys.getInstance().reset();
            }
        }
        return _currentAttack;
    }

    public function animChanged(animName:String, frameNumber:uint):void {
        if (_currentAttack != null)
            _currentAttack.animChanged(animName, frameNumber)
    }

    public function getCurrentAttack():Attack {
        return _currentAttack;
    }
}
}