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

    /*
    The frames are added to the animations dictionary, which are an array of tiles, the key is a string which is the name of the animation
    */
    public function Add(_name:String, _frames:Array<Tile>)
    {
        animations.set(_name, _frames);
    }

    /*
    Plays animation by first checking wether the animation is already playing, if it isn't then it will be played. The animationPlaying is a string which is
    the name of the animation set to be played in this function. It will be checked when an animation is called to be played.
    */
    public function Play(_name:String)
    {   
        if (animationPlaying != _name)
        {
            currentAnimation.play(animations[_name]);
            animationPlaying = _name;
        }
    }
}