require "./warrior"

class Swordsman < Warrior
    attr_accessor :sword

    def offensive_potential
        self.sword.offensive_potential * super.offensive_potential
    end
end
