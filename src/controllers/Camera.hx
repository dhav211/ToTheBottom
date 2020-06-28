package controllers;

import en.Entity;
import h2d.Scene;
import h2d.Object;
import hxd.Key;
import hxmath.math.Vector2;

class Camera extends Object
{
    var width:Float;
    var height:Float;
    var zoom:Float;
    var viewPosition:Vector2;

    public var target(default, default):Entity;

    var scene:Scene;
    var game:Game;

    public function new(_scene:Scene, _game:Game, _x:Float, _y:Float)
    {
        super(_scene);

        scene = _scene;
        game = _game;

        zoom = 4;

        viewPosition = new Vector2(0.5 * _scene.width - _x, 0.5 * _scene.height - _y);
        x = viewPosition.x;
        y = viewPosition.y;

        setScale(zoom);
    }

    public function update(elapsed:Float) 
    {
        if (target != null)  // Simple follow target script
		{
            viewPosition.x = (0.5 * scene.width) - (target.x * zoom);
            viewPosition.y = (0.5 * scene.height) - (target.y * zoom);

            x = viewPosition.x;
            y = viewPosition.y;
        }
    }
}