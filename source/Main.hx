package;

import openfl.display.Sprite;
import flixel.FlxGame;
import zero.utilities.ECS;
import zero.utilities.Timer;
import zero.utilities.SyncedSin;
import zero.flixel.input.FamiController;
#if PIXEL_PERFECT
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
#end

class Main extends Sprite
{
	static var WIDTH:Int = 144;
	static var HEIGHT:Int = 144;

	public function new()
	{
		stage.color = 0x222034;
		super();
		addChild(new FlxGame(WIDTH, HEIGHT, states.Title, 1, 60, 60, true));
		((?dt) -> {
			ECS.tick(dt);
			Timer.update(dt);
			SyncedSin.update(dt);
			FamiController.update(dt);
		}).listen('preupdate');
		#if PIXEL_PERFECT
		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.resizeWindow(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		#end
	}
}