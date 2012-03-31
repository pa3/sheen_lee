package enemies {
import enemies.mime.*;

import ai.AIPlayer;

import enemies.mime.states.IdleState;

import org.flixel.FlxU;

import states.PlayState;

public class Mime extends AIPlayer {
    [Embed(source='../../data/enemies/mime_0.png')]
    private var Img0:Class;
    [Embed(source='../../data/enemies/mime_1.png')]
    private var Img1:Class;
    [Embed(source='../../data/enemies/mime_2.png')]
    private var Img2:Class;

    //private var _skin:uint = 1;

    public static var RUN_SPEED:Array = new Array();
    public static const ATACK_DELAY:Array = new Array();
    public static var HEALTH:Array = new Array();
    public static var LAUNCH_DELAY:Array = new Array();
    public static var BALL_DAMAGE:Array = new Array();
    public static var BALL_ACCELERATION:Array = new Array();
    public static var SOCRE_FOR_DEATH:Array = new Array();

    private var _death:MimeDeath;

    public var level:int = 0;

    public function Mime(X:Number, Y:Number, playSate:PlayState, level:int = 0) {
        super(playSate);

        _scoreForDeath = SOCRE_FOR_DEATH[level];

        this.level = level;

        playSate.mimesCount++;
        this.x = X;
        this.y = Y;
        switch (level) {
            case 0:
                loadGraphic(Img0, true, true, 31, 54);
                break;
            case 1:
                loadGraphic(Img1, true, true, 31, 54);
                break;
            case 2:
                loadGraphic(Img2, true, true, 31, 54);
                break;
        }
        width = 31;
        height = 54;
        offset.x = 0;
        offset.y = 0;
        addAnimation("idle", [0,1,2], 10, true);
        addAnimation("walk", [3,4,5,6,7,0,0], 10, true);
        play("idle");
        drag.x = RUN_SPEED[level] * 8;
        maxVelocity.x = RUN_SPEED[level];

        _death = new MimeDeath(level);
        playState.deathLayer.add(_death);

        reset(X, Y);
    }

    override public function update():void {

        if (y + height > 172) {
            y = 172 - height;
        }

        super.update();
    }

    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        fsm.changeState(new IdleState(this));
        health = HEALTH[level];

        //_hurtingPlayer = false;

        /*
         health = 100;
         play("idle");*/
    }

    override public function kill():void {
        super.kill();
        playState.enemyDeathCallback(this);
        dying = true;

        playState.mimesCount--;
        //if (_goingToAttackPlayer) {
        //    _player.attackersCount--;
        //}
        //var b:BigBlood = _playState.bigBlood;
        //if (b != null) {
        //    b.bang(x + (1 - facing) * 20 - 10, y - 33, facing);
        //}
        //fsm.changeState(DeathState.newInstance(this));
        _death.die(facing, x, y - 20);
    }


    override public function knockOut(damage:Number, unblockable:Boolean):void {
        super.kill();
        playState.enemyDeathCallback(this);
        dying = true;

        playState.mimesCount--;
        //if (_goingToAttackPlayer) {
        //    _player.attackersCount--;
        //}
        //var b:BigBlood = _playState.bigBlood;
        //if (b != null) {
        //    b.bang(x + (1 - facing) * 20 - 10, y - 33, facing);
        //}
        //fsm.changeState(DeathState.newInstance(this));
        _death.die(facing, x, y - 20);
    }

    public function launchBall():void {
        var ball:MimeBall = playState.mimeBall;
        ball.facing = this.facing;
        ball.resetMe(x, y + 10, level);
        ball.activate();
        ball.velocity.x = this.facing == LEFT ? -80 : 80;
    }
}
}
