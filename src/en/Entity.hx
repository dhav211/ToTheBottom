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
		collisionShape.x = x + offset.x;
		collisionShape.y = y + offset.y;
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
}