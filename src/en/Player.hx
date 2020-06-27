package en;

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

enum CollisionSide 
{
    NONE;
    LEFT;
    RIGHT;
}

class Player extends Entity
{
    final MOVE_SPEED:Float = 100;

    var currentCollisionSide:CollisionSide = NONE;

    var isOnFloor:Bool = false;
    var isOnWall:Bool = false;
    var isOnCeiling:Bool = false;

    var currentJumpHeight:Float = 0;
    var currentJumpSpeed:Float = 0;
    var isJumping:Bool = false;

    var currentDownwardVelocity:Float = 85;

    var animController:AnimationController;

    public function new(_scene:Scene, _game:Game, _x:Float, _y:Float)
    {
        super(_scene, _game, _x, _y);

        var tiles:Array<Tile>=hxd.Res.sprites.player.toTile().split(16);
        tiles[0].center();
        
        sprite = new Anim(tiles, 4, this);
        animController = new AnimationController(sprite, tiles);
        
        
        SetAnimations(tiles);
        collisionShape = Polygon.square(_x, _y, 8);
        offset = new Vector2(12, 12);
        animController.Play("idle");
    }

    public override function update(elapsed:Float) 
    {
        super.update(elapsed);
        CollideWithMap();
        
        Move(elapsed);
        Jump(elapsed);
        ApplyGravity(elapsed);

        SetPosition();
    }

    function Move(_elapsed:Float)
    {
        var right:Bool = Key.isDown(Key.RIGHT);
        var left:Bool = Key.isDown(Key.LEFT);

        if (left && right)
            left = right = false;

        if (left && currentCollisionSide != LEFT)
        {
            position.x -= MOVE_SPEED * _elapsed;
            animController.Play("walk");
        }
        else if (right && currentCollisionSide != RIGHT)
        {
            position.x += MOVE_SPEED * _elapsed;
            animController.Play("walk");
        }
        else if (!left && !right)
        {
            animController.Play("idle");
        }
    }

    function Jump(_elapsed:Float) 
    {
        var jumpSpeed:Float = 325;
        var jump:Bool = Key.isPressed(Key.SPACE);
        
        if (jump && isOnFloor)
        {
            isJumping = true;
            currentJumpSpeed = jumpSpeed;
        }
        else if (isOnFloor || isOnCeiling)
        {
            isJumping = false;
        }
        
        if (isJumping && currentJumpSpeed > 0)
        {
            var jumpIncrease = currentJumpSpeed * _elapsed;
            currentJumpSpeed -= jumpIncrease * 2;
            position.y -= jumpIncrease;
        }
    }
                
    function ApplyGravity(_elapsed:Float)
    {
        var terminalVelocity:Float = 275;
        var gravity:Float = 125;

        if (!isOnFloor)
        {
            if (currentDownwardVelocity < terminalVelocity)
                currentDownwardVelocity += gravity * _elapsed;
            position.y += currentDownwardVelocity * _elapsed;
        }
        else
        {
            position.y += .1;
            currentDownwardVelocity = 85;
        }
    }

    function CollideWithMap() 
    {
        isOnFloor = false;
        isOnWall = false;
        isOnCeiling = false;
        currentCollisionSide = NONE;

        for (platform in game.platforms)  // Set an array of the platforms collision shapes to try shapeWithShapes.
        {
            var collideInfo:ShapeCollision = Collision.shapeWithShape(collisionShape, platform.collisionShape);

            if (collideInfo != null)
            {
                if (collideInfo.unitVectorY == -1)
                {
                    isOnFloor = true;
                    position.y += collideInfo.overlap;
                }
                else if (collideInfo.unitVectorY == 1)
                {
                    isOnCeiling = true;
                    position.y -= collideInfo.overlap;  // MIGHT BE WRONG
                }

                if (collideInfo.unitVectorX == -1)
                {
                    isOnWall = true;
                    currentCollisionSide = RIGHT;
                    position.x += collideInfo.overlap;
                }
                else if (collideInfo.unitVectorX == 1)
                {
                    isOnWall = true;
                    currentCollisionSide = LEFT;
                    position.x -= collideInfo.overlap;
                }   
            }
        }
    }

    function SetAnimations(_tiles:Array<Tile>)
    {
        animController.Add("walk", [_tiles[2], _tiles[0], _tiles[2], _tiles[1]]);
        animController.Add("idle", [_tiles[8], _tiles[9]]);
    }
}