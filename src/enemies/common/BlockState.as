package enemies.common {
import ai.AIPlayer;
import ai.State;

import org.flixel.FlxSprite;

import sheen.Sheen;

public class BlockState implements State {

    private var _me:AIPlayer;
    private static var _pool:Array = new Array();

    public static function newInstance(me:AIPlayer):BlockState {
        if (_pool.length > 0) {
            var result:BlockState = _pool.shift();
            result.reset(me);
            return result;
        } else {
            return new BlockState(me);
        }
    }

    public static function release(state:BlockState):void {
        _pool.push(state);
    }

    public function reset(me:AIPlayer):void {
        _me = me;
    }

    public function BlockState(me:AIPlayer) {
        reset(me);
    }

    public function enter():void {
        _me.blocking = true;
            _me.play("block");
    }

    public function exit():void {
        _me.blocking = false;
        BlockState.release(this);
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
        
        if (_me.finished) {
            _me.fsm.changeState(IdleState.newInstance(_me));
        }
    }
}
}