#encoding:utf-8
module Irrgarten
	class Monster
		@@INITIAL_HEALTH=5
		@@OUT_LABYRINTH=-1
 		@@row=@@OUT_LABYRINTH
		@@col=@@OUT_LABYRINTH

		def initialize (name, intelligence, strength)
			@name=name
			@intelligence=intelligence
			@strength=strength
			@health=@@INITIAL_HEALTH
		end
		def dead()
			if (@health==0)
				return true
			else
				return false
			end
		end
		def attack()
			Dice.intensity(@strength)
		end
		def defend(received_attack)
			is_dead =dead()
			if (!is_dead)
				defensive_energy=Dice.intensity(@intelligence)
				if (defensive_energy<received_attack)
					got_wounded()
					is_dead=dead()
				end
			end
			return is_dead
		end
		def set_pos(row, col)
			@row=row
			@col=col
		end
		def to_s()
			intelligence = @intelligence.round(3)
			strength = @strength.round(3)
			return "#{@name}: Intelligence: #{intelligence}, Strength: #{strength}, Health: #{@health}"
			
		end
		def got_wounded()
			@health-=1
		end
	end
end