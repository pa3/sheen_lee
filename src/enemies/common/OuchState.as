package enemies.common {
import ai.AIPlayer;
import ai.State;

    import enemies.Punk;

    import org.flixel.FlxG;
    import org.flixel.FlxSprite;

    import sheen.Sheen;
    import sheen.Sheen;

    public class OuchState implements State {
        private var _me:AIPlayer;
        private static var _pool:Array = new Array();

        private var _ouchTimer:Number;

        private const OUCH_DELAY:Number = 1.5;

        public static function newInstance(me:AIPlayer):OuchState {

            if (_pool.length > 0) {
                var result:OuchState = _pool.shift();
                result.reset(me);
                return result;
            } else {
                return new OuchState(me);
            }
        }

        public static function release(state:OuchState):void {
            _pool.push(state);
        }

        public function reset(me:AIPlayer):void {
            _me = me;
            _ouchTimer = 0;
        }

        public function OuchState(me:AIPlayer) {
            reset(me);
        }

        public function update():void {
            if (_me.y + _me.height > 172) {
                _me.y = 172 - _me.height;
            }
            
            _ouchTimer += FlxG.elapsed;
            if (_ouchTimer > OUCH_DELAY) {
                _me.fsm.changeState(IdleState.newInstance(_me));
            }
        }

        public function enter():void {
            _me.play("ouch");
        }

        public function exit():void {
            OuchState.release(this);
        }
    }
}