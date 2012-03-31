package sheen {

public class ComboKeys {

    private static const MAX_COMBO_LENGTH:uint = 10;

    private var keys:Vector.<String>;
    private var delays:Vector.<Number>;

    private var timeFromLastKey:Number;

    public function ComboKeys() {
        keys = new Vector.<String>(MAX_COMBO_LENGTH);
        delays = new Vector.<Number>(MAX_COMBO_LENGTH);
        timeFromLastKey = 0.0;
    }


    private static var _instance:ComboKeys;

    public static function getInstance():ComboKeys {
        if (_instance == null) {
            _instance = new ComboKeys();
        }
        return _instance;
    }

    public function keyPressed(key:String):void {
        for (var i:int = MAX_COMBO_LENGTH - 1; i > 0; i--) {
            keys[i] = keys[i - 1];
            delays[i] = delays[i - 1];
        }
        keys[0] = key;
        delays[0] = timeFromLastKey;
        timeFromLastKey = 0;
    }

    public function getCombination(delay:Number):String {
        var result:Vector.<String> = new Vector.<String>();
        if (delay < timeFromLastKey) {
            return "";
        } else {
            result.unshift(keys[0]);
        }

        for (var i:int = 1; i < MAX_COMBO_LENGTH; i++) {
            if (delays[i-1] <= delay && keys[i] != null) {
                result.unshift(keys[i]);
            } else {
                break;
            }
        }
        
        return result.join(",");
    }

    public function update(secondsFromLastUpdate:Number):void {
        timeFromLastKey += secondsFromLastUpdate;
    }

    public function reset():void {
        for (var i:int = MAX_COMBO_LENGTH - 1; i >= 0; i--) {
            keys[i] = null;
            delays[i] = 1000;
        }
    }
}
}