class Warrior
    attr_accessor :energy, :offensive_potential, :defensive_potential

    def initialize(energy, offensive_potential, defensive_potential)
	self.energy = energy
	self.offensive_potential = offensive_potential
	self.defensive_potential = defensive_potential
    end

    def attack(another_warrior)
        if(self.offensive_potential >= another_warrior.defensive_potential)
            damage = self.offensive_potential - another_warrior.defensive_potential
            another_warrior.take_damage(damage)
        end
    end

    def take_damage(damage)
        self.energy= self.energy - damage
    end
end
