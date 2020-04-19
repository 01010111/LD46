package objects;

import zero.flixel.ec.ParticleEmitter.Particle;

class Explosion extends Particle {

    public function new() {
        super();
        loadGraphic(Images.explosion__png, true, 32, 32);
        this.make_and_center_hitbox(0, 0);
        animation.add('play', [0,1,2,3,4,4,5,5,6,6,7,7], 24, false);
    }

    override function fire(options) {
        trace('explosion');
        super.fire(options);
        animation.play('play');
    }

    override function update(dt:Float) {
        super.update(dt);
        if (animation.finished) kill();
    }

}