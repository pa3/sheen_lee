package enemies.mime.states {
    import ai.State;

    import enemies.Mime;

import org.flixel.FlxSprite;

public class StepInState implements State {
        private var _me:Mime;
        private static var _pool:Array = new Array();

        public static function newInstance(me:Mime):StepInState {
            if (_pool.length > 0) {
                var result:StepInState = _pool.shift();
                result.reset(me);
                return result;
            } else {
                return new StepInState(me);
            }
        }

        public static function release(state:StepInState):void {
            _pool.push(state);
        }

        public function StepInState(me:Mime) {
            reset(me);
        }

        public function reset(me:Mime):void {
            _me = me;
        }

        public function enter():void {
            _me.play("walk");
        }

        public function exit():void {
            StepInState.release(this);
        }

        public function update():void {
            if (_me.y + _me.height > 172) {
                _me.y = 172 - _me.height;
            }
            if (_me.facing == FlxSprite.LEFT) {
                _me.acceleration.x = - 100;
                if ((_me.x + _me.width) <= (_me.playState._focus.x + 132)) {
                    _me.fsm.changeState(IdleState.newInstance(_me));
                }
            } else {
                _me.acceleration.x = 100;
                if (_me.x > _me.playState._focus.x - 120) {
                    _me.fsm.changeState(IdleState.newInstance(_me));
                }
            }

        }
    }
}