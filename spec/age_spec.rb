require 'rspec'
require_relative '../models/age'

describe 'age of empires tests' do
  #Los guerreros tienen estos parámetros por default: offensive_potential=20, energy=100, defensive_potential=10
  it 'vikingo ataca a atila' do
    atila= Warrior.new
    vikingo = Warrior.new 70

    vikingo.attack atila
    expect(atila.energy).to eq(40)
  end

  it 'espadachin ataca a atila' do
    atila= Warrior.new
    don_quijote = Swordsman.new(Sword.new(50))

    don_quijote.attack atila
    expect(atila.energy).to eq(40)
  end

  it 'atila ataca a vikingo pero no le hace danio' do
    atila= Warrior.new
    vikingo = Warrior.new 70

    atila.attack vikingo
    expect(atila.energy).to eq(100)
  end

  it 'Wall solo defiende' do
    wall = Wall.new
    vikingo = Warrior.new 70

    vikingo.attack(wall)
    expect(wall.energy).to eq(180)
    vikingo.attack(wall)
    expect(wall.energy).to eq(160)
  end

  it 'Wall no ataca' do
    wall = Wall.new
    don_quijote = Swordsman.new(Sword.new(40))
    #Esto es la manera sintáctica de decir que lo que se espera dentro de los {} del expect, lanza una exception.
    #Despues veremos que quieren decir los {}
    expect { wall.attack don_quijote }.to raise_error(NoMethodError)
  end

  it 'Misil no defiende' do
    misil = Misil.new
    don_quijote = Swordsman.new(Sword.new(40))
    expect { don_quijote.attack misil }.to raise_error(NoMethodError)
  end

  ######################

  it 'Attacker descansado pega doble' do
    atila = Warrior.new #(offensive_potential = 20, energy = 100, defensive_potential = 10)
    conan = Warrior.new

    atila.rest
    atila.attack conan

    # 100 - (20 * 2 - 10)
    expect(conan.energy).to eq(70)
  end

  it 'Attacker descansado ataca doble solo una vez por descanso' do
    atila = Warrior.new
    conan = Warrior.new
    heman = Warrior.new

    atila.rest
    atila.attack conan
    atila.attack heman

    # 100 - (20 - 10)
    expect(heman.energy).to eq(90)
  end

  it 'Defender descansado suma 10' do
    wall = Wall.new
    expect(wall.energy).to eq(200)

    wall.rest

    expect(wall.energy).to eq(210)
  end

  it 'Warrior descansa como Defender y como Attacker' do
    atila = Warrior.new #(offensive_potential = 20, energy = 100, defensive_potential = 10)
    conan = Warrior.new
    expect(atila.energy).to eq(100)

    atila.rest
    atila.attack conan

    expect(conan.energy).to eq(70)
    expect(atila.energy).to eq(110)
  end

  it 'kamikaze pierde su energy luego de attack' do
    kamikaze = Kamikaze.new #(offensive_potential = 250, energy = 100, defensive_potential = 10)
    wall = Wall.new #(defensive_potential = 50, energy = 200)

    kamikaze.attack(wall)

    expect(wall.energy).to eq(0)
    expect(kamikaze.energy).to eq(0)
  end

  it 'kamikaze descansa solo como attacker' do
    kamikaze = Kamikaze.new

    expect(kamikaze.offensive_potential).to eq(250)

    kamikaze.rest

    expect(kamikaze.energy).to eq(100)
    expect(kamikaze.offensive_potential).to eq(500)
  end

  ######################

  it('Squad descansador hace rest a sus guerreros que no estan descansados') do
    atila = Warrior.new
    vikingo = Warrior.new 70
    don_quijote = Swordsman.new(Sword.new(50))
    Squad.descansador([atila, vikingo])

    don_quijote.attack(vikingo)
    #Al ser atacado, el vikingo le avisa al ejercito. El vikingo no esta descansado luego de recibir el ataque
    expect(atila.energy).to eq(100) #Atila no descansa, porque esta descansado
    expect(vikingo.energy).to eq(50) #En un test anterior energy quedaba en 40, pero ahora como descanso queda en 50
    expect(vikingo.offensive_potential).to eq(140) #Ademas, su offensive_potential se duplica (para el proximo ataque)
  end

  it 'Squad cobarde se retira cuando sufre danio uno de sus guerreros' do
    atila = Warrior.new
    vikingo = Warrior.new 70
    squad = Squad.cobarde([atila])

    vikingo.attack(atila)

    expect(squad.retirado).to be(true)
  end
end
