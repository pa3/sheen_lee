package gui {
import org.flixel.FlxBitmapFont;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;

public class KeysScreen extends FlxGroup  {

    [Embed(source = "../../data/misc/font.png")]
    public var font_image:Class;

    [Embed(source = "../../data/misc/keysscreen_back.png")]
    public var bg_image:Class;

    private var basic:FlxBitmapFont;
    private var header:FlxBitmapFont;
    private var combo1:FlxBitmapFont;
    private var combo2:FlxBitmapFont;
    private var combo3:FlxBitmapFont;
    private var combo4:FlxBitmapFont;

    private var fireKick:FlxBitmapFont;
    private var fireBall:FlxBitmapFont;
    private var bycicleKick:FlxBitmapFont;
    private var _back:FlxSprite;
    private var block:FlxBitmapFont;


    public function KeysScreen() {
        _back = new FlxSprite(0,0, bg_image);
        _back.x = 5;
        _back.y = 5;
        _back.scrollFactor.x = 0;
        add(_back);



        header = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        header.width = 5;
        header.text = "ATTACKS";
        header.x = 110;
        header.y = 32;
        header.scrollFactor.x = 0;
        add(header);


        block = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        block.width = 5;
        block.text = "X .........BLOCK";
        block.x = 45;
        block.y = 57;
        block.scrollFactor.x = 0;
        add(block);


        basic = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        basic.width = 5;
        basic.text = "Z .........BASIC ATTACK";
        basic.x = 45;
        basic.y = 67;
        basic.scrollFactor.x = 0;
        add(basic);

        combo1 = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        combo1.width = 5;
        combo1.text = "Z * 2 .....COMBO 1";
        combo1.x = 45;
        combo1.y = 77;
        combo1.scrollFactor.x = 0;
        add(combo1);

        combo2 = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        combo2.width = 5;
        combo2.text = "Z * 3 .....COMBO 2";
        combo2.x = 45;
        combo2.y = 87;
        combo2.scrollFactor.x = 0;
        add(combo2);

        combo3 = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        combo3.width = 5;
        combo3.text = "Z * 4 .....COMBO 3";
        combo3.x = 45;
        combo3.y = 97;
        combo3.scrollFactor.x = 0;
        add(combo3);

        combo4 = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        combo4.width = 5;
        combo4.text = "Z * 5 .....COMBO 4";
        combo4.x = 45;
        combo4.y = 107;
        combo4.scrollFactor.x = 0;
        add(combo4);

        fireKick = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        fireKick.width = 5;
        fireKick.text = "^ + } + Z .FIRE KICK";
        fireKick.x = 45;
        fireKick.y = 117;
        fireKick.scrollFactor.x = 0;
        add(fireKick);

        bycicleKick = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL+"}{^", 8);
        bycicleKick.width = 5;
        bycicleKick.text = "} + } + Z .BYCICLE KICK";
        bycicleKick.x = 45;
        bycicleKick.y = 130;
        bycicleKick.scrollFactor.x = 0;
        add(bycicleKick);

    }
}
}