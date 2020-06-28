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
import controllers.Camera;

enum CollisionSide 
{
    NONE;
    LEFT;
    RIGHT;
}

class Player extends Entity
{
    final MOVE_SPEED:Float = 45;

    var currentCollisionSide:CollisionSide = NONE;

    var isOnFloor:Bool = false;
    var isOnWall:Bool = false;
    var isOnCeiling:Bool = false;

    var currentJumpHeight:Float = 0;
    var currentJumpSpeed:Float = 0;
    var isJumping:Bool = false;
    var isAttacking:Bool = false;

    var currentDownwardVelocity:Float = 85;

    var animController:AnimationController;

    public function new(_camera:Camera, _game:Game, _x:Float, _y:Float)
    {
        super(_camera, _game, _x, _y);

        var tiles:Array<Tile>=hxd.Res.sprites.player.toTile().split(16);
        
        sprite = new Anim(tiles, 4, this);
        animController = new AnimationController(sprite, tiles);
        
        SetAnimations(tiles);
        collisionShape = Polygon.rectangle(_x, _y, 5,8);
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
        Attack();

        SetPosition();
    }

    /*
    Simple move function that checks to see if there are any collisions happening, and if not will move player in given direction. Also controls walk and idle
    animations.
    */
    function Move(_elapsed:Float)
    {
        var right:Bool = Key.isDown(Key.RIGHT);
        var left:Bool = Key.isDown(Key.LEFT);

        if (left && right)
            left = right = false;

        if (left && currentCollisionSide != LEFT) // TODO removing the currentCollisionSide fixes the stuck in floor bug
        {
            position.x -= MOVE_SPEED * _elapsed;
            if (!isAttacking)
                animController.Play("walk");
        }
        else if (right && currentCollisionSide != RIGHT)
        {
            position.x += MOVE_SPEED * _elapsed;
            if (!isAttacking)
                animController.Play("walk");
        }
        else if (!left && !right)
        {
            if (!isAttacking)
                animController.Play("idle");
        }
    }

    /*
    lets player jump by checking if jump is pressed and current speed of jump. When player starts to jump it launches at full speed and as it gets higher in the
    jump it will lose speed until gravity is greater than jump speed, which in that case, player will fall to the ground.
    */
    function Jump(_elapsed:Float) 
    {
        var jumpSpeed:Float = 125;
        var jump:Bool = Key.isPressed(Key.UP);
        
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
    
    /*
    Gravity will not be at full force right when player falls, it will build up force until it reaches terminal velocity and then gravity push will be the same
    until player touches floor, which then the force will be reset to it's initial value.
    */
    function ApplyGravity(_elapsed:Float)
    {
        var terminalVelocity:Float = 150;
        var gravity:Float = 65;

        if (!isOnFloor)
        {
            if (currentDownwardVelocity < terminalVelocity)
                currentDownwardVelocity += gravity * _elapsed;
            position.y += currentDownwardVelocity * _elapsed;
        }
        else
        {
            position.y += .1;
            currentDownwardVelocity = 45;
        }
    }

    function Attack()
    {
        if (Key.isPressed(Key.SPACE)  && !isAttacking)
        {
            isAttacking = true;
            animController.Play("attack");
        }
    }

    function CollideWithMap() 
    {
        isOnFloor = false;
        isOnWall = false;
        isOnCeiling = false;
        currentCollisionSide = NONE;

        for (collision in game.mapCollisions)  // TODO maybe not the most efficent way, look at TODO for better idea
        {
            var collideInfo:ShapeCollision = Collision.shapeWithShape(collisionShape, collision);

            if (collideInfo != null)
            {
                var heightDifference:Float = Math.floor(Math.abs((collideInfo.shape2.y - 4) - collideInfo.shape1.y));

                if (collideInfo.unitVectorY == -1 && !isOnFloor)
                {
                    isOnFloor = true;
                    position.y += collideInfo.overlap;
                }
                else if (collideInfo.unitVectorY == 1)
                {
                    isOnCeiling = true;
                    position.y -= collideInfo.overlap;
                }

                if (collideInfo.unitVectorX == -1)
                {
                    if (heightDifference > 0)
                    {
                        isOnWall = true;
                        currentCollisionSide = RIGHT;
                        position.x += collideInfo.overlap;
                    }
                }
                else if (collideInfo.unitVectorX == 1)
                {
                    if (heightDifference > 0)
                    {
                        isOnWall = true;
                        currentCollisionSide = LEFT;
                        position.x -= collideInfo.overlap;
                    }
                }   
            }
        }
    }

    function SetAnimations(_tiles:Array<Tile>)
    {
        animController.Add("walk", [_tiles[2], _tiles[0], _tiles[2], _tiles[1]]);
        animController.Add("idle", [_tiles[8], _tiles[9]], 2);
        animController.Add("attack", [_tiles[3],_tiles[4],_tiles[5],_tiles[6],_tiles[7]], 8, false);
    }
}