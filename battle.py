from random import randint


class Unit():
    def __init__(self, name, hp, attack, defense, speed, weapon):
        self.name = name
        self.hp = hp
        self.attack = attack
        self.defense = defense
        self.speed = speed
        self.weapon = weapon

    def battle(self, defender):
        modifier = self.attack - defender.defense
        if self.speed > defender.speed:
            first = self
            second = defender
        else:
            first = defender
            second = self

        attacks = max(1, first.speed / second.speed)
        counterattacks = max(1, second.speed / first.speed)
        print first.name, "attacks", attacks, "times!"
        print second.name, "attacks", counterattacks, "times!"
        while (attacks + counterattacks > 0):
            if attacks > 0:
                roll = roll_d6()
                if (roll == 6) or (roll + modifier >= 6):
                    second.hp -= first.weapon.damage
                    print first.name, "hits!", second.name, "takes", first.weapon.damage, "damage!"
                    print second.name, "has", second.hp, "HP left!"
                else:
                    print first.name, "misses!"
                attacks -= 1
            if counterattacks > 0:
                roll = roll_d6()
                if (roll == 6) or (roll + modifier >= 6):
                    first.hp -= second.weapon.damage
                    print second.name, "hits!", first.name, "takes", second.weapon.damage, "damage!"
                    print first.name, "has", first.hp, "HP left!"
                else:
                    print second.name, "misses!"
                counterattacks -= 1


class Weapon():
    def __init__(self, damage):
        self.damage = damage


def roll_d6():
    return randint(1, 6)


if (__name__ == '__main__') or (__name__ == 'main'):
    print "EPIC BATTLE"
    print "Roy (HP: 5, Atk: 3, Def: 4, Spd: 5, Weap: 2)"
    print "attacks"
    print "Becky (HP: 4, Atk: 5, Def: 2, Spd: 10, Weap: 2):"
    print ""
    roy = Unit("Roy", 5, 3, 4, 5, Weapon(2))
    becky = Unit("Becky", 4, 5, 2, 10, Weapon(2))
    roy.battle(becky)
