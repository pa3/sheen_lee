package sheen {
import org.flixel.FlxG;
import org.flixel.FlxSprite;

import states.PlayState;

public class SheenDeath extends FlxSprite {

    [Embed(source='../../data/sheen/sheen_death.png')]
    private var ImgSheenDeath:Class;

    private var _groundTouchCount:uint = 0;
    private var _player:Sheen;
    private var _playState:PlayState;


    protected static const PLAYER_START_X:int = 300;
    protected static const PLAYER_START_Y:int = 300;
    protected static const PLAYER_RUN_SPEED:int = 80;
    protected static const GRAVITY_ACCELERATION:Number = 420;
    protected static const JUMP_ACCELERATION:Number = 240;


    private var _knockOut:Boolean = false;

    public function SheenDeath(player:Sheen, playState:PlayState) {
        super();
        _player = player;
        loadGraphic(ImgSheenDeath, true, true, 58, 45);
        width = 58;
        height = 45;
        offset.x = 0;
        offset.y = 0;
        addAnimation("frame_1", [0], 10, false);
        addAnimation("frame_2", [1], 10, false);
        addAnimation("frame_3", [2,1,2], 5, false);
        addAnimation("stand_up", [3,4,3,4], 5, false);
        exists = false;
        _playState = playState;
    }

    override public function update():void {
        super.update();

        if (x + width > _playState.getPlayerMaxX()) {
            x = _playState.getPlayerMaxX() - width;
        }

        if (x < _playState.getPlayerMinX()) {
            x = _playState.getPlayerMinX() 
        }

        _player.x = x;
        _player.y = y;


        if (y + height >= 190 && _groundTouchCount < 3) {
            _groundTouchCount++;
            if (_groundTouchCount == 1) {
                velocity.y = -100;
            }
            y = 190 - height;
        }

        if (_groundTouchCount == 0) {
            if (velocity.y < 0) {
                play("frame_1", true);
            } else {
                play("frame_2", true);
            }
        }
        else if (_groundTouchCount == 1) {
            if (_curAnim.name != "frame_3") {
                play("frame_3", true);
            }
        }
        else if (_groundTouchCount == 2) {
            //play("frame_3", true);
            velocity.x = 0;
            velocity.y = 0;
            acceleration.y = 0;
            if (!_knockOut) {
                flicker(2, 0.1);
            }
        }
        else if (_knockOut) {
            if (_curAnim.name != "stand_up") {
                play("stand_up");
            } else if (finished) {
                super.kill();
                _player.standUp();
            }
        } else if (!flickering()) {
            kill();
        }


    }

    public function die(Direction:uint, X:Number, Y:Number):void {
        reset(X, Y);
        _flicker = false;
        _flickerTimer = -1;
        visible = true;
        drag.x = 0;
        _knockOut = false;
        facing = Direction;
        acceleration.y = GRAVITY_ACCELERATION;
        maxVelocity.x = PLAYER_RUN_SPEED;
        maxVelocity.y = JUMP_ACCELERATION;
        velocity.x = facing == LEFT ? 100 : -100;
        velocity.y = -50;
        _groundTouchCount = 0;
        play("frame_1");
    }

    public function knockOut(Direction:uint, X:Number, Y:Number):void {
        reset(X, Y);
        _flicker = false;
        _flickerTimer = -1;
        visible = true;
        drag.x = 0;
        _knockOut = true;
        facing = Direction;
        acceleration.y = GRAVITY_ACCELERATION;
        maxVelocity.x = PLAYER_RUN_SPEED;
        maxVelocity.y = JUMP_ACCELERATION;
        velocity.x = facing == LEFT ? 100 : -100;
        velocity.y = -50;
        _groundTouchCount = 0;
        play("frame_1");
    }

    override public function kill():void {
        super.kill();
        _player.reset(0, 0);
    }
}
}