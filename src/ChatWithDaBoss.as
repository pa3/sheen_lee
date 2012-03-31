package {
import gui.Bubble;

import org.flixel.FlxSprite;

public class ChatWithDaBoss {

    private var _player:FlxSprite;
    private var _boss:FlxSprite;
    private var _level:int;
    private var _innerState:int;
    private var _bubble:Bubble;

    public function ChatWithDaBoss(level:int, player:FlxSprite, boss:FlxSprite, bubble:Bubble) {
        _player = player;
        _boss = boss;
        _level = level;
        _bubble = bubble;
        _innerState = 0;
    }

    public function next():Boolean {
        _innerState++;
        switch (_level) {
            case 2:
                switch (_innerState) {
                case 1:
                    _bubble.text = "It was extremely\neasy to find you,\nSketch Rimanez!";
                    _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                    break;
                case 2:
                    _bubble.text = "Ha-ha...\nYou don't\neven know who\nyou're looking for!";
                    _bubble.setPosition(_boss.x+10, _boss.y - 5, FlxSprite.LEFT);
                    break;
                case 3:
                    _bubble.text = "So, you're\nnot Sketch Rimanez?";
                    _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                    break;
                case 4:
                    _bubble.text = "Nope, idiot!";
                    _bubble.setPosition(_boss.x+10, _boss.y - 5, FlxSprite.LEFT);
                    break;
                case 5:
                    _bubble.text = "Well, it won't\nstop me from\nkicking your ass!";
                    _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                    break;
                case 6:
                    return false;
                    break;
                }
                break;
            case 4:
                switch (_innerState) {
                    case 1:
                        _bubble.text = "Sketch Rimanez?";
                        _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                        break;
                    case 2:
                        _bubble.text = "Ugrh.. Arghr..\nUmmm... Orgorg...";
                        _bubble.setPosition(_boss.x+10, _boss.y - 5, FlxSprite.LEFT);
                        break;
                    case 3:
                        _bubble.text = "Oh, die anyway!";
                        _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                        break;
                    case 4:
                        return false;
                }

                break;
            case 6:

                switch (_innerState) {
                    case 1:
                        _bubble.text = "B Some text #";
                        _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                        break;
                    case 2:
                        _bubble.text = "B Some text #";
                        _bubble.setPosition(_boss.x+10, _boss.y - 5, FlxSprite.LEFT);
                        break;
                    case 3:
                        _bubble.text = "B Some text #";
                        _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                        break;
                    case 4:
                        _bubble.text = "B Some text #";
                        _bubble.setPosition(_boss.x+10, _boss.y - 5, FlxSprite.LEFT);
                        break;
                    case 5:
                        _bubble.text = "B Some text #";
                        _bubble.setPosition(_player.x+20, _player.y - 20, FlxSprite.RIGHT);
                        break;
                    case 6:
                        return false;
                        break;
                }

                break;
        }
       return true;
    }
}
}