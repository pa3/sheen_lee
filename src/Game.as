package {
import flash.events.Event;
import flash.ui.Mouse;

import mochi.as3.MochiServices;

import org.flixel.*;

import states.TitleState;

[SWF(width="528", height="352", backgroundColor="#8822bb")]
public class Game extends FlxGame {

    public static var _mochiads_game_id:String = "6659e0c0c31e5f1b";

    public function Game() {
        super(264, 176, TitleState, 2);
        addEventListener(Event.ENTER_FRAME, onAddedToStage);
        //FlxG.debug = true;
        this.pause = new FlxGroup();
    }

    private function onAddedToStage(event:Event):void {
        if (stage==null) {
            return;
        }
        removeEventListener(Event.ENTER_FRAME, onAddedToStage);
        MochiServices.connect( Game._mochiads_game_id, this.parent, onError );
    }

    private function onError(status:String):void {
        FlxG.log("Error! Status = " + status);
    }
}
}