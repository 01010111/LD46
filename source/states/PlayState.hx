package states;

import zero.flixel.ec.ParticleEmitter;
import objects.*;
import flixel.util.FlxTimer;
import zero.utilities.Vec2;
import flixel.math.FlxRect;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import zero.flixel.states.State;

class PlayState extends State
{

	public static var instance:PlayState;
	
	public static var level = 1;

	public function new() {
		super();
		instance = this;
	}
	
	public var objects:FlxTypedGroup<FlxObject> = new FlxTypedGroup();
	public var geom:FlxGroup = new FlxGroup();
	public var collidables = new FlxGroup();
	public var hazards = new FlxGroup();
	public var projectiles = new FlxGroup();
	public var fleshies = new FlxGroup();
	public var cannonballs = new ParticleEmitter(() -> new Cannonball());
	public var explosions = new ParticleEmitter(() -> new Explosion());
	public var puffs = new ParticleEmitter(() -> new Puff());
	
	var tilemaps:Map<Int, FlxTilemap> = [];
	var overlays:Map<Int, FlxSprite> = [];
	var moving:Bool = false;
	
	override function create() {
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
		bgColor = 0xFF222034;
		var pack = FlxOgmoUtils.get_ogmo_package(Data.ld46__ogmo, 'assets/data/$level.json');
		make_tiles(pack);
		make_objects(pack);
		make_overlays();
		add(explosions);
		openSubState(new Intro());
	}

	function make_tiles(pack:OgmoPackage) {
		var level_data = pack.level.get_tile_layer('tiles').data2D;
		var tiles = [for (j in 0...3) for (i in 0...3) level_data.chunk(i * 6, j * 6, 6, 6)];
		for (set in tiles) {
			var remove = true;
			for (row in set) for (v in row) if (v > 0) remove = false;
			if (remove) tiles.remove(set);
		}
		var p = 0;
		for (set in tiles) {
			var tilemap = new FlxTilemap();
			tilemap.useScaleHack = false;
			tilemap.loadMapFrom2DArray(set, Images.tiles__png, 8, 8, null, 0, 0, 32);
			for (i in 24...32) tilemap.setTileProperties(i, 0x0100);
			tilemap.setPosition((p % 3) * 48, (p / 3).floor() * 48);
			add(tilemap);
			geom.add(tilemap);
			tilemaps.set(p, tilemap);
			p++;
		}
	}

	function make_objects(pack:OgmoPackage) {
		pack.level.get_entity_layer('entities').load_entities(load_entities);
		add(objects);
		add(cannonballs);
		add(puffs);
	}

	function load_entities(data:EntityData) {
		switch (data.name) {
			case 'baby': objects.add(new Baby(data.x, data.y));
			case 'spikes': objects.add(new Spikes(data.x, data.y));
			case 'block': objects.add(new Block(data.x, data.y, data.values.direction));
			case 'cannon': objects.add(new Cannon(data.x, data.y, data.values.frame));
		}
	}

	function make_overlays() {
		for (i in 0...9) {
			if (!tilemaps.exists(i)) continue;
			var overlay = new FlxSprite((i % 3) * 48, (i / 3).floor() * 48, Images.overlay__png);
			overlays.set(i, overlay);
			add(overlay);
		}
	}

	override function update(e:Float) {
		super.update(e);
		if (moving) return;
		check_mouse();
		FlxG.collide(geom, collidables);
		FlxG.collide(geom, projectiles, (a, b) -> b.kill());
		FlxG.collide(fleshies, projectiles, (a, b) -> {
			a.kill();
			b.kill();
		});
		FlxG.collide(fleshies, hazards, (a, b) -> a.kill());
	}

	function win() {
		level++;
		openSubState(new states.NextStage(level >= 1 ? WinScreen : PlayState));
	}
	
	public function gameover() {
		add(new FlxSprite(0, 0, Images.x__png));
		openSubState(new states.GameOver());
	}

	function check_mouse() {
		if (FlxG.mouse.justPressed && FlxG.mouse.x > 8 && FlxG.mouse.x < 152) {
			var x = FlxG.mouse.x.map(8, 152, 0, 3).floor();
			var y = FlxG.mouse.y.map(0, 144, 0, 3).floor();
			var pos = x + y * 3;
			var tilemap = tilemaps[pos];
			if (tilemap == null) return;
			var empty_pos = get_empty_neighbor(x + y * 3);
			if (empty_pos == null) return;
			move_to_pos(pos, empty_pos);
		}
	}

	function get_tilemap(x:Int, y:Int):Null<FlxTilemap> {
		for (pos => tilemap in tilemaps) if (x + y * 3 == pos) return tilemap;
		return null;
	}

	function get_empty_neighbor(pos:Int):Null<Int> {
		var x = pos % 3;
		var y = (pos / 3).floor();
		if (y > 0 && !tilemaps.exists(pos - 3)) return pos - 3;
		if (y < 2 && !tilemaps.exists(pos + 3)) return pos + 3;
		if (x > 0 && !tilemaps.exists(pos - 1)) return pos - 1;
		if (x < 2 && !tilemaps.exists(pos + 1)) return pos + 1;
		return null;
	}

	function move_to_pos(last_pos:Int, new_pos:Int) {
		var tilemap = tilemaps[last_pos];
		var overlay = overlays[last_pos];

		tilemaps.remove(last_pos);
		tilemaps.set(new_pos, tilemap);
		overlays.remove(last_pos);
		overlays.set(new_pos, overlay);
		
		var x = new_pos % 3 * 48;
		var y = (new_pos / 3).floor() * 48;

		var diff = Vec2.get(x - tilemap.x, y - tilemap.y);
		FlxTween.tween(tilemap, { x: x, y: y }, 0.1);
		FlxTween.tween(overlay, { x: x, y: y }, 0.1);
		for (object in get_objects_in_pos(last_pos)) FlxTween.tween(object, { x: object.x + diff.x, y: object.y + diff.y }, 0.1);

		moving = true;
		for (object in objects) object.active = false;
		new FlxTimer().start(0.1, (_) -> {
			for (object in objects) object.active = true;
			moving = false;
		});
	}

	function get_objects_in_pos(pos:Int):Array<FlxObject> {
		var out = [];
		var rect = FlxRect.get((pos % 3) * 48, (pos / 3).floor() * 48, 48, 48);
		for (object in objects) if (object.getMidpoint().inRect(rect)) out.push(object);
		return out;
	}

}

typedef IP = {
	x:Int,
	y:Int,
}