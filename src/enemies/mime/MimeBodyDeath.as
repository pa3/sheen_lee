package enemies.mime {
    import org.flixel.FlxSprite;

    public class MimeBodyDeath extends FlxSprite {

        [Embed(source='../../../data/enemies/mime_death_0.png')]
        private var ImgDeath0:Class;
        [Embed(source='../../../data/enemies/mime_death_1.png')]
        private var ImgDeath1:Class;
        [Embed(source='../../../data/enemies/mime_death_2.png')]
        private var ImgDeath2:Class;

        private var _groundTouchCount:uint = 0;

        protected static const PLAYER_RUN_SPEED:int = 80;
        protected static const GRAVITY_ACCELERATION:Number = 420;
        protected static const JUMP_ACCELERATION:Number = 240;
        private var level:int = 0;

        public function MimeBodyDeath(level:uint) {
            super();
            this.level = level;

            switch(level) {
                case 0:
                    loadGraphic(ImgDeath0, true, true, 54, 46);
                    break;
                case 1:
                    loadGraphic(ImgDeath1, true, true, 54, 46);
                    break;
                case 2:
                    loadGraphic(ImgDeath2, true, true, 54, 46);
                    break;
            }

            width = 54;
            height = 32;
            offset.x = 0;
            offset.y = 0;
            addAnimation("frame_1", [0], 10, false);
            addAnimation("frame_2", [1], 10, false);
            addAnimation("frame_3", [2], 10, false);
            exists = false;
        }

        override public function update():void {
            super.update();

            if (y + height >= 180 && _groundTouchCount < 3) {
                _groundTouchCount++;
                if (_groundTouchCount == 1) {
                    velocity.y = -100;
                }
                y = 180 - height;
            }

            if (_groundTouchCount == 0) {
                if (velocity.y < 0) {
                    play("frame_1", true);
                } else {
                    play("frame_2", true);
                }
            }
            else if (_groundTouchCount == 1) {
                play("frame_3", true);
            }
            else if (_groundTouchCount == 2) {
                //play("frame_3", true);
                velocity.x = 0;
                velocity.y = 0;
                acceleration.y = 0;
                //flicker(2, 0.2);
                flicker(2);
            }
            else if (!flickering()) {
                kill();
            }


        }

        public function die(Direction:uint, X:Number, Y:Number):void {
            reset(X, Y);
            drag.x = 0;
            facing = Direction;
            acceleration.y = GRAVITY_ACCELERATION*1.5;
            maxVelocity.x = PLAYER_RUN_SPEED;
            maxVelocity.y = JUMP_ACCELERATION;
            velocity.x = (facing == LEFT) ? 100 : -100;
            velocity.y = -50;
            _groundTouchCount = 0;
            play("frame_1");
        }
    }
}