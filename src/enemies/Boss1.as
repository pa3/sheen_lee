package enemies {
import ai.AIPlayer;

import effects.BigBlood;
import effects.LittleBlood;

import enemies.common.DeathState;
import enemies.common.IdleState;
import enemies.common.OuchState;

import org.flixel.FlxG;

import states.PlayState;

public class Boss1 extends AIPlayer {
    [Embed(source='../../data/enemies/boss1.png')]
    private var Img:Class;

    public static var RUN_SPEED:int = 60;
    public static var LOCAL_ATTACK_DELAY:Number = 2.0;
    public static var HEALTH:Number = 10;
    public static var LOCAL_HIGH_ATTACK_DAMAGE:Number = 0.0;
    public static var LOCAL_LOW_ATTACK_DAMAGE:Number = 0.0;
    public static var SOCRE_FOR_DEATH:Number = 0;
    public static var LOCAL_BLOCK_CHANCE:Number = 0.0;

    public function Boss1(X:Number, Y:Number, playState:PlayState, level:int = 0) {
        super(playState);

        ATTACK_DELAY = LOCAL_ATTACK_DELAY;
        HIGH_ATTACK_DAMAGE = LOCAL_HIGH_ATTACK_DAMAGE;
        LOW_ATTACK_DAMAGE = LOCAL_LOW_ATTACK_DAMAGE;
        BLOCK_CHANCE = LOCAL_BLOCK_CHANCE;

        _scoreForDeath = SOCRE_FOR_DEATH;
        _fallY = 186;
        
        this.x = X;
        this.y = Y;
        //if (Math.random() > 0.5) {
            //_skin = 1;
            loadGraphic(Img, true, true, 86, 56);
        //} else {
            //_skin = 2;
            //loadGraphic(Img2, true, true, 69, 50);
        //}
        width = 32;
        height = 56;
        offset.x = 24;
        offset.y = 0;
        addAnimation("idle", [0,1], 2, true);
        addAnimation("walk", [0,2,3,4,5,0], 10, true);
        addAnimation("walk_back", [0,5,4,3,2,0], 10, true);
        addAnimation("attack", [7, 8, 10, 10, 8, 7], 10, false);
        addAnimation("attack_low", [7, 8, 9, 9, 8, 7], 10, false);
        addAnimation("ouch", [6], 10, false);
        addAnimation("block", [14], 0.5, false);
        addAnimation("flight_1", [11], 10, false);
        addAnimation("flight_2", [12], 10, false);
        addAnimation("flight_3", [13], 10, false);
        play("idle");
        drag.x = RUN_SPEED * 8;
        maxVelocity.x = RUN_SPEED;
        health = 30;
        reset(X,Y);
    }

    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        health = HEALTH;
    }    
}
}