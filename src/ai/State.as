package ai {
public interface State {
    function enter():void;
    function exit():void;
    function update():void;
}
}