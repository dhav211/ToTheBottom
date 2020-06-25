package en;

import differ.Collision;
import differ.data.ShapeCollision;
import h2d.Bitmap;
import h2d.Tile;
import hxd.Key;
import differ.shapes.Polygon;
import h2d.Scene;

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
        }
        if (right && currentCollisionSide != RIGHT)
        {
            position.x += MOVE_SPEED * _elapsed;
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
        
        if (isJumping && currentJumpSpeed > 0)
        {
            var jumpIncrease = currentJumpSpeed * _elapsed;
            currentJumpSpeed -= jumpIncrease * 2;
            currentJumpHeight += jumpIncrease;
            position.y -= jumpIncrease;
        }
    }
                
    function ApplyGravity(_elapsed:Float)
    {
        var gravity:Float = 155;

        if (!isOnFloor)
            position.y += gravity * _elapsed;
        else
            position.y += .1;
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
}