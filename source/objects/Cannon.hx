package objects;

import zero.utilities.Timer;
import flixel.FlxSprite;

class Cannon extends FlxSprite {

    var timer:Float;
    var fire_angle:Float;
    static var num = 0;

    public function new(x:Float, y:Float, frame:Int) {
        super(x, y);
        loadGraphic(Images.cannon__png, true, 8, 8);
        animation.frameIndex = frame;
        fire_angle = [180, 225, 270, 315, 0][frame];
        timer = 3 + num++ % 3;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if ((timer -= elapsed) > 0) return;
        timer = 3;
        fire();
    }

    function fire() {
        FlxG.sound.play(Audio.shoot__mp3);
        PLAYSTATE.cannonballs.fire({
            position: getMidpoint().place_on_circumference(fire_angle, 4),
            velocity: fire_angle.vector_from_angle(60).to_flxpoint()
        });
    }

}