package ai {
import effects.BigBlood;
import effects.LittleBlood;

import enemies.common.BlockState;
import enemies.common.DeathState;
import enemies.common.IdleState;
import enemies.common.KnockOutState;
import enemies.common.OuchState;

import org.flixel.FlxG;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

import states.PlayState;

public class AIPlayer extends FlxSprite {
    protected var _fsm:FiniteStateMachine;

    public var ATTACK_DELAY:Number = 0.0;

    public var HIGH_ATTACK_DAMAGE:Number = 0.0;
    public var LOW_ATTACK_DAMAGE:Number = 0.0;
    public var SUPER_ATTACK_DAMAGE:Number = 0.0;

    public var BLOCK_CHANCE:Number = 0.0;

    public var dying:Boolean = false;

    public var _attackTimer:Number = 0.0;
    private var _playState:PlayState;


    protected var _scoreForDeath:int = 0;
    protected var _fallY:int = 0;
    protected var _damageForSimpleAttack:Number;
    protected var _damageForSuper:Number;


    private var _hurtingPlayer:Boolean;
    public var blocking:Boolean = false;

    public function AIPlayer(playState:PlayState) {
        _playState = playState;
        _fsm = FiniteStateMachine.newInstance();
    }

    public function get fsm():FiniteStateMachine {
        return _fsm;
    }

    public override function update():void {
        _attackTimer += FlxG.elapsed;
        _fsm.update();

        if ((_curAnim.name == "attack" || _curAnim.name == "attack_low") && _curFrame == 3) {
            if (!_hurtingPlayer && (playState.player.y + playState.player.height) > 142) {
                _hurtingPlayer = true;

                var damage:Number = 0;
                switch (_curAnim.name) {
                    case  "attack":
                        damage = HIGH_ATTACK_DAMAGE;
                        if (playState.player.isSitting) {
                            damage = 0.0;
                        }
                        break;
                    case  "attack_low":
                        damage = LOW_ATTACK_DAMAGE;
                        break;
                    case  "attack_super":
                        damage = SUPER_ATTACK_DAMAGE;
                        break;
                }
                if (damage > 0)
                    playState.player.hurt_me((x > playState.player.x) ? RIGHT : LEFT, damage);


            }
        } else {
            _hurtingPlayer = false;
        }

        super.update();

    }


    public function justHurt(Damage:Number, unblockable:Boolean) {
        if (ouchSound) ouchSound.play();
        if (blocking && !unblockable) {
            velocity.x = (facing == LEFT) ? 100 : -100;
            return;
        }

        fsm.changeState(OuchState.newInstance(this));

        if (Damage > 0 && health > 0) {
            var b:LittleBlood = playState.littleBlood;
            if (b != null) {
                b.bang(x + (1 - facing) * (width / 2), y - 5, facing);
            }
        }
        velocity.x = (facing == LEFT) ? 100 : -100;

        hurt(Damage);
    }

    protected function get ouchSound():FlxSound {
        return null;
    }
    public function get highAttackSound():FlxSound {
        return null;
    }
    public function get lowAttackSound():FlxSound {
        return null;
    }


    override public function reset(X:Number, Y:Number):void {
        super.reset(X, Y);
        fsm.changeState(new IdleState(this));
        _hurtingPlayer = false;
        if (y + height > 172) {
            y = 172 - height;
        }
        health = 10;
        _attackTimer = 0.0;
        dying = false;

        play("idle");
    }

    override public function kill():void {
        playState.enemyDeathCallback(this);

        var b:BigBlood = playState.bigBlood;
        if (b != null) {
            b.bang(x + (1 - facing) * 20 - 10, y - 13, facing);
        }
        fsm.changeState(DeathState.newInstance(this));

    }

    public function get playState():PlayState {
        return _playState;
    }

    public function get scoreForDeath():int {
        return _scoreForDeath;
    }

    public function get fallY():int {
        return _fallY;
    }

    public function haveLowAttack():Boolean {
        return true;
    }

    public function haveHighAttack():Boolean {
        return true;
    }


    public function knockOut(damage:Number, ublockable:Boolean):void {
        if (blocking && !ublockable) {
            velocity.x = (facing == LEFT) ? 100 : -100;
            return;
        }
        this.hurt(damage);
        fsm.changeState(KnockOutState.newInstance(this));
    }

    public function iGonaKickYourAss():void {
        if (Math.random() < BLOCK_CHANCE) {
            fsm.changeState(BlockState.newInstance(this));
        }
    }
}
}