package states;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import zero.flixel.states.sub.SubState;

class GameOver extends SubState {

    public function new() {
        var n = 4;
        var h = 144/n;
        super();
        for (i in 0...n) {
            var strip = new FlxSprite(0, i * h);
            strip.makeGraphic(1, h.ceil(), 0xFFFFFFFF);
            strip.color = 0xFFFF004D;
            strip.origin.x = 0;
            strip.scale.x = 0;
            FlxTween.tween(strip.scale, { x: 144 }, 0.3, { startDelay: i * 0.1 + 0.25, ease: FlxEase.quadOut });
            FlxTween.color(strip, 0.5, strip.color, 0xFFFFA300, { startDelay: i * 0.2 });
            add(strip);
        }
        new FlxTimer().start(n * 0.1 + 1.25, (_) -> FlxG.resetState());
    }

}