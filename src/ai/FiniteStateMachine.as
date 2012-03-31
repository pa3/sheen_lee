package ai{
public class FiniteStateMachine {
    public var _currentState:State;

    private static var _freeFsms:Array = new Array();


    public static function newInstance():FiniteStateMachine {
        if (_freeFsms.length > 0) {
            return _freeFsms.shift();
        } else {
            return new FiniteStateMachine();
        }
    }

    public static function releaseInstance(fsm:FiniteStateMachine):void {
         _freeFsms.push(fsm);
    }

    public function changeState(newState:State):void {
        if (_currentState)
            _currentState.exit();
        _currentState = newState;
        _currentState.enter();
    }

    public function update():void {
        if (_currentState) {
            _currentState.update();
        }
    }
}
}