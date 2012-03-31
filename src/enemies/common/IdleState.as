package enemies.common {
import ai.AIPlayer;

import ai.State;

import enemies.common.FollowState;
import enemies.Mime;
import enemies.Punk;

import org.flixel.FlxG;
import org.flixel.FlxSprite;

import sheen.Sheen;

public class IdleState implements State {
    private var _me:AIPlayer;
    private static var _pool:Array = new Array();

    public static function newInstance(me:AIPlayer):IdleState {

        if (_pool.length > 0) {
            var result:IdleState = _pool.shift();
            result.reset(me);
            return result;
        } else {
            return new IdleState(me);
        }
    }

    public static function release(state:IdleState):void {
        _pool.push(state);
    }

    public function reset(me:AIPlayer):void {
        _me = me;
    }

    public function IdleState(me:AIPlayer) {
        reset(me);
    }

    public function update():void {
        if (_me.y + _me.height > 172) {
            _me.y = 172 - _me.height;
        }
        
        //if (_player.attackersCount < 1) {
        //    _player.attackersCount++;

        var player:Sheen = _me.playState.player;
        if (player.x > _me.x) {
            _me.facing = FlxSprite.RIGHT;
        } else {
            _me.facing = FlxSprite.LEFT;
        }

        if (FlxG.chatWithTheBoss) return;

        var oneOfTheGuyAreBeforeMe:Boolean = false;
        var otherGuys:Array = _me.playState.enemies.members;
        for each (var e:AIPlayer  in otherGuys) {
            if (e.dying)
                continue;
            if (e != _me) {
                if (_me.facing == FlxSprite.LEFT) {
                    if (e.x < _me.x) {
                        if ((e.x + e.width > _me.x)) {
                            _me.fsm.changeState(StepBackState.newInstance(_me));
                            return;
                        } else if (Math.abs(e.x - _me.x) < 50) {
                            if (!(e is Mime)) {
                                oneOfTheGuyAreBeforeMe = true;
                            }
                        }
                    }

                } else {
                    if (e.x > _me.x) {
                        if (_me.x + _me.width > e.x) {
                            _me.fsm.changeState(StepBackState.newInstance(_me));
                            return;

                        } else if (Math.abs(e.x - _me.x) < 50) {
                            if (!(e is Mime)) {
                                oneOfTheGuyAreBeforeMe = true;
                            }
                        }
                    }
                }
            }
        }

        if (!oneOfTheGuyAreBeforeMe) {
            if (Math.abs(player.x - _me.x) > 30) {
                _me.fsm.changeState(FollowState.newInstance(_me));
            } else if (Math.abs(player.x - _me.x) < 20) {
                _me.fsm.changeState(StepBackState.newInstance(_me));
            } else {
                if (!player.dead) {
                    if (_me._attackTimer > _me.ATTACK_DELAY) {
                        _me._attackTimer = 0.0;
                        _me.fsm.changeState(AttackState.newInstance(_me));
                    }
                }
            }
        }
        //}
    }

    public function enter():void {
        _me.play("idle");
        if (_me.y + _me.height> 172) {
            _me.y = 172 - _me.height;
        }

    }

    public function exit():void {
        IdleState.release(this);
    }
}
}