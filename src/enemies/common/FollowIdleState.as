package enemies.common {
import ai.AIPlayer;
import ai.State;

import enemies.common.FollowState;
import enemies.Punk;

    import org.flixel.FlxG;

    public class FollowIdleState implements State {

        private var _me:AIPlayer;
        private static var _pool:Array = new Array();
        private var _thinkTimer:Number = 0;
        private const THINK_DELAY:Number = 0.2;

        public function FollowIdleState(me:AIPlayer) {
            reset(me);
        }

        public static function newInstance(me:AIPlayer):FollowIdleState {

            if (_pool.length > 0) {
                var result:FollowIdleState = _pool.shift();
                result.reset(me);
                return result;
            } else {
                return new FollowIdleState(me);
            }
        }

        public static function release(state:FollowIdleState):void {
            _pool.push(state);
        }

        public function reset(me:AIPlayer):void {
            _me = me;
        }

        public function enter():void {
            _me.play("idle");
            _me.acceleration.x = 0;
            _thinkTimer = 0;
        }

        public function exit():void {
            FollowIdleState.release(this);
        }

        public function update():void {
            if (_me.y + _me.height > 172) {
                _me.y = 172 - _me.height;
            }
            
            _thinkTimer += FlxG.elapsed;
            if (_thinkTimer > THINK_DELAY) {
                _me.fsm.changeState(FollowState.newInstance(_me));
            }
        }
    }
}