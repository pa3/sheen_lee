package enemies {
import ai.AIPlayer;

import avmplus.metadataXml;

import effects.BigBlood;
import effects.LittleBlood;

import enemies.common.DeathState;
import enemies.common.IdleState;
import enemies.common.OuchState;

import enemies.customstate.Boss3DeathState;
import enemies.customstate.Boss3KnockOutState;

import org.flixel.FlxG;

import states.PlayState;

public class Boss3 extends AIPlayer {
    [Embed(source='../../data/enemies/boss3.png')]
    private var Img:Class;

    //private var _skin:uint = 1;

    public static var RUN_SPEED:int = 50;
    public static var LOCAL_ATTACK_DELAY:Number = 2.0;
    public static var HEALTH:Number = 10;
    public static var LOCAL_HIGH_ATTACK_DAMAGE:Number = 0.0;
    public static var LOCAL_LOW_ATTACK_DAMAGE:Number = 0.0;
    public static var SOCRE_FOR_DEATH:Number = 0;
    public static var LOCAL_BLOCK_CHANCE:Number = 0.0;
    
    public function Boss3(X:Number, Y:Number, playState:PlayState, level:int = 0) {
        super(playState);

        ATTACK_DELAY = LOCAL_ATTACK_DELAY;
        HIGH_ATTACK_DAMAGE = LOCAL_HIGH_ATTACK_DAMAGE;
        LOW_ATTACK_DAMAGE = LOCAL_LOW_ATTACK_DAMAGE;
        BLOCK_CHANCE = LOCAL_BLOCK_CHANCE;

        _scoreForDeath = SOCRE_FOR_DEATH;
        _fallY = 180;

        this.x = X;
        this.y = Y;
        //if (Math.random() > 0.5) {
            //_skin = 1;
            loadGraphic(Img, true, true, 80, 53);
        //} else {
            //_skin = 2;
            //loadGraphic(Img2, true, true, 69, 50);
        //}
        width = 32;
        height = 53;
        offset.x = 18;
        offset.y = 0;
        addAnimation("idle", [0,1], 2, true);
        addAnimation("walk", [0,2,3,4,5,6,0], 10, true);
        addAnimation("walk_back", [0,6,5,4,3,2,0], 10, true);
        addAnimation("attack", [9, 10, 11, 9], 10, false);
        addAnimation("attack_low", [12, 13, 13, 12, 12], 10, false);
        addAnimation("attack_super", [14, 15, 16,17,18], 10, false);
        addAnimation("ouch", [8], 10, false);
        addAnimation("block", [7], 0.5, false);
        addAnimation("flight_1", [19], 10, false);
        addAnimation("flight_2", [20], 10, false);
        addAnimation("flight_3", [21], 10, false);
        addAnimation("flight_4", [22], 10, false);
        play("idle");
        drag.x = RUN_SPEED * 8;
        maxVelocity.x = RUN_SPEED;
        health = 30;
        reset(X,Y);
    }

    override public function kill():void {
        playState.enemyDeathCallback(this);

        var b:BigBlood = playState.bigBlood;
        if (b != null) {
            b.bang(x + (1 - facing) * 20 - 10, y - 13, facing);
        }
        fsm.changeState(Boss3DeathState.newInstance(this));
    }


    override public function knockOut(damage:Number, ublockable:Boolean):void {
        if (blocking && !ublockable) {
            velocity.x = (facing == LEFT) ? 100 : -100;
            return;
        }
        this.hurt(damage);
        if (this.health > 0) {
            fsm.changeState(Boss3KnockOutState.newInstance(this));
        }
    }

    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        health = HEALTH;
    }
}
}