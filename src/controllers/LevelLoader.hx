package controllers;

import en.Player;
import differ.shapes.Polygon;
import h2d.TileGroup;
import h2d.Tile;
import ogmo.Level;
import ogmo.Project;

class LevelLoader
{
    var camera:Camera;
    var game:Game;

    public function new(_camera:Camera, _game:Game)
    {
        camera = _camera;
        game = _game;
    }

    public function LoadLevel()
    {
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
                    game.mapCollisions.push(collision);
				}
            }
        }

        level.onEntityLayerLoaded = (entities, layer) -> 
		{
            for (entity in entities) 
            {
                if (entity.name == "player")
                {
                    game.player = new Player(camera, game, entity.x + layer.offsetX, entity.y + layer.offsetY - 4);
                }
			}
		}
 
        level.load();
    }
}