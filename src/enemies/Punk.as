package enemies {
import ai.AIPlayer;

import effects.BigBlood;
import effects.LittleBlood;

import enemies.common.DeathState;
import enemies.common.IdleState;
import enemies.common.OuchState;

import org.flixel.FlxG;
import org.flixel.FlxSound;

import states.PlayState;

public class Punk extends AIPlayer {
    [Embed(source='../../data/enemies/punk_0.png')]
    private var Img0:Class;
    [Embed(source='../../data/enemies/punk_1.png')]
    private var Img1:Class;
    [Embed(source='../../data/enemies/punk_2.png')]
    private var Img2:Class;

    public static var RUN_SPEED:Array = new Array();
    public static var LOCAL_ATTACK_DELAY:Array = new Array();
    public static var LOCAL_BLOCK_CHANCE:Array = new Array();
    public static var ATTACK_DAMAGE:Array = new Array();
    public static var HEALTH:Array = new Array()
    public static var SOCRE_FOR_DEATH:Array = new Array()

    private var level:int = 0;

    [Embed(source="../../data/sfx/ouch2.mp3")]
    private var Ouch:Class;
    private var _ouchSound:FlxSound = new FlxSound();

    [Embed(source="../../data/sfx/kick2.mp3")]
    private var HighAttack:Class;

    private var _highAttackSound:FlxSound = new FlxSound();



    public function Punk(X:Number, Y:Number, playState:PlayState, level:int = 0) {
        super(playState);

        this.level = level;

        _ouchSound.loadEmbedded(Ouch);
        _highAttackSound.loadEmbedded(HighAttack);


        _scoreForDeath = SOCRE_FOR_DEATH[level];
        _fallY = 198;
        ATTACK_DELAY = LOCAL_ATTACK_DELAY[level];
        HIGH_ATTACK_DAMAGE = ATTACK_DAMAGE[level];
        BLOCK_CHANCE = LOCAL_BLOCK_CHANCE[level];

        this.x = X;
        this.y = Y;
        switch(level) {
            case 0:
                loadGraphic(Img0, true, true, 64, 54);
                break;
            case 1:
                loadGraphic(Img1, true, true, 64, 54);
                break;
            case 2:
                loadGraphic(Img2, true, true, 64, 54);
                break;
        }
        width = 32;
        height = 54;
        offset.x = 20;
        offset.y = 0;
        addAnimation("idle", [0], 2, true);
        addAnimation("walk", [0,0,1,2,3,4,5], 10, true);
        addAnimation("walk_back", [5,4,3,2,1,0,0], 10, true);
        addAnimation("attack", [7, 8, 9, 9, 8, 7], 10, false);
        addAnimation("ouch", [6], 10, false);
        addAnimation("block", [13], 0.5, false);
        addAnimation("flight_1", [10], 10, false);
        addAnimation("flight_2", [11], 10, false);
        addAnimation("flight_3", [12], 10, false);
        play("idle");
        drag.x = RUN_SPEED[level] * 8;
        maxVelocity.x = RUN_SPEED[level];
        health = 70;
        reset(X, Y);
    }

    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        health = HEALTH[level];
    }


    override public function haveLowAttack():Boolean {
        return false;
    }


    override protected function get ouchSound():FlxSound {
        return _ouchSound;
    }


    override public function get highAttackSound():FlxSound{
        return _highAttackSound;
    }
}
}