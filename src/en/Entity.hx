package en;

import h2d.Anim;
import h2d.Bitmap;
import h2d.Object;
import h2d.Scene;
import differ.shapes.Polygon;
import hxmath.math.Vector2;
import controllers.Camera;

class Entity extends Object
{
    var scene:Scene;
    var camera:Camera;
    var game:Game;
    var sprite:Anim;
    var collisionShape:Polygon;
    var position:Vector2;
    var offset:Vector2;

    public function new (_camera:Camera, _game:Game, _x:Float, _y:Float)
    {
        super(_camera);

        camera = _camera;
        game = _game;
        x = _x;
        y = _y;

        game.entities.push(this);

        position = new Vector2(x, y);
    }

    public function update(elapsed:Float) 
	{
		SetCollisionShapePosition();
	}
    
    public function dispose()
	{
		game.entities.remove(this);
		remove();
    }
    
    function SetPosition() 
    {
        x = position.x;
        y = position.y;   
    }

    /*
    Since the collison shapes are based on a third party library they don't have the same scene/parent binding as other objects do. So this will set the position
    of the collision shape whenever the position of object is changed.
    */
    function SetCollisionShapePosition()
    {
        collisionShape.x = x + offset.x;
		collisionShape.y = y + offset.y;
    }
}