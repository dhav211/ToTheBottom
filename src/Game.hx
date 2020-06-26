package;

import en.Entity;
import en.Player;
import map.Platform;

class Game extends hxd.App 
{
    public var entities(default, default):Array<Entity> = [];
    public var platforms(default, default):Array<Platform> = [];

    override function init() 
    {
        hxd.Res.initEmbed();
        var player = new Player(s2d, this, 150, 160);
        var platform1 = new Platform(s2d, this, 200, 150);
        var platform2 = new Platform(s2d, this, 150, 175);
        var platform3 = new Platform(s2d, this, 100, 150);
        s2d.scaleMode = Zoom(2);
    }

    static function main() 
    {
        new Game();
    }

    public override function update(elapsed:Float) 
	{
        for (entity in entities)
        {
            entity.update(elapsed);
        }
    }
}