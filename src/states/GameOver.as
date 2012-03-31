package states {
import flash.ui.Mouse;

import mochi.as3.MochiScores;
import mochi.as3.MochiServices;

import org.flixel.FlxBitmapFont;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.data.FlxAnim;
import org.flixel.data.FlxInput;
import org.flixel.data.FlxKeyboard;

public class GameOver extends FlxState {
    [Embed(source="../../data/misc/main_menu_back.png")]
    public var back_image:Class;

    [Embed(source="../../data/misc/font.png")]
    public var font_image:Class;

    private var _back:FlxSprite = new FlxSprite(0, 0, back_image);
    private var _congratulationsText:FlxBitmapFont;
    private var _scoresBoardClosed:Boolean = false;

    public function GameOver() {
        FlxG.timeScale = 1;
        this.add(_back);
        _congratulationsText = new FlxBitmapFont(font_image, 8, 10, FlxBitmapFont.TEXT_SET_SL, 8);
        _congratulationsText.multiLine = true;
        _congratulationsText.align = FlxBitmapFont.ALIGN_CENTER;
        _congratulationsText.text = "GAME OVER!\n\n\n\nPLEASE, WAIT FOR\nSCORES BOARD.";
        _congratulationsText.y = 30;
        _congratulationsText.x = (FlxG.width - _congratulationsText.width) / 2;
        this.add(_congratulationsText);

        var o:Object = { n:[7, 15, 15, 9, 3, 0, 13, 6, 10, 7, 12, 7, 3, 13, 3, 2], f:function (i:Number, s:String):String {
            if (s.length == 16) return s;
            return this.f(i + 1, s + this.n[i].toString(16));
        }};
        var boardID:String = o.f(0, "");
        MochiScores.showLeaderboard({boardID:boardID, score:FlxG.score, onDisplay:onDisplay, onClose:onClose});
    }

    private function onDisplay():void {

    }

    private function onClose():void {
        _congratulationsText.text = "GAME OVER!\n\n\n\nPRESS <Z> KEY\nTO RESTART.";
        _congratulationsText.x = (FlxG.width - _congratulationsText.width) / 2;
        _scoresBoardClosed = true;
    }

    public override function update():void {
        super.update();
        if (_scoresBoardClosed) {
            if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("SPACE")) {
                FlxG.state = new MainMenuState();
            }
        }

    }
}
}
