package enemies.mime {
    import org.flixel.FlxGroup;
    import org.flixel.FlxSprite;

    public class MimeDeath extends FlxGroup {
        [Embed(source='../../../data/enemies/mime_ball.png')]
        private var Img:Class;


        private var _bodyDeath:MimeBodyDeath;
        private var _ball1:MimeBall;
        private var _ball2:MimeBall;
        private var _ball3:MimeBall;

        public function MimeDeath(level:uint) {
            super();
            _bodyDeath = new MimeBodyDeath(level);
            _ball1 = new MimeBall(1, null);
            _ball2 = new MimeBall(1, null);
            _ball3 = new MimeBall(1, null);
            this.add(_ball1);
            this.add(_ball2);
            this.add(_ball3);

            this.add(_bodyDeath);
        }


        public function die(Direction:uint, X:Number, Y:Number):void {
            //reset(X, Y);

            _ball1.reset(X   , Y+15);
            _ball2.reset(X+10, Y);
            _ball3.reset(X+20, Y+10);
            _ball1.startFall();
            _ball2.startFall();
            _ball3.startFall();

            _ball1.velocity.y = -100 ;
            _ball2.velocity.y = -50;
            _ball3.velocity.y = -150;
            _ball1.velocity.x = 30 * (Direction == FlxSprite.LEFT? 1: -1);
            _ball2.velocity.x = 60 * (Direction == FlxSprite.LEFT? 1: -1);
            _ball3.velocity.x = 67 * (Direction == FlxSprite.LEFT? 1: -1);

            _bodyDeath.die(Direction, X, Y);
        }        
    }
}