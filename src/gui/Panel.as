package gui {
import org.flixel.FlxBitmapFont;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;
import org.flixel.data.FlxFlash;

public class Panel extends FlxGroup  {
        [Embed(source='../../data/misc/panel.png')] private var ImgPanel:Class;

        [Embed(source = "../../data/misc/nums.png")]
        public var font_image:Class;
        

        private var _healthBar:FlxSprite;
        private var _lives:FlxBitmapFont;
        private var _score:FlxBitmapFont;

        private var _starsLayer:FlxGroup;


        private const HEALTH_BAR_Y:Number = 2;

        public function Panel(X:Number, Y:Number) {
            var panelBack:FlxSprite = new FlxSprite(X,Y, ImgPanel);
            panelBack.scrollFactor.x = 0;
            add(panelBack);

            var healthInside:FlxSprite = new FlxSprite(X+2,Y+HEALTH_BAR_Y);
            healthInside.createGraphic(110,14,0xff4a1d13); //Black interior, 48 pixels wide
            healthInside.scrollFactor.x = healthInside.scrollFactor.y = 0;
            add(healthInside);

            _healthBar = new FlxSprite(X+2,Y+HEALTH_BAR_Y);
            _healthBar.createGraphic(1,14,0xffff3333); //The red bar itself
            _healthBar.scrollFactor.x = _healthBar.scrollFactor.y = 0;
            _healthBar.origin.x = _healthBar.origin.y = 0; //Zero out the origin
            _healthBar.scale.x = 118; //Fill up the health bar all the way
            add(_healthBar);



            _lives = new FlxBitmapFont(font_image, 6,6, "0123456789", 10);
            _lives.width = 5;
            _lives.text = "0";
            _lives.x = 158;
            _lives.y = 6;
            _lives.scrollFactor.x = 0;
            add(_lives);

            _score = new FlxBitmapFont(font_image, 6,6, "0123456789", 10);
            _score.width = 120;
            _score.align = FlxBitmapFont.ALIGN_RIGHT;
            _score.text = "000000000000000";
            _score.x = 170;
            _score.y = 6;
            _score.scrollFactor.x = 0;
            add(_score);


            _starsLayer = new FlxGroup();
            add(_starsLayer);
//            for (var i:int = 0; i < StarsManager.starsAmount; i++) {
//                var star:Star = new Star(106+i*15,25);
//                _starsLayer.add(star);
//            }

        }

        //override public function update():void {

        //}


        public function set playerHealth(val:Number):void {
            _healthBar.scale.x = val >= 0 ? val*118/100 : 0;
        }

        override public function update():void {
            var score:int = FlxG.score;
            var amountOfNumbers:int = 0;
            if (score == 0) amountOfNumbers = 1;
            while (score > 0) {
                score = score / 10;
                amountOfNumbers++;
            }
            var text:String = "";
            for (var i:int = 0; i < 15-amountOfNumbers; i++) {
                text+="0";
            }
            text+=FlxG.score.toString();
            _score.text = text;

            _lives.text = FlxG.lives.toString();
            super.update();

        }

        public function starsChanged(starsBeforeUpdate:int):void {
            FlxG.flash.start(0x77ffff00);
            _starsLayer.destroy();
//            for (var i:int = 0; i < StarsManager.starsAmount; i++) {
//                var star:Star = new Star(106+i*15,25);
//                _starsLayer.add(star);
//            }
        }

    }
}