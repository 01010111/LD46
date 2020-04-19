package objects;

import flixel.util.FlxTimer;
import zero.flixel.ec.ParticleEmitter.Particle;

class Puff extends Particle {

    public function new() {
        super();
        loadGraphic(Images.puff__png, true, 16, 16);
        this.make_and_center_hitbox(0, 0);
        animation.add('play', [0,1,2,3,3,4,4,5,5], 30, false);
    }

    override function fire(options) {
        trace('puff');
        super.fire(options);
        animation.play('play');
    }

    override function update(dt:Float) {
        super.update(dt);
        if (animation.finished) kill();
    }

    override function kill() {
        trace('killed');
        super.kill();
    }

}