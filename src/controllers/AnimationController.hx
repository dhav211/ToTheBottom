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
    var animationsLooping:Map<String, Bool> = [];
    var animationsSpeed:Map<String, Int> = [];
    var animationPlaying:String = "";
    var currentAnimation:Anim = null;

    public function new(_currentAnimation:Anim, _frames:Array<Tile>) 
    {
        currentAnimation = _currentAnimation;
        frames = _frames;
    }

    /*
    The frames are added to the animations dictionary, which are an array of tiles, the key is a string which is the name of the animation.
    The other two dictionaries are used to set the looping bool and the speed of the animation itself
    */
    public function Add(_name:String, _frames:Array<Tile>, ?_speed:Int = 4,?_looping:Bool = true)
    {
        animations.set(_name, _frames);
        animationsSpeed.set(_name, _speed);
        animationsLooping.set(_name, _looping);
    }

    /*
    Plays animation by first checking wether the animation is already playing, if it isn't then it will be played. The animationPlaying is a string which is
    the name of the animation set to be played in this function. It will be checked when an animation is called to be played.
    */
    public function Play(_name:String)
    {   
        if (animationPlaying != _name)
        {
            currentAnimation.loop = animationsLooping[_name];
            currentAnimation.speed = animationsSpeed[_name];
            currentAnimation.play(animations[_name]);
            animationPlaying = _name;
        }
    }
}