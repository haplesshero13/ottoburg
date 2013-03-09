##
# Roll a d6.
#
def roll_d6
  1 + rand(6)
end

##
# This is where you define units that do battle.
#
# A unit generally starts at level 1 and gains in experience as it does battle.
class Unit
  attr_accessor :name, :maxhp, :level, :attack, :defense, :skill, :speed, :weapon, :damage

  ##
  # Create a new Unit and define its stats.
  #
  def initialize(name, maxhp, level, attack, defense, skill, speed, weapon)
    @name = name
    @maxhp = maxhp
    @level = level
    @attack = attack
    @defense = defense
    @skill = skill
    @speed = speed
    @weapon = weapon
    @damage = 0
  end

  ##
  # Calculate the damage dealt by attacker to defender.
  #
  #   Defense = Defense + Terrain Bonus
  #
  #   Power = Attack + Weapon Power
  #
  #   Damage = max(0, Power (attacker) - Defense (defender))
  #
  def self.damage(attacker, defender)
    damage = attacker.attack + attacker.weapon.power - defender.defense
    puts "Damage: #{attacker.attack} + #{attacker.weapon.power} - #{defender.defense} = #{damage}"
    [0, damage].max
  end

  ##
  # Returns maxhp - damage.
  #
  def hp
    @maxhp - @damage
  end

  ##
  # Returns whether the Unit is alive (has more than 0 HP).
  #
  def alive?
    self.hp > 0
  end

  ##
  # Returns whether the Unit is dead (has at most 0 HP).
  #
  def dead?
    not self.alive?
  end

  ##
  # Returns whether the Unit hits the defending Unit.
  #
  # A hit always occurs on a roll of 6 and never on a 1.
  # 
  #   Hit Rate = Weapon Accuracy + Weapon Skill (attacker)
  #
  #   Evasion Rate = Speed + Terrain Bonus
  #
  #   Hit = d6 + Hit Rate (Attacker) - Evade (Defender) >= 4
  #
  def hits?(defender)
    roll = roll_d6()
    total = roll + @skill + @weapon.accuracy - defender.speed
    puts "Roll to hit: #{roll} + #{@skill} + #{@weapon.accuracy} - #{defender.speed} = #{total}"
    (roll == 6 or total >= 4) and roll != 1
  end

  ##
  # Calculates damage based on the damage formula.
  #
  # A battler hits twice if s/he has at least 4 greater speed than the other.
  #
  #   A attacks, B attacks, A attacks (if A initiated the battle).
  #   or
  #   B attacks, A attacks, A attacks (if B initiated the battle).
  #   
  # A hit always occurs on a roll of 6 and never on a 1.
  # 
  #   Hit Rate = Weapon Accuracy + Weapon Skill (attacker)
  #
  #   Evasion Rate = Speed + Terrain Bonus
  #
  #   Hit = d6 + Hit Rate (attacker) - Evade (defender) >= 4
  #
  # Physical attacks:
  #
  #   Defense = Defense + Terrain Bonus
  #
  #   Power = Attack + Weapon Power
  #
  #   Damage = max(0, Power (attacker) - Defense (defender))
  #
  def battle(defender)
    raise "#{@name} is dead and cannot do battle!" if self.dead?
    raise "#{defender.name} is dead and cannot be attacked!" if defender.dead?
    modifier = @attack - defender.defense

    puts "#{@name} attacks #{defender.name}!"

    if self.alive? and defender.alive?
      if self.hits?(defender)
      damage = Unit.damage(self, defender)
      defender.damage += damage
      puts "#{self.name} hits! #{defender.name} takes #{damage} damage!"
      puts "#{defender.name} dies!" if defender.dead?
      else
        puts "#{self.name} misses!"
      end
    end

    if self.alive? and defender.alive? 
      if defender.hits?(self)
        damage = Unit.damage(defender, self)
        @damage += damage
        puts "#{defender.name} hits! #{self.name} takes #{damage} damage!"
        puts "#{self.name} dies!" unless self.alive?
      else
        puts "#{defender.name} misses!"
      end
    end

    if self.alive? and defender.alive? and @speed - defender.speed > 3
      if self.hits?(defender)
        damage = Unit.damage(self, defender)
        defender.damage += damage
        puts "#{self.name} hits! #{defender.name} takes #{damage} damage!"
        puts "#{defender.name} dies!" if defender.dead?
      else
        puts "#{self.name} misses!"
      end
    end

    if self.alive? and defender.alive? and defender.speed - @speed > 3 
      if defender.hits?(self)
        damage = Unit.damage(defender, self)
        @damage += damage
        puts "#{defender.name} hits! #{self.name} takes #{damage} damage!"
        puts "#{self.name} dies!" unless self.alive?
      else
        puts "#{defender.name} misses!"
      end
    end

  end
end

class Weapon
  attr_accessor :power, :accuracy
  def initialize(power, accuracy)
    @power = power
    @accuracy = accuracy
  end
end

if __FILE__ == $0
  puts "EPIC BATTLE"
  puts "Ottoman Janissary with Axe (HP: 5, Lvl: 1, Atk: 3, Def: 4, Skill: 4, Spd: 5, Weap: 3,1)"
  puts "attacks"
  puts "Tercio Swordsman with Sword (HP: 4, Lvl: 1, Atk: 4, Def: 4, Skill: 4, Spd: 6, Weap: 2,2):"
  puts
  janissary = Unit.new("Ottoman Janissary", 5, 1, 3, 4, 4, 5, Weapon.new(3, 1))
  tercio = Unit.new("Tercio Swordsman", 4, 1, 4, 3, 4, 6, Weapon.new(2, 2))
  janissary.battle(tercio)
  puts
  tercio.battle(janissary)
  puts
  janissary.battle(tercio)
  puts
  tercio.battle(janissary)
end
