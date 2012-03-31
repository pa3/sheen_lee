package states {
import mochi.as3.MochiEvents;

import org.flixel.FlxBitmapFont;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;

public class AuthorsState extends FlxState {


    [Embed(source = "../../data/misc/main_menu_back.png")]
    public var back_image:Class;

    [Embed(source = "../../data/misc/font.png")]
    public var font_image:Class;

    [Embed(source='../../data/enemies/boss3.png')]
    private var ImgSke:Class;

    [Embed(source='../../data/enemies/boss4.png')]
    private var ImgPa3:Class;

    private var _pa3:FlxSprite;
    private var _ske:FlxSprite;

    private var _back:FlxSprite = new FlxSprite(0,0,back_image);
    private var _text:FlxBitmapFont;


    public function AuthorsState() {

        MochiEvents.trackEvent("AuthorsState");

        add(_back);
        
        _pa3 = new FlxSprite(160, 80);
        _pa3.loadGraphic(ImgPa3, true, true, 69, 68);
        _pa3.addAnimation("idle", [0,1], 2, true);
        _pa3.play("idle");
        _pa3.facing = FlxSprite.LEFT;
        _pa3.y = 120 - _pa3.height;
        add(_pa3);

        _ske = new FlxSprite(30, 80);
        _ske.loadGraphic(ImgSke, true, true, 80, 53);
        _ske.addAnimation("idle", [0,1], 2, true);
        _ske.play("idle");
        _ske.y = 120 - _ske.height;
        add(_ske);
        
        _text = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        _text.multiLine = true;
        _text.align = FlxBitmapFont.ALIGN_CENTER; 
        _text.text = "DEVELOPED BY \n\n\n\n\nAND \n\n\n\n\n SKE             PA3 ";
        _text.y = 30;
        _text.x = (FlxG.width - _text.width)/2;
        this.add(_text);
        
    }


    override public function update():void {
        super.update();
        if (FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C")) {
            FlxG.state = new MainMenuState();
        }
    }
}
}