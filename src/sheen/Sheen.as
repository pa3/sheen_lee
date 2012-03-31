package sheen {
import ai.AIPlayer;

import gui.Bubble;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import sheen.attacks.Attack;

import sheen.attacks.FlightKickAttack;
import sheen.attacks.FlightKickAttack;

import states.GameOver;

import states.PlayState;

public class Sheen extends FlxSprite {


    public static var PLAYER_RUN_SPEED:int = 80;
    public static var JUMP_ACCELERATION:Number = 190;
    public static var HITPOINTS_TO_KNOCK_OUT:int = 20;
    public static var HEALTH:Number = 100;
    public static var ENERGY:Number = 100;
    public static var ENERGY_REGENERATE_FACTOR:Number = 10;

    //[Embed(source='../../data/sheen/sheen.png')] private var ImgSheen:Class;
    //[Embed(source='../../data/sheen/sheen_fire_kick.png')]
    //[Embed(source='../../data/sheen/sheen_fire_kick_2.png')]
    [Embed(source='../../data/sheen/sheen_3.png')]
    private var ImgSheen:Class;


    [Embed(source = "../../data/sfx/ouch_sheen.mp3")]
    private var Ouch:Class;

    [Embed(source = "../../data/sfx/punch1.mp3")]
    private var Hit0:Class;
    [Embed(source = "../../data/sfx/punch2.mp3")]
    private var Hit1:Class;
    [Embed(source = "../../data/sfx/punch3.mp3")]
    private var Hit2:Class;
    [Embed(source = "../../data/sfx/punch4.mp3")]
    private var Hit3:Class;

    private var hitSound0:FlxSound = new FlxSound();
    private var hitSound1:FlxSound = new FlxSound();
    private var hitSound2:FlxSound = new FlxSound();
    private var hitSound3:FlxSound = new FlxSound();


    private var _ouchSound:FlxSound = new FlxSound();
    

    private var _sitting:Boolean = false;
    private var _afterTheDeath:Boolean = false;
    private var _knockOut:Boolean = false;

    private var _fireballs:FlxGroup = null;
    public var _enemies:FlxGroup = null;
    private var _death:SheenDeath;
    private var _deathFacing:uint;

    public var _playState:PlayState;

    public var attackersCount:uint = 0;


    private var _hitpointsSinceLastKnockOut:int = 0;

    private var _lastPosition:FlxPoint = new FlxPoint();

    public var _attackManager:SheenAttackManager;



    public function Sheen(X:Number, Y:Number, fireballs:FlxGroup, enemies:FlxGroup, deathLayer:FlxGroup, playState:PlayState) {
        super();
        _playState = playState;
        _attackManager = new SheenAttackManager(this);
        _playState.add(_attackManager);

        _ouchSound.loadEmbedded(Ouch);
        hitSound0.loadEmbedded(Hit0);
        hitSound1.loadEmbedded(Hit1);
        hitSound2.loadEmbedded(Hit2);
        hitSound3.loadEmbedded(Hit3);

        _fireballs = fireballs;
        _enemies = enemies;
        //loadGraphic(ImgSheen, true, true, 74, 58);
        loadGraphic(ImgSheen, true, true, 92, 58);
        width = 40;
        height = 58;
        offset.x = 26;
        //offset.y = 32;
        addAnimation("idle", [0,1], 2, true);
        addAnimation("walk", [1,2,3,4,5,6], 10, true);
        addAnimation("punch", [8,9], 10, false);
        addAnimation("punch_back", [8,7], 10, false);
        addAnimation("kick", [10, 20, 21, 21, 20, 10], 12, false);
        addAnimation("fire_kick", [10, 11, 12, 12, 11, 10], 12, false);
        addAnimation("failed_fire_kick", [10, 11, 10], 12, false);
        addAnimation("sit_down", [17,18], 20, false);
        addAnimation("stand_up", [18,17,0], 20, false);
        addAnimation("stand_up_after_knockout", [18,17,0], 5, false);

        addAnimation("jump_1", [15], 10, false);
        addAnimation("jump_2", [16], 10, false);
        addAnimation("shoot", [19], 4, false);
        addAnimation("ouch", [13], 2, false);
        addAnimation("block", [14], 10, false);
        addAnimation("flight_kick", [22, 23], 5, false);
        addAnimation("flight_kick_landing", [24], 5, false);
        addAnimation("bicycle_kick", [35,36,37,38,39,40,41,42,43], 11, false);
        addAnimation("combo1", [25,26], 10, false);
        addAnimation("combo1_back", [25,8], 10, false);
        addAnimation("combo2", [20], 10, false);
        addAnimation("combo2_back", [21, 20], 10, false);
        addAnimation("combo3", [27,28,29,29], 10, false);
        addAnimation("combo3_back", [20], 10, false);
        addAnimation("combo4", [30,31,32,33,34], 10, false);

        play("idle");
        drag.x = PLAYER_RUN_SPEED * 8;
        acceleration.y = GS.GRAVITY_ACCELERATION;
        maxVelocity.x = PLAYER_RUN_SPEED;
        maxVelocity.y = JUMP_ACCELERATION;
        collideTop = collideBottom = false;
        _death = new SheenDeath(this, _playState);
        deathLayer.add(_death);
        reset(X, Y);
        _callback = this.animChanged;
    }


    override public function update():void {
        _lastPosition.x = x;
        _lastPosition.y = y;

        super.update();


        if (!FlxG.chatWithTheBoss) {
            if (_attackManager.getCurrentAttack() is FlightKickAttack) {
                dealDamage(FlightKickAttack.DAMAGE, FlightKickAttack.KNOCK_OUT, FlightKickAttack.UNBLOCKABLE);
//                if (velocity.y > 0 && y > 80) {
//                    play("flight_kick_landing");
//                }
            }

            ComboKeys.getInstance().update(FlxG.elapsed);
            if (FlxG.keys.justPressed("DOWN")) {
                ComboKeys.getInstance().keyPressed("D");
            }
            else if (FlxG.keys.justPressed("UP")) {
                ComboKeys.getInstance().keyPressed("U");
            }
            else if ((FlxG.keys.justPressed("LEFT") && _facing == LEFT) || (FlxG.keys.justPressed("RIGHT") && _facing == RIGHT)) {
                ComboKeys.getInstance().keyPressed("F");
            }
            else if ((FlxG.keys.justPressed("LEFT") && _facing == RIGHT) || (FlxG.keys.justPressed("RIGHT") && _facing == LEFT)) {
                ComboKeys.getInstance().keyPressed("B");
            }
            else if (FlxG.keys.justPressed("Z")) {
                ComboKeys.getInstance().keyPressed("A");
            }
            else if (FlxG.keys.justPressed("X")) {
                ComboKeys.getInstance().keyPressed("BL");
            }
        }



        if (y + height > 172) {
            velocity.y = 0;
            y = 172 - height;
        }

        if (_curAnim.name == "ouch" && !finished) {
            return;
        }


        if (velocity.y != 0) {
            if (!_attackManager.getCurrentAttack())
                if (y > 90) {
                    play("jump_1");
                } else {
                    play("jump_2");
                }
        } else if (!isInAction() && (_attackManager.getCurrentAttack() == null || (_attackManager.getCurrentAttack() is FlightKickAttack)) ) {
            _attackManager.animEnded("");
            if (velocity.x == 0) {
                play("idle");
            }
            else {
                play("walk");
            }
        }


        if (!FlxG.chatWithTheBoss) {
            acceleration.x = 0;
            //if (_curAnim.name != "punch" && _curAnim.name != "kick" && _curAnim.name != "shoot" && _curAnim.name != "fire_kick") {

            if (!isInAction()) {
                if (FlxG.keys.LEFT) {
                    facing = LEFT;
                    if (_curAnim.name != "block") {
                        _sitting = false;
                        acceleration.x = -drag.x;
                    }
                }
                else if (FlxG.keys.RIGHT) {
                    facing = RIGHT;
                    if (_curAnim.name != "block") {
                        _sitting = false;
                        acceleration.x = drag.x;
                    }
                }
                else if (FlxG.keys.DOWN && !velocity.y && !_sitting) {
                    _sitting = true;
                    play("sit_down");
                    //acceleration.x = 0;
                }

                if (FlxG.keys.UP && !velocity.y) {
                    _sitting = false;
                    velocity.y = -JUMP_ACCELERATION;
                }

            }


            if (/*FlxG.keys.justPressed("C")*/ FlxG.keys.X && !_sitting && _curAnim.name != "punch" && _curAnim.name != "kick" && velocity.y == 0 && _curAnim.name != "fire_kick") {
                play("block");
            }
            if (FlxG.keys.justReleased("DOWN") && _sitting && !velocity.y) {
                _sitting = false;
                play("stand_up");
            }
        }
    }


    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        if (_afterTheDeath)
            flicker(4, 0.1);
        _lastPosition.x = X;
        _lastPosition.y = Y;
        play("idle", true);
        velocity.x = velocity.y = acceleration.x = 0;
        health = HEALTH;
    }

    override public function kill():void {
        super.kill();
        _afterTheDeath = true;
        _death.die(_deathFacing, x, y);

        if (FlxG.lives == 0) {
            FlxG.state = new GameOver();
        } else {
            FlxG.lives--;
        }
        
        
    }

    public function hurt_me(deathFacing:uint, Damage:Number):void {

        //if (flickering() || _attackManager.getCurrentAttack()) {
        if (flickering()) {
            return;
        }
        if (isBlocking && deathFacing == facing) {
            velocity.x = (deathFacing == RIGHT) ? -PLAYER_RUN_SPEED : PLAYER_RUN_SPEED;
        } else {
            _ouchSound.play();
            _hitpointsSinceLastKnockOut += Damage;
            if (y + height < 172 || _hitpointsSinceLastKnockOut >= HITPOINTS_TO_KNOCK_OUT || velocity.y != 0) {
                if (health - Damage > 0) {
                    this.exists = false;
                    this.visible = false;
                    _knockOut = true;
                    _attackManager._currentAttack = null;
                    _death.knockOut(deathFacing, x, y);
                } else {
                    doHurt(deathFacing, Damage);
                }
            } else {
                doHurt(deathFacing, Damage);
            }
            this.hurt(Damage);
        }
    }

    private function doHurt(deathFacing:uint, Damage:Number):void {
        play("ouch");
        _sitting = false;
        velocity.x = (deathFacing == RIGHT) ? -PLAYER_RUN_SPEED : PLAYER_RUN_SPEED;
        _deathFacing = deathFacing;
    }

    public function get isSitting():Boolean {
        return _curAnim.name == "sit_down";
    }

    public function get isBlocking():Boolean {
        return _curAnim.name == "block";
    }

    public function animChanged(animName:String, frameNumber:uint, frameIndex:uint):void {
        _attackManager.animChanged(animName, frameNumber);

        if (finished && animName == "stand_up_after_knockout") {
            _sitting = false;
            _knockOut = false;
            play("idle");
        } else if (finished && !_sitting && !(_attackManager.getCurrentAttack() is FlightKickAttack)) {
            if (!_attackManager.animEnded(animName)) {
                play("idle");
            }
        }
    }

    public function isInAction():Boolean {
        return _sitting ||
                _curAnim.name == "block" ||
                _curAnim.name == "ouch" || (_attackManager.getCurrentAttack() != null && !(_attackManager.getCurrentAttack() is FlightKickAttack));
    }

    public function standUp():void {
        dead = false;
        exists = true;
        visible = true;
        x = _death.x;
        y = _death.y;
        play("stand_up_after_knockout");
        _hitpointsSinceLastKnockOut = 0;
        _sitting = true;
    }

    public function get  isKnockedOut():Boolean {
        return _knockOut;
    }


    public function get isStandingUpAfterKnockOut():Boolean {
        return _curAnim.name == "stand_up_after_knockout";
    }


    public function dealDamage(damageAmount:Number, knockOut:Boolean, unblockable:Boolean):void {
        var flightAttack:FlightKickAttack = (_attackManager.getCurrentAttack() as FlightKickAttack);
        for each (var enemyForDamage:AIPlayer in _enemies.members) {
            if (Math.abs(enemyForDamage.x - x) < 38) {
                if (((enemyForDamage.x > x) && facing == RIGHT) || ((enemyForDamage.x <= x) && facing == LEFT)) {
                    if ((flightAttack && y > 100) || !flightAttack) {
                        if (!enemyForDamage.dying && !enemyForDamage.dead) {
                            this["hitSound"+(Math.floor(Math.random()*3.9))].play();

                            if (flightAttack) {
                                if (flightAttack.alreadyHurted(enemyForDamage)) {
                                    return;
                                } else {
                                    flightAttack.hurting(enemyForDamage);
                                }
                            }
                           if (knockOut) {
                                enemyForDamage.knockOut(damageAmount, unblockable);
                            } else {
                                enemyForDamage.justHurt(damageAmount, unblockable);
                            }
                        }
                    }
                }
            }
        }
    }

    public function launchFireBall():void {
    }
}
}