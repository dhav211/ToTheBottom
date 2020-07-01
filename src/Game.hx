package;

import h2d.TileGroup;
import h2d.Tile;
import en.Entity;
import en.Player;
import map.Platform;
import controllers.Camera;
import differ.shapes.Polygon;
import controllers.LevelLoader;

class Game extends hxd.App 
{
    public var entities(default, default):Array<Entity> = [];
    public var platforms(default, default):Array<Platform> = [];
    public var mapCollisions(default, default):Array<Polygon> = [];
    public var camera(default, null):Camera;
    public var levelLoader(default, null):LevelLoader;
    public var player(default, default):Player;

    override function init() 
    {
        hxd.Res.initEmbed();

        camera = new Camera(s2d, this, s2d.width / 2, s2d.height / 2);
        levelLoader = new LevelLoader(camera, this);
        levelLoader.LoadLevel();
        
        s2d.scaleMode = Zoom(2);
        camera.target = player;
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

        postUpdate(elapsed);
    }

    function postUpdate(elapsed:Float) 
    {
        camera.update(elapsed);
    }
}