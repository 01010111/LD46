package objects;

import zero.utilities.Timer;
import flixel.FlxSprite;

class Cannon extends FlxSprite {

    var timer:Float = 3;
    var fire_angle:Float;

    public function new(x:Float, y:Float, frame:Int) {
        super(x, y);
        loadGraphic(Images.cannon__png, true, 8, 8);
        animation.frameIndex = frame;
        fire_angle = [180, 225, 270, 315, 0][frame];
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if ((timer -= elapsed) > 0) return;
        timer = 3;
        fire();
    }

    function fire() {
        PLAYSTATE.cannonballs.fire({
            position: getMidpoint().place_on_circumference(fire_angle, 4),
            velocity: fire_angle.vector_from_angle(60).to_flxpoint()
        });
    }

}