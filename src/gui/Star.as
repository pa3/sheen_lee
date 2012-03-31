package gui {
import org.flixel.FlxG;
import org.flixel.FlxSprite;

public class Star extends FlxSprite {

    [Embed(source='../../data/misc/star.png')]
    private var ImgStar:Class;


    private var blinkTimer:Number = 0;

    public function Star(X:Number, Y:Number) {
        super(X,Y);
        scrollFactor.x = scrollFactor.y = 0;
        loadGraphic(ImgStar, true, false, 11,11);
        addAnimation("blink", [0,1,2,3,4,5,6, 0], 10, false);
        play("blink");
    }


    override public function update():void {
        super.update();
        blinkTimer+= FlxG.elapsed;
        if (blinkTimer > 2) {
            blinkTimer = 0;
            if (Math.random() < 0.3) {
                play("blink");
            }
        }
    }
}
}