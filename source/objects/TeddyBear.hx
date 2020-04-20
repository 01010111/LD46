package objects;

import flixel.FlxSprite;

class TeddyBear extends FlxSprite {

    public function new(x:Float, y:Float) {
        super(x + 4, y + 8, Images.teddy__png);
        this.make_anchored_hitbox(8, 8);
        PLAYSTATE.teddy = this;
    }

}