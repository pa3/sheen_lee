package gui {
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;

public class HealthBar extends FlxGroup{

    private static const HEALTH_BAR_WIDTH:Number = 20;
    private static const HEALTH_BAR_HEIGHT:Number = 4;

    private var _bar:FlxSprite;

    public function HealthBar() {
        initGxf();
    }


    public function updateHealt(percents:Number):void {
        _bar.scale.x = HEALTH_BAR_WIDTH*percents; 
    }


    private function initGxf():void {
        var healthFrame:FlxSprite = new FlxSprite(0,0);
        healthFrame.createGraphic(2+HEALTH_BAR_WIDTH,2+HEALTH_BAR_HEIGHT);
        healthFrame.scrollFactor.x = healthFrame.scrollFactor.y = 0;
        add(healthFrame);

        var healthInside:FlxSprite = new FlxSprite(1,1);
        healthInside.createGraphic(HEALTH_BAR_WIDTH,HEALTH_BAR_HEIGHT,0xff000000);
        healthInside.scrollFactor.x = healthInside.scrollFactor.y = 0;
        add(healthInside);

        _bar = new FlxSprite(1,1);
        _bar.createGraphic(HEALTH_BAR_WIDTH,HEALTH_BAR_HEIGHT,0xff00ff00);
        _bar.scrollFactor.x = _bar.scrollFactor.y = 0;
        _bar.origin.x = _bar.origin.y = 0;
        _bar.scale.x = HEALTH_BAR_WIDTH;
        add(_bar);
    }


}
}