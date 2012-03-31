package enemies.common {
import ai.AIPlayer;
import ai.State;

import enemies.Punk;

import org.flixel.FlxG;

public class AttackState implements State {

    private var _me:AIPlayer;
    private static var _pool:Array = new Array();

    public static function newInstance(me:AIPlayer):AttackState {
        if (_pool.length > 0) {
            var result:AttackState = _pool.shift();
            result.reset(me);
            return result;
        } else {
            return new AttackState(me);
        }
    }

    public static function release(state:AttackState):void {
        _pool.push(state);
    }

    public function reset(me:AIPlayer):void {
        _me = me;
    }

    public function AttackState(me:AIPlayer) {
        reset(me);
    }

    public function enter():void {
        if (_me.playState.player.isKnockedOut) {
            _me.fsm.changeState(IdleState.newInstance(_me));
            return;
        }

        if (_me.haveHighAttack()) {
            if (_me.haveLowAttack()) {
                if (_me.playState.player.isSitting) {
                    if (_me.lowAttackSound) _me.lowAttackSound.play();
                    _me.play("attack_low");
                } else {
                    if (Math.random() > 0.5) {
                        if (_me.lowAttackSound) _me.lowAttackSound.play();
                        _me.play("attack_low");
                    } else {
                        if (_me.highAttackSound) _me.highAttackSound.play();
                        _me.play("attack");
                    }
                }
            } else {
                if (_me.highAttackSound) _me.highAttackSound.play();
                _me.play("attack");
            }
        } else {
            if (_me.lowAttackSound) _me.lowAttackSound.play();
            _me.play("attack_low");
        }
    }

    public function exit():void {
        AttackState.release(this);
    }

    public function update():void {
        if (_me.y + _me.height > 172) {
            _me.y = 172 - _me.height;
        }
        if (_me.finished) {
            _me.fsm.changeState(IdleState.newInstance(_me));
        }
    }
}
}