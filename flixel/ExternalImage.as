package {
  import flash.display.BitmapData;

  //
  // This class is a hack designed to allow using externally-loaded images in Flixel.
  //
  public class ExternalImage {

    private static var data_to_load:BitmapData;
    private static var unique_id:String;

    public function ExternalImage():void {}

    public static function setData(data:BitmapData, id:String):void {
      data_to_load = data;
      unique_id    = id;
    }

    public static function toString():String {
      return unique_id;
    }

    public function get bitmapData():BitmapData {
      return data_to_load;
    }

  }
}