package enemies.common {
import ai.AIPlayer;
import ai.State;

import enemies.Mime;

import org.flixel.FlxG;
import org.flixel.FlxSprite;

import sheen.Sheen;

public class FollowState implements State {

    private var _me:AIPlayer;
    private static var _pool:Array = new Array();

    private var _followIdleTimer:Number = 0;
    private const FOLLOW_IDLE_DELAY:Number = 0.5;

    public static function newInstance(me:AIPlayer):FollowState {

        if (_pool.length > 0) {
            var result:FollowState = _pool.shift();
            result.reset(me);
            return result;
        } else {
            return new FollowState(me);
        }
    }

    public static function release(state:FollowState):void {
        _pool.push(state);
    }

    public function reset(me:AIPlayer):void {
        _me = me;
    }

    public function FollowState(me:AIPlayer) {
        reset(me);
    }

    public function enter():void {
        _me.play("walk");
        _followIdleTimer = 0;
    }

    public function exit():void {
        _me.acceleration.x = 0;
        FollowState.release(this);
    }

    public function update():void {
        if (_me.y + _me.height > 172) {
            _me.y = 172 - _me.height;
        }
        
        var player:Sheen = _me.playState.player;
        if (player.x > _me.x) {
            _me.facing = FlxSprite.RIGHT;
        } else {
            _me.facing = FlxSprite.LEFT;
        }

        var otherGuys:Array = _me.playState.enemies.members;
        for each (var e:AIPlayer  in otherGuys) {
            if (e != _me && !e.dying) {
                if (_me.facing == FlxSprite.LEFT) {
                    if ((e.x < _me.x) && (e.x+e.width > _me.x))  {
                        if (!(e is Mime)) {
                            _me.fsm.changeState(IdleState.newInstance(_me));
                            return;
                        }
                    }
                } else {
                    if ((e.x > _me.x) && (_me.x+_me.width > e.x))  {
                        if (!(e is Mime)) {
                            _me.fsm.changeState(IdleState.newInstance(_me));
                            return;
                        }
                    }
                }
            }
        }

        if ( Math.abs(player.x - _me.x) > 30) {
            _followIdleTimer += FlxG.elapsed;
            if (_followIdleTimer > FOLLOW_IDLE_DELAY) {
                _followIdleTimer = 0;
                if (Math.random() > 0.2) {
                    _me.fsm.changeState(FollowIdleState.newInstance(_me));
                    return;
                }
            }

            if (_me.x > player.x) {
                _me.acceleration.x = -_me.drag.x;
            } else {
                _me.acceleration.x = _me.drag.x;
            }
        } else if (Math.abs(player.x - _me.x) < 20) {
            _me.fsm.changeState(StepBackState.newInstance(_me));
        } else {
            _me.fsm.changeState(IdleState.newInstance(_me));
        }
    }
}
}