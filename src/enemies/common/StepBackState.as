package enemies.common {
import ai.AIPlayer;
import ai.State;

    import enemies.Punk;

    import org.flixel.FlxSprite;

    import sheen.Sheen;

    public class StepBackState implements State {
        private var _me:AIPlayer;
        private static var _pool:Array = new Array();

        public static function newInstance(me:AIPlayer):StepBackState {

            if (_pool.length > 0) {
                var result:StepBackState = _pool.shift();
                result.reset(me);
                return result;
            } else {
                return new StepBackState(me);
            }
        }

        public static function release(state:StepBackState):void {
            _pool.push(state);
        }

        public function StepBackState(me:AIPlayer):void {
            reset(me);
        }

        public function reset(me:AIPlayer):void {
            _me = me;
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
            for each (var e:FlxSprite  in otherGuys) {
                if (e != _me) {
                    if (_me.facing == FlxSprite.LEFT) {
                        if ((e.x < _me.x) && (e.x + e.width > _me.x)) {
                            _me.acceleration.x = _me.drag.x;
                            return;
                        }
                    } else {
                        if ((e.x > _me.x) && (_me.x + _me.width > e.x)) {
                            _me.acceleration.x = -_me.drag.x;
                            return;
                        }
                    }
                }
            }

            if (Math.abs(player.x - _me.x) < 30) {
                if (_me.x > player.x) {
                    _me.acceleration.x = _me.drag.x;
                } else {
                    _me.acceleration.x = -_me.drag.x;
                }
            } else {
                _me.fsm.changeState(IdleState.newInstance(_me));
            }
        }

        public function enter():void {
            _me.play("walk_back");
        }

        public function exit():void {
            _me.acceleration.x = 0;
            StepBackState.release(this);
        }
    }
}