package {
public class SpawnInfo {
    public var chance:Number;
    public var enemy:Class;
    public var level:int;

    public function SpawnInfo(chance:Number, enemyClass:Class, level:int) {
        this.chance = chance;
        this.enemy = enemyClass;
        this.level = level;
    }
}
}