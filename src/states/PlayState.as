package states {

import ai.AIPlayer;

import effects.BigBlood;
import effects.LittleBlood;

import enemies.BodyBuilder;
import enemies.Boss1;
import enemies.Boss2;
import enemies.Boss3;
import enemies.Boss4;
import enemies.Girl;
import enemies.Mime;
import enemies.Punk;
import enemies.Traitor;

import enemies.mime.MimeBall;

import flash.debugger.enterDebugger;
import flash.display.SWFVersion;
import flash.utils.Timer;

import gui.Bubble;
import gui.HealthBar;
import gui.KeysScreen;
import gui.Panel;

import mochi.as3.MochiEvents;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;

import org.flixel.FlxU;
import org.flixel.data.FlxFade;
import org.flixel.data.FlxQuake;

import sheen.Sheen;

public class PlayState extends FlxState {

    [Embed(source = "../../data/levels/flx_lvl_1.txt", mimeType = "application/octet-stream")]
    public var data_map_1:Class;
    [Embed(source = "../../data/levels/flx_lvl_2.txt", mimeType = "application/octet-stream")]
    public var data_map_2:Class;
    [Embed(source = "../../data/levels/flx_lvl_3.txt", mimeType = "application/octet-stream")]
    public var data_map_3:Class;
    [Embed(source = "../../data/levels/flx_lvl_4.txt", mimeType = "application/octet-stream")]
    public var data_map_4:Class;
    [Embed(source = "../../data/levels/flx_lvl_5.txt", mimeType = "application/octet-stream")]
    public var data_map_5:Class;
    [Embed(source = "../../data/levels/flx_lvl_6.txt", mimeType = "application/octet-stream")]
    public var data_map_6:Class;
    [Embed(source = "../../data/levels/flx_lvl_arena.txt", mimeType = "application/octet-stream")]
    public var data_map_arena:Class;

    [Embed(source = "../../data/levels/flx_lvl_12.png")]
    public var data_tiles_12:Class;
    [Embed(source = "../../data/levels/flx_lvl_34.png")]
    public var data_tiles_34:Class;
    [Embed(source = "../../data/levels/flx_lvl_56.png")]
    public var data_tiles_56:Class;
    [Embed(source = "../../data/levels/flx_lvl_arena.png")]
    public var data_tiles_arena:Class;

    [Embed(source = "../../data/misc/go.png")]
    public var go_icon:Class;

    private var _playerLayer:FlxGroup;
    private var _enemiesLayer:FlxGroup;
    private var _effectsLayer:FlxGroup;

    private var _p:Sheen;
    private var _tileMap:FlxTilemap;

    private var _fireballs:FlxGroup;
    private var _littleBlood:FlxGroup;
    private var _bigBlood:FlxGroup;
    private var  _mimeBalls:FlxGroup;

    private var _enemies:FlxGroup;

    public var _focus:FlxObject;
    private var _focusOnPlayer:Boolean = false;
    private var _focusOnBoss:Boolean = false;


    private var _goSprite:FlxSprite = new FlxSprite(0, 0, go_icon);

    private var _currCheckPoint:CheckPoint = null;

    private var _panel:Panel;

    public var mimesCount:int = 0;

    public var _boss:AIPlayer;

    private var _bubble:Bubble = new Bubble(100, 100, FlxSprite.LEFT);

    private var _chatWithDaBoss:ChatWithDaBoss = null;

    private var _chatFinished:Boolean = false;
    private var _keysScreen:KeysScreen;


    public function PlayState() {
        super();

        //FlxG.showBounds = true;

        _fireballs = new FlxGroup();
        _littleBlood = new FlxGroup();
        _mimeBalls = new FlxGroup();
        _bigBlood = new FlxGroup();
        _enemies = new FlxGroup();

        _playerLayer = new FlxGroup();
        _effectsLayer = new FlxGroup();
        _enemiesLayer = new FlxGroup();

        _p = new Sheen(0, 0, _fireballs, _enemies, _playerLayer, this);
        _playerLayer.add(_p);


        //startWave(_currentLevel, _currentWave);
        //FlxG.follow(_p);
        _focus = new FlxObject();
        _focus.x = 132;

        initLevel();
        //this.add(new SheenDeath(100, 100));


        this.add(_enemiesLayer);
        this.add(_playerLayer);
        this.add(_effectsLayer);

        _effectsLayer.add(_fireballs);
        _effectsLayer.add(_littleBlood);
        _effectsLayer.add(_bigBlood);
        _effectsLayer.add(_mimeBalls);


        for (var i:int = 0; i < 8; i++) {
            _littleBlood.add(new LittleBlood());
            _bigBlood.add(new BigBlood());
            _mimeBalls.add(new MimeBall(0, this));
        }


        _goSprite.x = 200;
        _goSprite.y = 20;
        _goSprite.scrollFactor.x = 0;
        _goSprite.flicker(10);
        _goSprite.exists = false;
        this.add(_goSprite);

        _panel = new Panel(0, 0);
        _panel.scrollFactor.x = 0;
        this.add(_panel);

        _keysScreen = new KeysScreen();
        _keysScreen.visible = false;
        this.add(_keysScreen);

        //this.add(new StarsManager(_panel.starsChanged));


        //_enemies.add(new Mime(270, 150, this));

    }

    override public function update():void {

        if (FlxG.keys.TAB) {
            if (!_keysScreen.visible) {
                _keysScreen.visible = true;
            }
            return;
        } else if (_keysScreen.visible) {
            _keysScreen.visible = false;
        }


        super.update();

        if (_chatWithDaBoss != null && !_chatFinished) {

            if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("SPACE")) {
                if (!_chatWithDaBoss.next()) {
                    _bubble.dead = true;
                    _bubble.exists = false;
                    _chatFinished = true;
                    FlxG.chatWithTheBoss = false;
                }
            }
            if (!_chatFinished)
                return;
        }

        if (FlxG.keys.justPressed("N")) {
            FlxG.level++;
            MochiEvents.endPlay();
            if (FlxG.level > 6) {
                FlxG.state = new GamePassedState();
            } else {
                FlxG.state = new InterLevelState();
            }
            return;
        }

//        if (FlxG.keys.justPressed("M")) {
//            if (_currCheckPoint.next == null  && !_currCheckPoint.bossPoint) {
//                _currCheckPoint = _currCheckPoint.next;
//            } else {
//                if (!_goSprite.exists) {
//                    _goSprite.reset(200, 20);
//                    _goSprite.flicker(2);
//                }
//                if (_focus.x < _p.x - 20) {
//                    _focusOnPlayer = true;
//                }
//                if (_p.x > _currCheckPoint.x + 20 && !_currCheckPoint.bossPoint) {
//                    _currCheckPoint = _currCheckPoint.next;
//                }
//            }
//        }

        if (FlxG.keys.justPressed("D")) {
            _p.hurt_me(_p.facing, 20);
            return;
        }

        

        if (!_goSprite.flickering()) {
            _goSprite.exists = false;
        }

        _panel.playerHealth = _p.health;

        addEnemies();


        var playerMinX:int = _focus.x - 132;
        var playerMaxX:int = _focus.x + 132;

        if (_p.x < playerMinX) {
            _p.x = playerMinX;
        }
        if (_p.x + _p.width > playerMaxX) {
            _p.x = playerMaxX - _p.width;
        }

        if (_p.x < playerMinX) {
            _p.x = playerMinX;
        }
        if (_p.x + _p.width > playerMaxX) {
            _p.x = playerMaxX - _p.width;
        }


        if (_focusOnPlayer) {
            if (_focus.x < _p.x - 20) {
                _focus.acceleration.x = 200;
                _focus.update();
            } else {
                _goSprite.exists = false;
                _focus.velocity.x = 0;
                _focus.acceleration.x = 0;
                _focusOnPlayer = false;
            }
        } else if (_focusOnBoss) {

            if (_focus.x > _currCheckPoint.x) {
                _focus.x = _currCheckPoint.x;
            }
            if (_boss != null && _boss.dead) {
                FlxG.level++;
                MochiEvents.endPlay();
                if (FlxG.level > 6) {
                    FlxG.state = new GamePassedState();
                } else {
                    FlxG.state = new InterLevelState();
                }
                return;
            }

            if (_focus.x < _currCheckPoint.x) {
                _focus.acceleration.x = 200;
                _focus.update();
            } else {
                //_goSprite.exists = false;
                _focus.x = _currCheckPoint.x;
                _focus.velocity.x = 0;
                _focus.acceleration.x = 0;
                _focusOnPlayer = false;
                if (_chatWithDaBoss == null) {
                    _chatWithDaBoss = new ChatWithDaBoss(FlxG.level, _p, _boss, _bubble);
                    _chatWithDaBoss.next();
                    this.add(_bubble);
                }
            }
        }
        else {


            if (_focus.x < _p.x - 20) {
                _focus.x = _p.x - 20;
            }

            if (_currCheckPoint != null && _currCheckPoint.bossPoint && _p.x > _currCheckPoint.x-132){//_tileMap.width - 256) {
                _focusOnBoss = true;
                _focusOnPlayer = false;

                _boss = new (_currCheckPoint.enemiesTypes[0] as SpawnInfo).enemy(_currCheckPoint.x + 80, 150, this);
                _enemies.add(_boss);
                _p.acceleration.x = _p.velocity.x = 0;
                FlxG.chatWithTheBoss = true;
            } else {
                if (_currCheckPoint != null) {
                    if (_focus.x > _currCheckPoint.x) {
                        _focus.x = _currCheckPoint.x;
                    }
                    if (_currCheckPoint.enemiesToKill <= 0) {
                        if (_currCheckPoint.next == null  && !_currCheckPoint.bossPoint) {
                            _currCheckPoint = _currCheckPoint.next;
                        } else {
                            if (!_goSprite.exists) {
                                _goSprite.reset(200, 20);
                                _goSprite.flicker(2);
                            }
                            if (_focus.x < _p.x - 20) {
                                _focusOnPlayer = true;
                            }
                            if (_p.x > _currCheckPoint.x + 20 && !_currCheckPoint.bossPoint) {
                                _currCheckPoint = _currCheckPoint.next;
                            }
                        }
                    }

                } else {
                    if (_focus.x > _tileMap.width - 132) {
                        _focus.x = _tileMap.width - 132;
                    }

                    if (_enemies.countLiving() <= 0) {
                        FlxG.level++;
                        MochiEvents.endPlay();
                        if (FlxG.level > 6) {
                            FlxG.state = new GamePassedState();
                        } else {
                            FlxG.state = new InterLevelState();
                        }
                        return;
                    }

                }


            }
        }

        FlxG.follow(_focus);
        FlxG.followBounds(0, 0, _tileMap.width - 1, 176 - 1);


        if (FlxG.keys.justPressed("B")) {
             FlxG.showBounds= !FlxG.showBounds;
        }


    }

    private function addEnemies():void {

        var enemiesOnDaLeft:int = 0;
        var enemiesOnDaRight:int = 0;

        var mimesOnDaLeft:int = 0;
        var mimesOnDaRight:int = 0;

        for each (var enemy:FlxSprite in _enemies.members) {
            if (!enemy.dead) {
                if (enemy.x > _p.x) {
                    enemiesOnDaRight++;
                    if (enemy is Mime) mimesOnDaRight++;
                } else {
                    enemiesOnDaLeft++;
                    if (enemy is Mime) mimesOnDaLeft++;
                }
            }
        }

        if (_currCheckPoint == null || _currCheckPoint.bossPoint)
            return;


        if (enemiesOnDaLeft + enemiesOnDaRight >= _currCheckPoint.enemiesOnScreen) {
            return;
        }


        var spawnedEnemy:AIPlayer = spawnEnemy(_currCheckPoint);
        if (spawnedEnemy != null) {
            if (spawnedEnemy is Mime) {
                spawnedEnemy.x = _focus.x + 150 * ( (mimesOnDaLeft >= mimesOnDaRight) ? 1 : -1);
            } else {
                spawnedEnemy.x = _focus.x + 150 * ( (enemiesOnDaLeft >= enemiesOnDaRight) ? 1 : -1);
            }
            spawnedEnemy.y = 150;
            _enemies.add(spawnedEnemy);
        }


    }

    private function initLevel():void {

        MochiEvents.startPlay("Level_" + FlxG.level);

        FlxG.chatWithTheBoss = false;
        mimesCount = 0;

        _enemies.destroy();
        _enemiesLayer.destroy();
        _enemiesLayer.add(_enemies);

        _currCheckPoint = FlxG.levels[FlxG.level-1].checkPoints;
        var newTileMap:FlxTilemap = (FlxG.levels[FlxG.level-1] as LevelInfo).tileMap;

        newTileMap.follow();
        if (this.defaultGroup.members.indexOf(_tileMap) == -1) {
            this.add(newTileMap);
        } else {
            this.defaultGroup.replace(_tileMap, newTileMap);
        }
        _tileMap = newTileMap;
        _p.x = 10;
        _p.y = 172 - _p.height;
        _focus.x = 132;
    }


    public function get player():Sheen {
        return _p;
    }

    public function get deathLayer():FlxGroup {
        return _enemiesLayer;
    }


    public function enemyDeathCallback(enemy:AIPlayer):void {
        if (enemy is Boss1 || enemy is Boss2 || enemy is Boss3) {
            FlxG.timeScale = 0.3;
        }
        FlxG.score += enemy.scoreForDeath;
        //_enemies.remove(enemy, true);
        if (_currCheckPoint != null) {
            _currCheckPoint.enemiesToKill--;

        }
    }

    public function get enemies():FlxGroup {
        return _enemies;
    }

    public function get littleBlood():LittleBlood {
        var blood:LittleBlood = _littleBlood.getFirstDead() as LittleBlood;
        if (blood == null) {
            blood = new LittleBlood();
            _littleBlood.add(blood);
        }
        return blood;
    }

    public function get bigBlood():BigBlood {
        var blood:BigBlood = _bigBlood.getFirstDead() as BigBlood;
        if (blood == null) {
            blood = new BigBlood();
            _bigBlood.add(blood);
        }
        return blood;
    }

    public function get mimeBall():MimeBall {
        var ball:MimeBall = _mimeBalls.getFirstDead() as MimeBall;
        if (ball == null) {
            ball = new MimeBall(0, this);
            _mimeBalls.add(ball);
        }
        return ball;
    }



    public function getPlayerMinX():Number {
        return _focus.x - 132;
    }

    public function getPlayerMaxX():Number {
        return _focus.x + 132;
    }



    private function spawnEnemy(checkPoint:CheckPoint):AIPlayer {
        
        var diceRollResult:Number = Math.random();
        var result:AIPlayer;
        
        var mimesOnScreen:int = 0;

        for each (var e:AIPlayer in _enemies.members) {
            if (e is Mime && !e.dead) {
                mimesOnScreen++;
            }
        }
        
        for each(var spawnInfo:SpawnInfo in checkPoint.enemiesTypes) {
            if (spawnInfo.enemy == Mime && mimesOnScreen >= 2) {
                continue;
            }
            if (diceRollResult <= spawnInfo.chance) {
                return new spawnInfo.enemy(0,0,this, spawnInfo.level);
            }
        }
        return null;
    }

}
}

