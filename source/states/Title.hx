package states;

import flixel.FlxState;

class Title extends FlxState {

    override function create() {
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
        bgColor = 0xFFFFA300;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        check_mouse();
    }

    function check_mouse() {
        if (FlxG.mouse.justPressed) FlxG.switchState(new PlayState());
    }

}