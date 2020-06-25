package map;

import h2d.Tile;
import hxmath.math.Vector2;
import h2d.Bitmap;
import h2d.Scene;
import h2d.Object;
import differ.shapes.Polygon;

class Platform extends Object
{
    var scene:Scene;
    var game:Game;
    var sprite:Bitmap;
    public var collisionShape(default, null):Polygon;
    var position:Vector2;

    public function new (_scene:Scene, _game:Game, _x:Float, _y:Float)
    {
        super(_scene);

        scene = _scene;
        game = _game;
        x = _x;
        y = _y;

        position = new Vector2(x, y);

        var tile:Tile=hxd.Res.platform.toTile();
        tile = tile.center();
        
        sprite = new Bitmap(tile, this);

        collisionShape = Polygon.rectangle(x, y, tile.width, tile.height);

        game.platforms.push(this);
    }
}