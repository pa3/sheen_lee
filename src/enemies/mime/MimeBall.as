package enemies.mime {
import enemies.Mime;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import states.PlayState;

public class MimeBall extends FlxSprite {
    [Embed(source='../../../data/enemies/mime_ball.png')]
    private var Img:Class;

    protected static const GRAVITY_ACCELERATION:Number = 420;
    protected static const ENGINE_START_DELAY:Number = 0.2;

    private var _groundTouchCount:uint = 0;

    private var _activated:Boolean = false;
    private var _engineStarted:Boolean = false;
    private var _fallen:Boolean = false;
    private var _playState:PlayState;

    private var _engineStartTimer:Number = 0;

    private var level:int = 0;


    [Embed(source="../../../data/sfx/ball.mp3")]
    private var Engine:Class;
    private var _engineSound:FlxSound = new FlxSound();

    [Embed(source="../../../data/sfx/expl.mp3")]
    private var Explosion:Class;
    private var _explSound:FlxSound = new FlxSound();

    public function MimeBall(Direction:uint, playState:PlayState, level:int = 0) {
        super();

        _engineSound.loadEmbedded(Engine);
        _explSound.loadEmbedded(Explosion);

        this.level = level;
        _playState = playState;
        loadGraphic(Img, true, true, 28, 23);
        width = 6;
        height = 6;
        offset.x = 9;
        offset.y = 8;
        addAnimation("idle_0", [0], 2, false);
        addAnimation("flight_0", [1, 2], 10, true);
        addAnimation("explosion_0", [3, 4, 5, 6, 7], 15, false);

        addAnimation("idle_1", [0], 2, false);
        addAnimation("flight_1", [1, 2], 10, true);
        addAnimation("explosion_1", [3, 4, 5, 6, 7], 15, false);

        addAnimation("idle_2", [0], 2, false);
        addAnimation("flight_2", [1, 2], 10, true);
        addAnimation("explosion_2", [3, 4, 5, 6, 7], 15, false);
        play("idle_" + level);
        facing = Direction;
        collideTop = collideBottom = false;
        exists = false;
        dead = true;
    }

    override public function update():void {
        super.update();

        if (_fallen) {
            acceleration.y = GRAVITY_ACCELERATION;
            if (y + height >= 170 && _groundTouchCount < 3) {
                _groundTouchCount++;
                if (_groundTouchCount == 1) {
                    velocity.y = -100;
                }
                y = 170 - height;
            } else {
                if (y + height >= 170) {
                    y = 170 - height;
                }
            }

            if (_groundTouchCount == 2) {
                //play("frame_3", true);
                velocity.x = 0;
                velocity.y = 0;
                acceleration.y = 0;
                //flicker(2, 0.2);
                flicker(2);
            }
            else if (_groundTouchCount > 2 && !flickering()) {
                kill();
            }
        } else if (_activated) {
            if (!_engineStarted) {
                _engineStartTimer += FlxG.elapsed;
                if (_engineStartTimer > ENGINE_START_DELAY) {
                    _engineStarted = true;
                    play("flight_" + level);
                }
            } else {
                if (_curAnim.name == "flight_" + level) {
                    acceleration.x = facing == LEFT ? -Mime.BALL_ACCELERATION[level] : Mime.BALL_ACCELERATION[level];
                    acceleration.y = 0;
                    if (FlxHitTest.complexHitTestObject(_playState.player, this)) {
                        if (!_playState.player.dead) {
                            _explSound.play();
                            _playState.player.hurt_me((~LEFT) & 1, Mime.BALL_DAMAGE[level]);
                            acceleration.x = velocity.x = 0;
                            play("explosion_" + level);
                        }
                    }
                    if (x < (_playState._focus.x - 132) || x > (_playState._focus.x + 132)) {
                        kill();
                    }
                } else if (_curAnim.name == "explosion_" + level && finished) {
                    this.kill();
                }
            }
        }

    }

    public function resetMe(X:Number, Y:Number, level:int):void {
        super.reset(X, Y);
        this.level = level;
        _groundTouchCount = 0;
        _fallen = false;
        _activated = false;
        _engineStarted = false;
        _engineStartTimer = 0;
    }

    public function activate():void {
        _engineSound.play();
        _activated = true;
        acceleration.y = 0;
    }

    public function startFall():void {
        _fallen = true;
    }

}
}