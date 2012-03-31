package enemies.customstate {
import ai.AIPlayer;
import ai.State;

import org.flixel.FlxSprite;

public class Boss3DeathState implements State {
    private var _me:AIPlayer;
    private static var _pool:Array = new Array();

    protected static const PLAYER_RUN_SPEED:int = 80;
    protected static const GRAVITY_ACCELERATION:Number = 420;
    protected static const JUMP_ACCELERATION:Number = 240;


    private var _groundTouchCount:uint = 0;

    public function Boss3DeathState(me:AIPlayer) {
        reset(me);
    }

    public static function newInstance(me:AIPlayer):Boss3DeathState {

        if (_pool.length > 0) {
            var result:Boss3DeathState = _pool.shift();
            result.reset(me);
            return result;
        } else {
            return new Boss3DeathState(me);
        }
    }

    public static function release(state:Boss3DeathState):void {
        _pool.push(state);
    }

    public function reset(me:AIPlayer):void {
        _me = me;
        _groundTouchCount = 0;
    }

    public function enter():void {
        _me.dying = true;
        _me.acceleration.y = GRAVITY_ACCELERATION;
        _me.maxVelocity.x = PLAYER_RUN_SPEED;
        _me.maxVelocity.y = JUMP_ACCELERATION;
        _me.velocity.x = (_me.facing == FlxSprite.LEFT) ? 100 : -100;
        _me.velocity.y = -100;
        _me.play("flight_1", true);
        _groundTouchCount = 0;
    }

    public function exit():void {
        Boss3DeathState.release(this);
    }

    public function update():void {

        if (_groundTouchCount < 2) {
            _me.velocity.x = (_me.facing == FlxSprite.LEFT) ? 80 : -80;
        }

        if (_me.y + _me.height >= 195 && _groundTouchCount < 3) {
            _groundTouchCount++;
            if (_groundTouchCount == 1) {
                _me.velocity.y = -100;
            }
            _me.y = 195 - _me.height;
        }

        if (_groundTouchCount == 0) {
            if (_me.velocity.y < -20) {
                _me.play("flight_1", true);
            } else if (_me.velocity.y < 0) {
                _me.play("flight_2", true);
            } else {
                _me.play("flight_3", true);
            }
        }
        else if (_groundTouchCount == 1) {
            _me.play("flight_4", true);
        }
        else if (_groundTouchCount == 2) {
            _me.velocity.x = 0;
            _me.velocity.y = 0;
            _me.acceleration.y = 0;
            //flicker(2, 0.2);
            _me.flicker(2);
        }
        else if (!_me.flickering()) {
            _me.dead = true;
            _me.exists = false;
        }
    }
}
}