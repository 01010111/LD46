package states;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.text.FlxText.FlxTextAlign;
import zero.flixel.ui.BitmapText;
import flixel.FlxState;

class WinScreen extends FlxState {

    override function create() {
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
        bgColor = 0xFFFFA300;

        var text = new BitmapText({
            charset: ' abcdefghijklmnopqrstuvwxyz01!@',
            graphic: Images.alphabet__png,
            letter_size: FlxPoint.get(8, 8),
            align: FlxTextAlign.CENTER,
            letter_spacing: -1,
            line_spacing: 2
        });
        text.text = 'thanks for playing!\n@x01010111';
        add(text);
        text.color = 0xFFFFA300;
        text.screenCenter();
        FlxTween.color(text, 0.2, 0xFFFFA300, 0xFFFF004D, { onComplete: (_) -> {
            FlxTween.color(text, 0.5, 0xFFFF004D, 0xFF5f574f);
        }});
        new FlxTimer().start(5, (_) -> {
            FlxG.camera.fade(0xFFFFA300, 1, false, () -> FlxG.resetGame());
        });
    }

}