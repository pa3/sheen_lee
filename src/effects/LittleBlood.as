package effects
{
	import org.flixel.FlxSprite;

	public class LittleBlood extends FlxSprite
	{
		
		[Embed(source='../../data/effects/l_blood.png')] private var Img:Class;
		
		public function LittleBlood()
		{
			super();
			this.x = 0;
			this.y = 0;
			loadGraphic(Img, true, true, 16, 16);
			addAnimation("bang", [0,1,2,3], 15, false);
			play("bang");   BigBlood
			exists = false;
            dead = true;
		}
		
		override public function update():void {
			super.update();
			if (finished) {
				kill();
			}
		} 
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X,Y);
			
		}
		
		public function bang( X:Number, Y:Number, facing:uint):void {
			this.facing = facing;
			reset(X,Y);
			play("bang", true);
		}
		
	}
}