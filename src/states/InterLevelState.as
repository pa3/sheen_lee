package states{
import org.flixel.FlxBitmapFont;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;

public class InterLevelState extends FlxState{
    [Embed(source = "../../data/misc/main_menu_back.png")]
    public var back_image:Class;

    [Embed(source = "../../data/misc/font.png")]
    public var font_image:Class;

    private var _back:FlxSprite = new FlxSprite(0,0,back_image);
    private var _congratulationsText:FlxBitmapFont;
    
    public function InterLevelState() {
        FlxG.timeScale = 1;
        this.add(_back);
        _congratulationsText = new FlxBitmapFont(font_image, 8,10, FlxBitmapFont.TEXT_SET_SL, 8);
        _congratulationsText.multiLine = true;
        _congratulationsText.align = FlxBitmapFont.ALIGN_CENTER; 
        _congratulationsText.text = "CONGRATULATIONS!\n\nLEVEL " + (FlxG.level-1).toString() + " COMPLETED!\n\n\n\nYOU HAVE "+ FlxG.score +" SCORE!\n\n\n\nPRESS <Z> TO CONTINUE!";
        _congratulationsText.y = 30;
        _congratulationsText.x = (FlxG.width - _congratulationsText.width)/2;
        this.add(_congratulationsText);
    }

    public override function update():void {
        if (FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C")) {
            FlxG.state = new PlayState();
        }
    }

}
}