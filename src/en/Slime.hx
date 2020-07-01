package en;

import en.Entity.DirectionFacing;
import hxmath.math.Vector2;
import hxd.Res;
import differ.Collision;
import differ.data.ShapeCollision;
import h2d.Bitmap;
import h2d.Tile;
import hxd.Key;
import differ.shapes.Polygon;
import h2d.Scene;
import h2d.Anim;
import controllers.AnimationController;
import controllers.Camera;

class Slime extends Entity
{
    var animController:AnimationController;

    public function new(_camera:Camera, _game:Game, _x:Float, _y:Float)
	{
		super(_camera, _game, _x, _y);

		tiles = hxd.Res.sprites.slime_enemy.toTile().split(6);

		for (tile in tiles)
			tile.center();

		sprite = new Anim(tiles, 4, this);
		animController = new AnimationController(sprite, tiles);
		currentDirectionFacing = RIGHT;

		SetAnimations(tiles);
		collisionShape = Polygon.square(_x, _y, 8);
		offset = new Vector2(12, 12);
		animController.Play("walk");
    }
    
    function SetAnimations(_tiles:Array<Tile>)
	{
		animController.Add("walk", [_tiles[0], _tiles[1], _tiles[2], _tiles[1]]);
		animController.Add("attack", [_tiles[3], _tiles[4], _tiles[5], _tiles[4]], 10, false);
	}
}