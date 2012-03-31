package states{
import mochi.as3.MochiEvents;
import mochi.as3.MochiScores;

import org.flixel.FlxBitmapFont;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxU;

public class MainMenuState extends FlxState {
    [Embed(source = "../../data/misc/main_menu_back.png")]
    public var back_image:Class;

    [Embed(source = "../../data/misc/main_menu_board.png")]
    public var board_image:Class;

    [Embed(source = "../../data/misc/font.png")]
    public var font_image:Class;

    [Embed(source = "../../data/misc/menu_fireball.png")]
    public var fireball_image:Class;


    private var _back:FlxSprite = new FlxSprite(0,0,back_image);
    private var _board:FlxSprite = new FlxSprite(0,0,board_image);

    private var _menuButtons:Array = new Array();
    private var _selectedButton:int = 0;

    private var _fireBallLeft:FlxSprite;
    private var _fireBallRight:FlxSprite;

    public function MainMenuState() {                                                                   
        super();
        FlxG.level = 1;
        this.add(_back);
        this.add(_board);


        var playButton:FlxBitmapFont = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        playButton.multiLine = true;
        playButton.text = "PLAY";
        playButton.x = (FlxG.width - playButton.width)/2;
        playButton.y = 50;
        this.add(playButton);
        _menuButtons.push(playButton);
        _selectedButton = 0;

        var recordsButton:FlxBitmapFont = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        recordsButton.multiLine = true;
        recordsButton.text = "RECORDS";
        recordsButton.x = (FlxG.width - recordsButton.width)/2;
        recordsButton.y = 65;
        this.add(recordsButton);
        _menuButtons.push(recordsButton);

        var authorsButton:FlxBitmapFont = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        authorsButton.multiLine = true;
        authorsButton.text = "AUTHORS";
        authorsButton.x = (FlxG.width - authorsButton.width)/2;
        authorsButton.y = 80;
        this.add(authorsButton);
        _menuButtons.push(authorsButton);

        var moreGamesButton:FlxBitmapFont = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        moreGamesButton.multiLine = true;
        moreGamesButton.text = "MORE GAMES";
        moreGamesButton.x = (FlxG.width - moreGamesButton.width)/2;
        moreGamesButton.y = 95;
        this.add(moreGamesButton);
        _menuButtons.push(moreGamesButton);


        _fireBallLeft = new FlxSprite(playButton.x - 43,50);
        _fireBallLeft.loadGraphic(fireball_image, true, false, 34, 10);
        _fireBallLeft.addAnimation("idle", [0,1,2,3], 10);
        _fireBallLeft.play("idle");
        this.add(_fireBallLeft);

        _fireBallRight = new FlxSprite(playButton.x + playButton.width +5,50);
        _fireBallRight.loadGraphic(fireball_image, true, true, 34, 10);
        _fireBallRight.addAnimation("idle", [0,1,2,3], 10);
        _fireBallRight.play("idle");
        _fireBallRight.facing = FlxSprite.LEFT;
        this.add(_fireBallRight);

        MochiEvents.startPlay("MainMenuState");

    }

    override public function update():void {

        super.update();

        var nextSelection:int = _selectedButton;
        if (FlxG.keys.justPressed("DOWN")) {
            nextSelection = _selectedButton+1;
        } else if (FlxG.keys.justPressed("UP")) {
            nextSelection = _selectedButton-1;
        } else if (FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C")) {
            switch (_selectedButton) {
                case 0:
                    MochiEvents.endPlay();
                    FlxG.lives = 3;
                    FlxG.state = new DeadGrandpaState();
                    //FlxG.state = new PlayState();
                    return;
                case 1:
                    var o:Object = { n:[7, 15, 15, 9, 3, 0, 13, 6, 10, 7, 12, 7, 3, 13, 3, 2], f:function (i:Number, s:String):String {
                        if (s.length == 16) return s;
                        return this.f(i + 1, s + this.n[i].toString(16));
                    }};
                    var boardID:String = o.f(0, "");

                    MochiScores.showLeaderboard({boardID:boardID});
                    break;
                case 2:
                    FlxG.state = new AuthorsState();
                    break;
                case 3:
                    FlxU.openURL("http://www.sponsorssite.com");

                    break;
            }
        } 

        if (nextSelection != _selectedButton) {
            if (nextSelection >= _menuButtons.length) {
                nextSelection = 0;
            } else if (nextSelection < 0) {
                nextSelection = _menuButtons.length - 1;
            }
            _fireBallRight.y = _fireBallLeft.y = _menuButtons[nextSelection].y;
            _fireBallRight.x = _menuButtons[nextSelection].x + _menuButtons[nextSelection].width + 5;
            _fireBallLeft.x = _menuButtons[nextSelection].x - 43; 
            _selectedButton = nextSelection;
            //_fireBallLeft.y = 50 + 15*_selectedButton;
        }

    }}
}