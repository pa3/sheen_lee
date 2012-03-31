package enemies.mime.states {
    import ai.State;

    import enemies.Mime;

    import org.flixel.FlxG;
    import org.flixel.FlxSprite;

    import sheen.Sheen;

    public class IdleState implements State {
        private var _me:Mime;
        private static var _pool:Array = new Array();

        private var _launchTimer:Number = 0;

        public static function newInstance(me:Mime):IdleState {
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

        public function IdleState(me:Mime) {
            reset(me);
        }

        public function reset(me:Mime):void {
            _me = me;
        }

        public function enter():void {
            _me.play("idle");
            _me.acceleration.x = 0;
            _launchTimer = 100;
        }

        public function exit():void {
            IdleState.release(this);
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

            if ((_me.x + _me.width) > (_me.playState._focus.x + 132) || (_me.x < _me.playState._focus.x - 120) ) {
                _me.fsm.changeState(StepInState.newInstance(_me));
            } else {
                _launchTimer += FlxG.elapsed;
                if (_launchTimer > Mime.LAUNCH_DELAY[_me.level]) {
                    _launchTimer = 0;
                    _me.launchBall();
                }
            }
        }
    }
}