package;

import h2d.TileGroup;
import h2d.Tile;
import ogmo.Level;
import ogmo.Project;
import h2d.Text;
import hxd.res.DefaultFont;
import en.Entity;
import en.Player;
import map.Platform;
import controllers.Camera;
import differ.shapes.Polygon;

class Game extends hxd.App 
{
    public var entities(default, default):Array<Entity> = [];
    public var platforms(default, default):Array<Platform> = [];
    public var mapCollisions(default, default):Array<Polygon> = [];
    public var camera(default, null):Camera;

    override function init() 
    {
        hxd.Res.initEmbed();

        camera = new Camera(s2d, this, s2d.width / 2, s2d.height / 2);

        var player = new Player(camera, this, 140, 174);

        camera.target = player;

        s2d.scaleMode = Zoom(2);

        // Here will be the temporary spot for level loading with ogmo
        var project:Project = Project.create(hxd.Res.maps.to_the_bottom.entry.getText());
        var level:Level = Level.create(hxd.Res.maps.playground.entry.getText());
        var tileImage:Tile = hxd.Res.maps.temp_tileset.toTile();
        var tileSize:Int = 8;
        var tileSet:Array<Tile> = [
            for (y in 0 ... Std.int(tileImage.height / tileSize))
                for (x in 0...Std.int(tileImage.width / tileSize))
                    tileImage.sub(x * tileSize, y * tileSize, tileSize, tileSize)
        ];
        
        

        level.onTileLayerLoaded = (tiles, layer) -> 
		{
			var tileGroup = new TileGroup(tileImage, camera);
			tileGroup.x += layer.offsetX;
            tileGroup.y += layer.offsetY;

			for (i in 0...tiles.length) 
			{
				if (tiles[i] > -1) 
				{
					var x:Int = i % layer.gridCellsX;
                    var y:Int = Math.floor(i / layer.gridCellsX);
                    
                    tileGroup.add(x * layer.gridCellWidth, y * layer.gridCellHeight, tileSet[tiles[i]]);
                    var collision:Polygon = Polygon.rectangle(x * layer.gridCellWidth, y * layer.gridCellHeight, 8, 8, false);
                    mapCollisions.push(collision);
				}
            }
        }
 
        level.load();
    }

    static function main() 
    {
        new Game();
    }

    public override function update(elapsed:Float) 
	{
        for (entity in entities)
        {
            entity.update(elapsed);
        }

        postUpdate(elapsed);
    }

    function postUpdate(elapsed:Float) 
    {
        camera.update(elapsed);
    }
}