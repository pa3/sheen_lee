package enemies {
import ai.AIPlayer;

import effects.BigBlood;
import effects.LittleBlood;

import enemies.common.DeathState;
import enemies.common.IdleState;
import enemies.common.OuchState;

import states.PlayState;


public class BodyBuilder extends AIPlayer {

    [Embed(source='../../data/enemies/bbuilder_0.png')]
    private var Img0:Class;
    [Embed(source='../../data/enemies/bbuilder_1.png')]
    private var Img1:Class;
    [Embed(source='../../data/enemies/bbuilder_2.png')]
    private var Img2:Class;


    public static var RUN_SPEED:Array = new Array();
    public static var LOCAL_HIGH_ATTACK_DAMAGE:Array = new Array();
    public static var LOCAL_LOW_ATTACK_DAMAGE:Array = new Array();
    public static var LOCAL_ATTACK_DELAY:Array = new Array();
    public static var LOCAL_BLOCK_CHANCE:Array = new Array()
    public static var HEALTH:Array = new Array()
    public static var SOCRE_FOR_DEATH:Array = new Array()

    private var level:int = 0;

    public function BodyBuilder(X:Number, Y:Number, playSate:PlayState, level:int = 0) {
        super(playSate);

        this.level = level;
        ATTACK_DELAY = LOCAL_ATTACK_DELAY[level];
        HIGH_ATTACK_DAMAGE = LOCAL_HIGH_ATTACK_DAMAGE[level];
        LOW_ATTACK_DAMAGE = LOCAL_LOW_ATTACK_DAMAGE[level];
        BLOCK_CHANCE = LOCAL_BLOCK_CHANCE[level];
        _scoreForDeath = SOCRE_FOR_DEATH[level];
        _fallY = 198;

        this.x = X;
        this.y = Y;
        switch (level) {
            case 0:
                loadGraphic(Img0, true, true, 66, 50);
                break;
            case 1:
                loadGraphic(Img1, true, true, 66, 50);
                break;
            case 2:
                loadGraphic(Img2, true, true, 66, 50);
                break;
        }


        width = 32;
        height = 50;
        offset.x = 18;
        offset.y = 0;
        addAnimation("idle", [0,1], 2, true);
        addAnimation("walk", [0,2,3,4,5,0], 10, true);
        addAnimation("walk_back", [0,5,4,3,2,0], 10, true);
        addAnimation("attack", [9, 10, 11, 10, 9], 10, false);
        addAnimation("attack_low", [6, 7, 6, 8], 10, false);
        addAnimation("ouch", [12], 10, false);
        addAnimation("flight_1", [13], 10, false);
        addAnimation("flight_2", [14], 10, false);
        addAnimation("flight_3", [15], 10, false);
        addAnimation("block", [16], 0.5, false);
        play("idle");
        collideTop = collideBottom = false;
        drag.x = RUN_SPEED[level] * 8;
        maxVelocity.x = RUN_SPEED[level];
        health = 30;
        reset(X, Y);
    }


    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        health = HEALTH[level];
    }
}
}