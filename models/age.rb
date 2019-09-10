module Attacker

  attr_accessor :offensive_potential, :rested

  def attack(un_defender)
    if self.offensive_potential > un_defender.defensive_potential
      danio = self.offensive_potential - un_defender.defensive_potential
      un_defender.sufri_danio(danio)
    end
    self.rested = false
  end

  def offensive_potential
    self.rested ? @offensive_potential * 2 : @offensive_potential
  end

  def rest
    self.rested = true
  end

end

module Defender

  attr_accessor :defensive_potential, :energy

  def sufri_danio(danio)
    self.energy= self.energy - danio
  end

  def rest
    self.energy += 10
  end

end

class Warrior
  include Attacker
  alias_method :rest_attacker, :rest

  include Defender
  alias_method :rest_defender, :rest

  attr_accessor :squad

  def initialize(offensive_potential=20, energy=100, defensive_potential=10)
    self.offensive_potential = offensive_potential
    self.energy = energy
    self.defensive_potential = defensive_potential
  end

  def rest
    self.rest_attacker
    self.rest_defender
  end

  def lastimado
    self.squad.lastimado if self.squad
  end

  def sufri_danio(un_danio)
    super(un_danio)
    self.lastimado if cansado
  end

  def cansado
    self.energy <= 40
  end

end

class Swordsman < Warrior

  attr_accessor :sword

  #constructor
  def initialize(sword)
    super(20, 100, 2)
    self.sword= sword
  end

  def offensive_potential
    super() + self.sword.offensive_potential
  end
end

class Sword
  attr_accessor :offensive_potential

  def initialize(offensive_potential)
    self.offensive_potential= offensive_potential
  end
end

class Misil
  include Attacker

  def initialize(offensive_potential=200)
    self.offensive_potential = offensive_potential
  end
end

class Wall
  include Defender

  def initialize(defensive_potential= 50, energy = 200)
    self.defensive_potential = defensive_potential
    self.energy = energy
  end

end

class Kamikaze
  include Defender
  include Attacker

  def initialize(energy=100, defensive_potential=10)
    self.offensive_potential = 250
    self.energy = energy
    self.defensive_potential = defensive_potential
  end

  def attack(un_defender)
    super(un_defender)
    self.energy = 0
  end

end

class Squad

  attr_accessor :integrantes, :estrategia, :retirado

  def self.cobarde(integrantes)
    self.new(integrantes) { |squad|
      squad.retirate
    }
  end

  def self.descansador(integrantes)
    self.new(integrantes) { |squad|
      squad.rest
    }
  end

  def initialize(integrantes, &estrategia)
    self.integrantes = integrantes
    self.estrategia = estrategia
    self.integrantes.each { |integrante|
      integrante.squad = self
    }
  end

  def lastimado
    self.estrategia.call(self)
  end

  def rest
    cansados = self.integrantes.select { |integrante|
      integrante.cansado
    }
    cansados.each { |integrante|
      integrante.rest
    }
  end

  def retirate
    self.retirado = true
  end

end
