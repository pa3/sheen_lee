package enemies {
import ai.AIPlayer;

import effects.BigBlood;
import effects.LittleBlood;

import enemies.common.DeathState;
import enemies.common.IdleState;
import enemies.common.OuchState;

import org.flixel.FlxG;
import org.flixel.FlxSound;

import org.flixel.FlxSound;

import states.PlayState;


public class Traitor extends AIPlayer {

    [Embed(source='../../data/enemies/traitor_0.png')]
    private var Img0:Class;
    [Embed(source='../../data/enemies/traitor_1.png')]
    private var Img1:Class;
    [Embed(source='../../data/enemies/traitor_2.png')]
    private var Img2:Class;

    public static var RUN_SPEED:Array = new Array();
    public static var LOCAL_ATTACK_DELAY:Array = new Array();
    public static var ATTACK_DAMAGE:Array = new Array();
    public static var HEALTH:Array = new Array()
    public static var SOCRE_FOR_DEATH:Array = new Array()
    public static var LOCAL_BLOCK_CHANCE:Array = new Array()

    private var level:int = 0;
    
    [Embed(source="../../data/sfx/ouch1.mp3")]
    private var Ouch:Class;
    private var _ouchSound:FlxSound = new FlxSound();

    [Embed(source="../../data/sfx/kick.mp3")]
    private var LowAttack:Class;

    private var _lowAttackSound:FlxSound = new FlxSound();

    public function Traitor(X:Number, Y:Number, playSate:PlayState, level:int = 0) {
        super(playSate);
        this.level = level;
        _scoreForDeath = SOCRE_FOR_DEATH[level];
        _fallY = 186;

        _ouchSound.loadEmbedded(Ouch);
        _ouchSound.volume = 1.5;

        _lowAttackSound.loadEmbedded(LowAttack);
        _lowAttackSound.volume = 1.5;
        
        ATTACK_DELAY = LOCAL_ATTACK_DELAY[level];
        LOW_ATTACK_DAMAGE = ATTACK_DAMAGE[level];
        BLOCK_CHANCE = LOCAL_BLOCK_CHANCE[level]

        this.x = X;
        this.y = Y;
        switch (level) {
            case 0:
                loadGraphic(Img0, true, true, 74, 50);
                break;
            case 1:
                loadGraphic(Img1, true, true, 74, 50);
                break;
            case 2:
                loadGraphic(Img2, true, true, 74, 50);
                break;

        }
        width = 32;
        height = 50;
        offset.x = 20;
        offset.y = 0;
        addAnimation("idle", [0,1], 2, true);
        addAnimation("walk", [0,0,5,6,7,8,9], 10, true);
        addAnimation("walk_back", [8,8,7,6,5,0,0], 10, true);
        addAnimation("attack_low", [2, 3, 4, 4, 3, 2], 10, false);
        addAnimation("ouch", [10], 10, false);
        addAnimation("flight_1", [11], 10, false);
        addAnimation("flight_2", [12], 10, false);
        addAnimation("flight_3", [13], 10, false);
        addAnimation("block", [14], 0.5, false);
        play("idle");
        collideTop = collideBottom = false;
        drag.x = RUN_SPEED[level] * 8;
        maxVelocity.x = RUN_SPEED[level];
        health = 100;
        reset(X, Y);
    }


    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        health = HEALTH[level];
    }


    
    override public function haveHighAttack():Boolean {
        return false;
    }


    override protected function get ouchSound():FlxSound {
        return _ouchSound;
    }


    override public function get lowAttackSound():FlxSound {
        return _lowAttackSound;
    }
}
}