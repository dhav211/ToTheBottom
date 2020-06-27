package controllers;

import h2d.Tile;
import en.Player;
import en.Entity;
import h2d.Anim;
import h2d.Scene;

class AnimationController
{
    var scene:Scene;
    var entity:Player;
    var frames:Array<Tile>;
    var animations:Map<String,Array<Tile>> = [];
    var animationPlaying:String = "";
    var currentAnimation:Anim = null;

    public function new(_currentAnimation:Anim, _frames:Array<Tile>) 
    {
        currentAnimation = _currentAnimation;
        frames = _frames;
    }

    public function Add(_name:String, _frames:Array<Tile>)
    {
        animations.set(_name, _frames);
    }

    public function Play(_name:String)
    {   
        if (animationPlaying != _name)
        {
            currentAnimation.play(animations[_name]);
            animationPlaying = _name;
        }
    }
}