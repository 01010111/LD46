package objects;

import flixel.math.FlxRect;
import flixel.FlxObject;
import flixel.FlxSprite;

class Baby extends FlxSprite {

    public static var i:Baby;

    public function new(x:Float, y:Float) {
        i = this;
        super(x, y);
        loadGraphic(Images.baby__png, true, 16, 16);
        animation.add('walk', [0, 1, 2, 3, 4, 5], 8);
        animation.add('fall', [6, 7, 8, 9, 10, 11], 16);
        this.make_anchored_hitbox(6, 6);
        this.set_facing_flip_horizontal();
        facing = FlxObject.RIGHT;
        acceleration.y = 200;
        clipRect = FlxRect.get(2, 2, 12, 14);
        PLAYSTATE.collidables.add(this);
        PLAYSTATE.fleshies.add(this);
        PLAYSTATE.baby = this;
    }

    override function update(elapsed:Float) {
        if (justTouched(FlxObject.FLOOR)) FlxG.sound.play(Audio.hit__mp3);
        if (justTouched(FlxObject.LEFT)) facing = FlxObject.RIGHT;
        if (justTouched(FlxObject.RIGHT)) facing = FlxObject.LEFT;
        velocity.x = 0;
        if (isTouching(FlxObject.FLOOR)) velocity.x = facing == FlxObject.RIGHT ? 12 : -12;
        isTouching(FlxObject.FLOOR) ? animation.play('walk') : animation.play('fall');
        super.update(elapsed);
        if (x < 4) facing = FlxObject.RIGHT;
        if (x > 134) facing = FlxObject.LEFT;
        if (y > 156) kill();
    }

    override function kill() {
        //super.kill();
        PLAYSTATE.gameover();
    }

}