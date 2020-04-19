package objects;

import flixel.FlxSprite;

class Spikes extends FlxSprite {

    public function new(x:Float, y:Float) {
        super(x, y + 4);
        loadGraphic(Images.spikes__png);
        this.make_anchored_hitbox(8, 4);
        PLAYSTATE.hazards.add(this);
        allowCollisions = 0x0100;
    }

}