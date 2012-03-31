package states {
import enemies.BodyBuilder;
import enemies.Boss1;
import enemies.Boss2;
import enemies.Boss3;
import enemies.Boss4;
import enemies.Girl;
import enemies.Punk;
import enemies.Traitor;
import enemies.Mime;

import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import flash.text.engine.ElementFormat;
import flash.ui.Mouse;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;

import gui.KeysScreen;


import mochi.as2.MochiServices;
import mochi.as3.MochiEvents;

import mochi.as3.MochiServices;

import org.flixel.FlxBitmapFont;

import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;

import org.flixel.FlxTilemap;

import sheen.Sheen;

import sheen.attacks.BicycleAttack;
import sheen.attacks.Combo1Attack;
import sheen.attacks.Combo2Attack;
import sheen.attacks.Combo3Attack;
import sheen.attacks.Combo4Attack;
import sheen.attacks.FireKick;
import sheen.attacks.FlightKickAttack;
import sheen.attacks.PunchAttack;

import states.PlayState;

public class TitleState extends FlxState {


    [Embed(source = "../../data/misc/menu_back.png")]
    public var back_image:Class;

    [Embed(source = "../../data/misc/menu_dragon_2.png")]
    public var sheen_image:Class;

    [Embed(source = "../../data/misc/menu_title_2.png")]
    public var title_image:Class;


    [Embed(source = "../../data/settings.xml", mimeType = "application/octet-stream")]
    public var settings_local_xml:Class;



    [Embed(source = "../../data/levels/flx_lvl_12.png")]
    public var data_tiles_12:Class;
    [Embed(source = "../../data/levels/flx_lvl_34.png")]
    public var data_tiles_34:Class;
    [Embed(source = "../../data/levels/flx_lvl_56.png")]
    public var data_tiles_56:Class;
    [Embed(source = "../../data/levels/flx_lvl_arena.png")]
    public var data_tiles_arena:Class;

    [Embed(source="../../data/sfx/music.mp3")]
    public var theme:Class;


    [Embed(source = "../../data/misc/font.png")]
    public var font_image:Class;

    private var _text:FlxBitmapFont;



    private var _settingsParsed:Boolean = false;
    private var _allLevelsLoaded:Boolean = false;

    private var _curLoadedLevel:int = 0;
    private var _tileMaps:Array;

    private var back:FlxSprite = new FlxSprite(0, 0, back_image);
    private var _sheen:FlxSprite = new FlxSprite(0, 0, sheen_image);
    private var title:FlxSprite = new FlxSprite(0, 0, title_image);


    public function TitleState() {
        super();
        this.add(back);
        _sheen.y = 176;
        _sheen.velocity.y = -200;
        _sheen.acceleration.y = -100;
        this.add(_sheen);
        this.add(title);
        FlxG.playMusic(theme);
        loadSeetingFromLocalXML();

        MochiEvents.startPlay("TitleState");
        FlxG.log("hello");

        _text = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        _text.multiLine = true;
        _text.width = _text.height = 10;
        _text.text = "PRESS <Z>\nTO START...";
        add(_text);
        _text.x = FlxG.width - _text.width - 10;
        _text.y = FlxG.height - _text.height - 10;
        _text.flicker(1000000, 0.2);


    }

    private function loadSeetingFromLocalXML():void {
        var file:ByteArray = new settings_local_xml;
        var str:String = file.readUTFBytes( file.length );
        var settings:XML = new XML( str );
        configureNPCs(settings);
        configureLevelsLocaly(settings);
        _settingsParsed = true;

    }

//    private function onLevelAssetsLoaded(e:Event):void {
//        ExternalImage.setData(e.target.content.bitmapData, e.target.url);
//        var tileMap:FlxTilemap = new FlxTilemap();
//        tileMap.drawIndex = 0;
//        tileMap.loadMap(_tileMaps[_curLoadedLevel].source, ExternalImage, 22,22);
//        _tileMaps[_curLoadedLevel].tileMap = tileMap;
//        _curLoadedLevel++;
//        if (_curLoadedLevel < _tileMaps.length) {
//            var imgLoader:Loader = new Loader();
//            imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLevelAssetsLoaded);
//            imgLoader.load(new URLRequest(_tileMaps[_curLoadedLevel].filename));
//        } else {
//            for (var i:int = 0; i < _tileMaps.length; i++) {
//                (FlxG.levels[i] as LevelInfo).tileMap = _tileMaps[i].tileMap;
//
//                var curCheckPoint:CheckPoint = (FlxG.levels[i] as LevelInfo).checkPoints;
//                var j:int = 0;
//                while (curCheckPoint != null) {
//                    if (j == 0) {
//                        curCheckPoint.x = 132;
//                    } else if (j == ((FlxG.levels[i] as LevelInfo).amountOfCheckPoints-1)){
//                        curCheckPoint.x = _tileMaps[i].tileMap.width-132;
//                    } else {
//                        var step:Number = 0;
//                        if ((FlxG.levels[i] as LevelInfo).amountOfCheckPoints > 1) {
//                            step = _tileMaps[i].tileMap.width / ((FlxG.levels[i] as LevelInfo).amountOfCheckPoints - 1);
//                        }
//                        curCheckPoint.x = step*j;
//                    }
//                    j++;
//                    curCheckPoint = curCheckPoint.next;
//                }
//            }
//
//            _allLevelsLoaded = true;
//        }
//    }

    override public function update():void {

        super.update();

        if (_sheen.y < 0) {
            _sheen.velocity.y = _sheen.acceleration.y = 0;
            _sheen.y = -10;
        }

        if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C") || FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("ESCAPE")) {
            if (_settingsParsed && _allLevelsLoaded) {
                MochiEvents.endPlay();                
                FlxG.state = new MainMenuState();
            }
        }
    }

//    private function onXMLLoaded(e:Event):void {
//        XML.ignoreWhitespace = true;
//        var settings:XML = new XML(e.target.data);
//        configureNPCs(settings);
//        configureLevels(settings);
//
//        _settingsParsed = true;
//
//    }

    private function configureLevelsLocaly(settings:XML):void {
        _tileMaps = new Array();

        for (var i:int = 0; i < settings.levels.level.length(); i++) {
            FlxG.levels[i] = new LevelInfo();
            (FlxG.levels[i] as LevelInfo).checkPoints = configureLevel(settings.levels.level[i], settings);
            (FlxG.levels[i] as LevelInfo).amountOfCheckPoints = settings.levels.level[i].checkpoint.length();
            _tileMaps[i] = {source:settings.levels.level[i].source, filename:settings.levels.level[i].tiles_image};
        }
        _curLoadedLevel = 0;

        for (var i:int = 0; i < _tileMaps.length; i++) {

            var tileMap:FlxTilemap = new FlxTilemap();
            tileMap.drawIndex = 0;
            tileMap.loadMap(_tileMaps[_curLoadedLevel].source, getLocalImageClassByLevelNum(i), 22,22);
            _tileMaps[_curLoadedLevel].tileMap = tileMap;
            _curLoadedLevel++;


            (FlxG.levels[i] as LevelInfo).tileMap = _tileMaps[i].tileMap;

            var curCheckPoint:CheckPoint = (FlxG.levels[i] as LevelInfo).checkPoints;
            var j:int = 0;
            while (curCheckPoint != null) {
                if (j == 0) {
                    curCheckPoint.x = 132;
                } else if (j == ((FlxG.levels[i] as LevelInfo).amountOfCheckPoints-1)){
                    curCheckPoint.x = _tileMaps[i].tileMap.width-132;
                } else {
                    var step:Number = 0;
                    if ((FlxG.levels[i] as LevelInfo).amountOfCheckPoints > 1) {
                        step = _tileMaps[i].tileMap.width / ((FlxG.levels[i] as LevelInfo).amountOfCheckPoints - 1);
                    }
                    curCheckPoint.x = step*j;
                }
                j++;
                curCheckPoint = curCheckPoint.next;
            }
        }

        _allLevelsLoaded = true;
    }

    private function getLocalImageClassByLevelNum(i:int):Class {
        switch (i) {
            case 0:
            case 1:
                return data_tiles_12;
            case 2:
            case 3:
                return data_tiles_34;
            case 4:
            case 5:
                return data_tiles_56;
            case 6:
                return data_tiles_arena;
        }
        return null;
    }

//    private function configureLevels(settings:XML):void {
//        _tileMaps = new Array();
//
//        for (var i:int = 0; i < settings.levels.level.length(); i++) {
//            FlxG.levels[i] = new LevelInfo();
//            (FlxG.levels[i] as LevelInfo).checkPoints = configureLevel(settings.levels.level[i], settings);
//            (FlxG.levels[i] as LevelInfo).amountOfCheckPoints = settings.levels.level[i].checkpoint.length();
//            _tileMaps[i] = {source:settings.levels.level[i].source, filename:settings.levels.level[i].tiles_image};
//        }
//        _curLoadedLevel = 0;
//
//
//        var imgLoader:Loader = new Loader();
//        imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLevelAssetsLoaded);
//        imgLoader.load(new URLRequest(_tileMaps[_curLoadedLevel].filename));
//
//    }

    private function configureLevel(level:XML, settings:XML):CheckPoint {
        var checkPointsXML:XMLList = level.checkpoint;

        var prevCheckPoint:CheckPoint = null;
        var firstCheckPoint:CheckPoint = null;
        for (var i:int = 0; i < checkPointsXML.length(); i++) {
            var checkPoint:CheckPoint = new CheckPoint();
            if (prevCheckPoint != null) {
                prevCheckPoint.next = checkPoint;

            }
            prevCheckPoint = checkPoint;

            if (i == 0)
                firstCheckPoint = checkPoint;

            checkPoint.x = 132 + 256 * i;
            checkPoint.enemiesTypes = new Array();
            if (checkPointsXML[i].boss != undefined) {
                checkPoint.bossPoint = checkPointsXML[i].boss;
                checkPoint.enemiesTypes.push(new SpawnInfo(1, getDefinitionByName("enemies." + checkPointsXML[i].boss) as Class, 1));

                continue;
            }

            checkPoint.enemiesToKill = checkPointsXML[i].kill_to_pass;
            checkPoint.enemiesOnScreen = checkPointsXML[i].enemies_on_screen;

            var enemiesSettings:XMLList = checkPointsXML[i].spawn_settings.enemy;
            var chance:Number = 0;
            for (var j:int = 0; j < enemiesSettings.length(); j++) {
                if (j == enemiesSettings.length() - 1) {
                    chance = 1;
                } else {
                    var c:Number = enemiesSettings[j].spawn_chance;
                    chance += c ;
                }
                checkPoint.enemiesTypes.push(new SpawnInfo(chance, getDefinitionByName("enemies." + enemiesSettings[j].type) as Class, enemiesSettings[j].level));
            }
        }

        return firstCheckPoint;
    }

    private function configureNPCs(settings:XML):void {

        Sheen.PLAYER_RUN_SPEED = settings.sheen.move.run_speed;
        Sheen.JUMP_ACCELERATION = settings.sheen.move.jump_acceleration;
        Sheen.HITPOINTS_TO_KNOCK_OUT = settings.sheen.move.hitpoints_to_knock_out;

        Sheen.HEALTH = settings.sheen.general.health;
        Sheen.ENERGY = settings.sheen.general.energy;
        Sheen.ENERGY_REGENERATE_FACTOR = settings.sheen.general.energy_regenerate_factor;



        PunchAttack.COST = settings.sheen.attack.basic.cost;
        PunchAttack.KEYS = settings.sheen.attack.basic.button;
        PunchAttack.DAMAGE = settings.sheen.attack.basic.damage;
        PunchAttack.DELAY = settings.sheen.attack.basic.delay;
        PunchAttack.KNOCK_OUT = settings.sheen.attack.basic.ko.toLowerCase() == "true" ? true : false;
        PunchAttack.UNBLOCKABLE = settings.sheen.attack.basic.unblockable.toLowerCase() == "true" ? true : false;

        BicycleAttack.COST = settings.sheen.attack.bicycle_kick.cost;
        BicycleAttack.KEYS = settings.sheen.attack.bicycle_kick.button;
        BicycleAttack.DAMAGE = settings.sheen.attack.bicycle_kick.damage;
        BicycleAttack.DELAY = settings.sheen.attack.bicycle_kick.delay;
        BicycleAttack.KNOCK_OUT = settings.sheen.attack.bicycle_kick.ko.toLowerCase() == "true" ? true : false;
        BicycleAttack.UNBLOCKABLE = settings.sheen.attack.bicycle_kick.unblockable.toLowerCase() == "true" ? true : false;

        
        Combo1Attack.COST = settings.sheen.attack.combo1.cost;
        Combo1Attack.KEYS = settings.sheen.attack.combo1.button;
        Combo1Attack.DAMAGE = settings.sheen.attack.combo1.damage;
        Combo1Attack.DELAY = settings.sheen.attack.combo1.delay;
        Combo1Attack.KNOCK_OUT = settings.sheen.attack.combo1.ko.toLowerCase() == "true" ? true : false;
        Combo1Attack.UNBLOCKABLE = settings.sheen.attack.combo1.unblockable.toLowerCase() == "true" ? true : false;
        
        Combo2Attack.COST = settings.sheen.attack.combo2.cost;
        Combo2Attack.KEYS = settings.sheen.attack.combo2.button;
        Combo2Attack.DAMAGE = settings.sheen.attack.combo2.damage;
        Combo2Attack.DELAY = settings.sheen.attack.combo2.delay;
        Combo2Attack.KNOCK_OUT = settings.sheen.attack.combo2.ko.toLowerCase() == "true" ? true : false;
        Combo2Attack.UNBLOCKABLE = settings.sheen.attack.combo2.unblockable.toLowerCase() == "true" ? true : false;
        
        Combo3Attack.COST = settings.sheen.attack.combo3.cost;
        Combo3Attack.KEYS = settings.sheen.attack.combo3.button;
        Combo3Attack.DAMAGE = settings.sheen.attack.combo3.damage;
        Combo3Attack.DELAY = settings.sheen.attack.combo3.delay;
        Combo3Attack.KNOCK_OUT = settings.sheen.attack.combo3.ko.toLowerCase() == "true" ? true : false;
        Combo3Attack.UNBLOCKABLE = settings.sheen.attack.combo3.unblockable.toLowerCase() == "true" ? true : false;
        
        Combo4Attack.COST = settings.sheen.attack.combo4.cost;
        Combo4Attack.KEYS = settings.sheen.attack.combo4.button;
        Combo4Attack.DAMAGE = settings.sheen.attack.combo4.damage;
        Combo4Attack.DELAY = settings.sheen.attack.combo4.delay;
        Combo4Attack.KNOCK_OUT = settings.sheen.attack.combo4.ko.toLowerCase() == "true" ? true : false;
        Combo4Attack.UNBLOCKABLE = settings.sheen.attack.combo4.unblockable.toLowerCase() == "true" ? true : false;

        FlightKickAttack.COST = settings.sheen.attack.flight_kick.cost;
        FlightKickAttack.KEYS = settings.sheen.attack.flight_kick.button;
        FlightKickAttack.DAMAGE = settings.sheen.attack.flight_kick.damage;
        FlightKickAttack.DELAY = settings.sheen.attack.flight_kick.delay;
        FlightKickAttack.KNOCK_OUT = settings.sheen.attack.flight_kick.ko.toLowerCase() == "true" ? true : false;
        FlightKickAttack.UNBLOCKABLE = settings.sheen.attack.flight_kick.unblockable.toLowerCase() == "true" ? true : false;


        FireKick.COST = settings.sheen.attack.fire_kick.cost;
        FireKick.KEYS = settings.sheen.attack.fire_kick.button;
        FireKick.DAMAGE = settings.sheen.attack.fire_kick.damage;
        FireKick.DELAY = settings.sheen.attack.fire_kick.delay;
        FireKick.KNOCK_OUT = settings.sheen.attack.fire_kick.ko.toLowerCase() == "true" ? true : false;
        FireKick.UNBLOCKABLE = settings.sheen.attack.fire_kick.unblockable.toLowerCase() == "true" ? true : false;

        Traitor.RUN_SPEED[0] = settings.traitor.easy.run_speed;
        Traitor.LOCAL_ATTACK_DELAY[0] = settings.traitor.easy.attack_delay;
        Traitor.HEALTH[0] = settings.traitor.easy.health;
        Traitor.ATTACK_DAMAGE[0] = settings.traitor.easy.attack_damage;
        Traitor.SOCRE_FOR_DEATH[0] = settings.traitor.easy.score;
        Traitor.LOCAL_BLOCK_CHANCE[0] = settings.traitor.easy.block_chance;

        Traitor.RUN_SPEED[1] = settings.traitor.medium.run_speed;
        Traitor.LOCAL_ATTACK_DELAY[1] = settings.traitor.medium.attack_delay;
        Traitor.HEALTH[1] = settings.traitor.medium.health;
        Traitor.ATTACK_DAMAGE[1] = settings.traitor.medium.attack_damage;
        Traitor.SOCRE_FOR_DEATH[1] = settings.traitor.medium.score;
        Traitor.LOCAL_BLOCK_CHANCE[1] = settings.traitor.medium.block_chance;

        Traitor.RUN_SPEED[2] = settings.traitor.hard.run_speed;
        Traitor.LOCAL_ATTACK_DELAY[2] = settings.traitor.hard.attack_delay;
        Traitor.HEALTH[2] = settings.traitor.hard.health;
        Traitor.ATTACK_DAMAGE[2] = settings.traitor.hard.attack_damage;
        Traitor.SOCRE_FOR_DEATH[2] = settings.traitor.hard.score;
        Traitor.LOCAL_BLOCK_CHANCE[2] = settings.traitor.hard.block_chance;

        Punk.RUN_SPEED[0] = settings.punk.easy.run_speed;
        Punk.LOCAL_ATTACK_DELAY[0] = settings.punk.easy.attack_delay;
        Punk.HEALTH[0] = settings.punk.easy.health;
        Punk.ATTACK_DAMAGE[0] = settings.punk.easy.attack_damage;
        Punk.SOCRE_FOR_DEATH[0] = settings.punk.easy.score;
        Punk.LOCAL_BLOCK_CHANCE[0] = settings.punk.easy.block_chance;

        Punk.RUN_SPEED[1] = settings.punk.medium.run_speed;
        Punk.LOCAL_ATTACK_DELAY[1] = settings.punk.medium.attack_delay;
        Punk.HEALTH[1] = settings.punk.medium.health;
        Punk.ATTACK_DAMAGE[1] = settings.punk.medium.attack_damage;
        Punk.SOCRE_FOR_DEATH[1] = settings.punk.medium.score;
        Punk.LOCAL_BLOCK_CHANCE[1] = settings.punk.medium.block_chance;

        Punk.RUN_SPEED[2] = settings.punk.hard.run_speed;
        Punk.LOCAL_ATTACK_DELAY[2] = settings.punk.hard.attack_delay;
        Punk.HEALTH[2] = settings.punk.hard.health;
        Punk.ATTACK_DAMAGE[2] = settings.punk.hard.attack_damage;
        Punk.SOCRE_FOR_DEATH[2] = settings.punk.hard.score;
        Punk.LOCAL_BLOCK_CHANCE[2] = settings.punk.hard.block_chance;

        Mime.RUN_SPEED[0] = settings.mime.easy.run_speed;
        Mime.LAUNCH_DELAY[0] = settings.mime.easy.launch_delay;
        Mime.HEALTH[0] = settings.mime.easy.health;
        Mime.BALL_ACCELERATION[0] = settings.mime.easy.ball_acceleration;
        Mime.BALL_DAMAGE[0] = settings.mime.easy.ball_damage;
        Mime.SOCRE_FOR_DEATH[0] = settings.mime.easy.score;

        Mime.RUN_SPEED[1] = settings.mime.medium.run_speed;
        Mime.LAUNCH_DELAY[1] = settings.mime.medium.launch_delay;
        Mime.HEALTH[1] = settings.mime.medium.health;
        Mime.BALL_ACCELERATION[1] = settings.mime.medium.ball_acceleration;
        Mime.BALL_DAMAGE[1] = settings.mime.medium.ball_damage;
        Mime.SOCRE_FOR_DEATH[1] = settings.mime.medium.score;

        Mime.RUN_SPEED[2] = settings.mime.hard.run_speed;
        Mime.LAUNCH_DELAY[2] = settings.mime.hard.launch_delay;
        Mime.HEALTH[2] = settings.mime.hard.health;
        Mime.BALL_ACCELERATION[2] = settings.mime.hard.ball_acceleration;
        Mime.BALL_DAMAGE[2] = settings.mime.hard.ball_damage;
        Mime.SOCRE_FOR_DEATH[2] = settings.mime.hard.score;


        BodyBuilder.RUN_SPEED[0] = settings.bbuilder.easy.run_speed;
        BodyBuilder.LOCAL_ATTACK_DELAY[0] = settings.bbuilder.easy.attack_delay;
        BodyBuilder.HEALTH[0] = settings.bbuilder.easy.health;
        BodyBuilder.LOCAL_HIGH_ATTACK_DAMAGE[0] = settings.bbuilder.easy.high_attack_damage;
        BodyBuilder.LOCAL_LOW_ATTACK_DAMAGE[0] = settings.bbuilder.easy.low_attack_damage;
        BodyBuilder.SOCRE_FOR_DEATH[0] = settings.bbuilder.easy.score;
        BodyBuilder.LOCAL_BLOCK_CHANCE[0] = settings.bbuilder.easy.block_chance;

        BodyBuilder.RUN_SPEED[1] = settings.bbuilder.medium.run_speed;
        BodyBuilder.LOCAL_ATTACK_DELAY[1] = settings.bbuilder.medium.attack_delay;
        BodyBuilder.HEALTH[1] = settings.bbuilder.medium.health;
        BodyBuilder.LOCAL_HIGH_ATTACK_DAMAGE[1] = settings.bbuilder.medium.high_attack_damage;
        BodyBuilder.LOCAL_LOW_ATTACK_DAMAGE[1] = settings.bbuilder.medium.low_attack_damage;
        BodyBuilder.SOCRE_FOR_DEATH[1] = settings.bbuilder.medium.score;
        BodyBuilder.LOCAL_BLOCK_CHANCE[1] = settings.bbuilder.medium.block_chance;

        BodyBuilder.RUN_SPEED[2] = settings.bbuilder.hard.run_speed;
        BodyBuilder.LOCAL_ATTACK_DELAY[2] = settings.bbuilder.hard.attack_delay;
        BodyBuilder.HEALTH[2] = settings.bbuilder.hard.health;
        BodyBuilder.LOCAL_HIGH_ATTACK_DAMAGE[2] = settings.bbuilder.hard.high_attack_damage;
        BodyBuilder.LOCAL_LOW_ATTACK_DAMAGE[2] = settings.bbuilder.hard.low_attack_damage;
        BodyBuilder.SOCRE_FOR_DEATH[2] = settings.bbuilder.hard.score;
        BodyBuilder.LOCAL_BLOCK_CHANCE[2] = settings.bbuilder.hard.block_chance;


        Girl.RUN_SPEED[0] = settings.girl.easy.run_speed;
        Girl.LOCAL_ATTACK_DELAY[0] = settings.girl.easy.attack_delay;
        Girl.HEALTH[0] = settings.girl.easy.health;
        Girl.LOCAL_HIGH_ATTACK_DAMAGE[0] = settings.girl.easy.high_attack_damage;
        Girl.LOCAL_LOW_ATTACK_DAMAGE[0] = settings.girl.easy.low_attack_damage;
        Girl.SOCRE_FOR_DEATH[0] = settings.girl.easy.score;
        Girl.LOCAL_BLOCK_CHANCE[0] = settings.girl.easy.block_chance;

        Girl.RUN_SPEED[1] = settings.girl.medium.run_speed;
        Girl.LOCAL_ATTACK_DELAY[1] = settings.girl.medium.attack_delay;
        Girl.HEALTH[1] = settings.girl.medium.health;
        Girl.LOCAL_HIGH_ATTACK_DAMAGE[1] = settings.girl.medium.high_attack_damage;
        Girl.LOCAL_LOW_ATTACK_DAMAGE[1] = settings.girl.medium.low_attack_damage;
        Girl.SOCRE_FOR_DEATH[1] = settings.girl.medium.score;
        Girl.LOCAL_BLOCK_CHANCE[1] = settings.girl.medium.block_chance;

        Girl.RUN_SPEED[2] = settings.girl.hard.run_speed;
        Girl.LOCAL_ATTACK_DELAY[2] = settings.girl.hard.attack_delay;
        Girl.HEALTH[2] = settings.girl.hard.health;
        Girl.LOCAL_HIGH_ATTACK_DAMAGE[2] = settings.girl.hard.high_attack_damage;
        Girl.LOCAL_LOW_ATTACK_DAMAGE[2] = settings.girl.hard.low_attack_damage;
        Girl.SOCRE_FOR_DEATH[2] = settings.girl.hard.score;
        Girl.LOCAL_BLOCK_CHANCE[2] = settings.girl.hard.block_chance;


        Boss1.RUN_SPEED = settings.boss1.run_speed;
        Boss1.LOCAL_ATTACK_DELAY = settings.boss1.attack_delay;
        Boss1.HEALTH = settings.boss1.health;
        Boss1.LOCAL_HIGH_ATTACK_DAMAGE = settings.boss1.high_attack_damage;
        Boss1.LOCAL_LOW_ATTACK_DAMAGE = settings.boss1.low_attack_damage;
        Boss1.SOCRE_FOR_DEATH = settings.boss1.score;
        Boss1.LOCAL_BLOCK_CHANCE = settings.boss1.block_chance;

        Boss2.RUN_SPEED = settings.boss2.run_speed;
        Boss2.LOCAL_ATTACK_DELAY = settings.boss2.attack_delay;
        Boss2.HEALTH = settings.boss2.health;
        Boss2.LOCAL_HIGH_ATTACK_DAMAGE = settings.boss2.high_attack_damage;
        Boss2.LOCAL_LOW_ATTACK_DAMAGE = settings.boss2.low_attack_damage;
        Boss2.SOCRE_FOR_DEATH = settings.boss2.score;
        Boss2.LOCAL_BLOCK_CHANCE = settings.boss2.block_chance;

        Boss3.RUN_SPEED = settings.boss3.run_speed;
        Boss3.LOCAL_ATTACK_DELAY = settings.boss3.attack_delay;
        Boss3.HEALTH = settings.boss3.health;
        Boss3.LOCAL_HIGH_ATTACK_DAMAGE = settings.boss3.high_attack_damage;
        Boss3.LOCAL_LOW_ATTACK_DAMAGE = settings.boss3.low_attack_damage;
        Boss3.SOCRE_FOR_DEATH = settings.boss3.score;
        Boss3.LOCAL_BLOCK_CHANCE = settings.boss3.block_chance;

        Boss4.RUN_SPEED = settings.boss4.run_speed;
        Boss4.LOCAL_ATTACK_DELAY = settings.boss4.attack_delay;
        Boss4.HEALTH = settings.boss4.health;
        Boss4.LOCAL_HIGH_ATTACK_DAMAGE = settings.boss4.high_attack_damage;
        Boss4.LOCAL_LOW_ATTACK_DAMAGE = settings.boss4.low_attack_damage;
        Boss4.SOCRE_FOR_DEATH = settings.boss4.score;

    }


}

}