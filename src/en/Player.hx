package en;

import h2d.Bitmap;
import h2d.Tile;
import hxd.Key;
import differ.shapes.Polygon;
import h2d.Scene;

class Player extends Entity
{
    final MOVE_SPEED:Float = 100;

    public function new(_scene:Scene, _game:Game, _x:Float, _y:Float)
    {
        super(_scene, _game, _x, _y);

        var tile:Tile=hxd.Res.temp_player.toTile();
        tile = tile.center();
        
        sprite = new Bitmap(tile, this);

        collisionShape = Polygon.square(_x, _y, 16);
    }

    public override function update(elapsed:Float) 
    {
        super.update(elapsed);
        
        Move(elapsed);

        SetPosition();
    }

    function Move(_elapsed:Float)
    {
        var right:Bool = Key.isDown(Key.RIGHT);
        var left:Bool = Key.isDown(Key.LEFT);

        if (left && right)
            left = right = false;

        if (left)
        {
            position.x -= MOVE_SPEED * _elapsed;
        }
        if (right)
        {
            position.x += MOVE_SPEED * _elapsed;
        }
    }
}