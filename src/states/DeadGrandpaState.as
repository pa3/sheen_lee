package states {
import gui.Bubble;

import gui.Panel;

import mochi.as3.MochiEvents;

import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxSprite;
import org.flixel.FlxState;

import org.flixel.FlxTilemap;

import sheen.Sheen;

public class DeadGrandpaState extends FlxState {

    [Embed(source = "../../data/levels/flx_lvl_1.txt", mimeType = "application/octet-stream")]
    private var TxtMap:Class;
    [Embed(source = "../../data/levels/flx_lvl_12.png")]
    private var ImgMap:Class;
    [Embed(source='../../data/sheen/sheen_3.png')]
    private var ImgSheen:Class;
    [Embed(source='../../data/misc/grand.png')]
    private var ImgGrand:Class;

    private var _sheen:FlxSprite;
    private var _grandpa:FlxSprite;
    private var _bubble:Bubble;
    private var _conversationState:uint = 0;
    private var _panel:Panel;

    public function DeadGrandpaState() {
        super();
        addBackground();
        addSheen();
        addGrandpa();
        addTextBubble();
        addPanel();
        MochiEvents.startPlay("DeadGrandpaState");
    }

    override public function update():void {
        super.update();
        if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER")) {
            _conversationState++;
            if (_conversationState == 9) {
                MochiEvents.endPlay();
                FlxG.state = new PlayState();
            }

            switch (_conversationState) {
                case 1:
                    _bubble.text = "Grandpa! What's up?!";
                    _bubble.setPosition(_sheen.x+20, _sheen.y - 10, FlxSprite.RIGHT);
                    break;
                case 2:
                    _bubble.text = "That bustards have\nkicked my ass.";
                    _bubble.setPosition(_grandpa.x+10, _grandpa.y - 5, FlxSprite.LEFT);
                    break;
                case 3:
                    _bubble.text = "Oh, my god! How\ncould i kick 'em back?";
                    _bubble.setPosition(_sheen.x+20, _sheen.y - 10, FlxSprite.RIGHT);
                    break;
                case 4:
                    _bubble.text = "Use your <Z>\nkey to attack.";
                    _bubble.setPosition(_grandpa.x+10, _grandpa.y - 5, FlxSprite.LEFT);
                    break;
                case 5:
                    _bubble.text = "Use your <TAB>\nkey to list\nall available\ncombos!";
                    _bubble.setPosition(_grandpa.x+10, _grandpa.y - 5, FlxSprite.LEFT);
                    break;
                case 6:
                    _bubble.text = "Find and kill\ntheir boss -\nSketch Rimanez!";
                    _bubble.setPosition(_grandpa.x+10, _grandpa.y - 5, FlxSprite.LEFT);
                    break;
                case 7:
                    _bubble.text = "It is time\nfor me to die!";
                    _bubble.setPosition(_grandpa.x+10, _grandpa.y - 5, FlxSprite.LEFT);
                    break;
                case 8:
                    _bubble.text = "NO!!!!\nI will take\nthe revenge!!!";
                    _bubble.setPosition(_sheen.x+20, _sheen.y - 10, FlxSprite.RIGHT);
                    _grandpa.flicker();
                    break;
            }
        }

        if (_conversationState == 8 && !_grandpa.flickering()) {
            _grandpa.visible = false;
        }

    }

    private function addPanel():void {
        _panel = new Panel(0, 0);
        this.add(_panel);
    }

    private function addTextBubble():void {
        _bubble = new Bubble(100, 100, FlxSprite.LEFT);
        _bubble.text = "Sheen, finally,\nyou\'re here!\nPress <Z>\nto continue!";
        _bubble.setPosition(_grandpa.x + 10, _grandpa.y - 5, FlxSprite.LEFT);
        this.add(_bubble);
    }

    private function addGrandpa():void {
        _grandpa = new FlxSprite();
        _grandpa.loadGraphic(ImgGrand);
        _grandpa.x = 150;
        _grandpa.y = 145;
        this.add(_grandpa);
    }

    private function addBackground():void {
        var tileMap:FlxTilemap = new FlxTilemap();
        tileMap.drawIndex = 0;
        tileMap.loadMap(new TxtMap().toString(), ImgMap, 22, 22);
        this.add(tileMap);
    }

    private function addSheen():void {
        _sheen = new FlxSprite();
        _sheen.loadGraphic(ImgSheen, true, false, 92, 58);
        _sheen.width = 40;
        _sheen.height = 58;
        _sheen.offset.x = 26;
        _sheen.addAnimation("idle", [0, 1], 2, true);
        _sheen.play("idle");
        _sheen.x = 10;
        _sheen.y = 172 - _sheen.height;
        this.add(_sheen);
    }

}
}