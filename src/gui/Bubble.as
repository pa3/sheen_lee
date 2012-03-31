package gui {
import org.flixel.FlxBitmapFont;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxSprite;
import org.flixel.FlxSprite;

public class Bubble extends FlxGroup{
    [Embed(source='../../data/misc/bubble_part.png')]
    private var ImgBubbleBottom:Class;
    [Embed(source = "../../data/misc/font.png")]
    public var font_image:Class;

    private var _bubbleBottom:FlxSprite;
    private var _bubbleBack:FlxSprite;
    private var _text:FlxBitmapFont;

    public function Bubble(X:Number, Y:Number, facing:uint) {
        _bubbleBottom = new FlxSprite(X,Y);
        _bubbleBottom.loadGraphic(ImgBubbleBottom, false, true);
        add(_bubbleBottom);
        _bubbleBack = new FlxSprite();
        _bubbleBack.createGraphic(1, 1, 0xff000000);
        add(_bubbleBack);
        _bubbleBottom.facing = facing == FlxSprite.LEFT ? FlxSprite.RIGHT : FlxSprite.LEFT;

        _text = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        _text.multiLine = true;
        _text.width = _text.height = 10;
        _text.text = "THIS IS SPARTA!\nALL OF YOU'LL DIE!!";
        add(_text);

        setPosition(X, Y, facing);
    }

    public function set text(bubbleText:String):void {
        _text.text = bubbleText;
    }

    public function setPosition(x:Number, y:Number, facing:uint):void {
        _bubbleBottom.facing = facing == FlxSprite.LEFT ? FlxSprite.RIGHT : FlxSprite.LEFT;
        _bubbleBack.scale.x = _text.width + 20;
        _bubbleBack.scale.y = _text.height + 10;
        _bubbleBack.offset.x = -_bubbleBack.scale.x/2;
        _bubbleBack.offset.y = -_bubbleBack.scale.y/2;
                                   
        if (_bubbleBottom.facing == FlxSprite.LEFT) {
            _bubbleBottom.x  =  x;
            _bubbleBottom.y  = y - _bubbleBottom.height;
            _bubbleBack.x = _bubbleBottom.x - 20;
        } else {
            _bubbleBottom.x  =  x - _bubbleBottom.width;
            _bubbleBottom.y  = y - _bubbleBottom.height;
            _bubbleBack.x = (_bubbleBottom.x + _bubbleBottom.width + 20) - _bubbleBack.scale.x;
        }

        _bubbleBack.y = _bubbleBottom.y - _bubbleBack.scale.y;

        _text.x = _bubbleBack.x + 10;
        _text.y = _bubbleBack.y + 5;

    }

}
}