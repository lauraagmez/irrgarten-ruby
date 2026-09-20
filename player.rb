#encoding:utf-8
require_relative 'dice'
require_relative 'weapon'
require_relative 'shield'


module Irrgarten
	class Player
		#Atributos de clase porque necesito acceder a ellos
		@@MAX_WEAPONS=2
		@@MAX_SHIELDS=3
		@@INITIAL_HEALTH=10
		@@HITS2LOSE=3
		@@OUT_LABYRINTH=-1
		
		def initialize (number, intelligence, strength)
			@number=number
			@intelligence=intelligence
			@strength=strength
			@name="Player ##{@number}"
			@health=@@INITIAL_HEALTH
			@consecutive_hits=0
			@shields = Array.new()
			@weapons= Array.new()
			@row=@@OUT_LABYRINTH
			@col=@@OUT_LABYRINTH
			
		end
		def resurrect()
			@health=@@INITIAL_HEALTH
			@@consecutive_hits=0
			@weapons.clear
			@shields.clear
		end
		def get_row()
			@row
		end
		def get_col()
			@col
		end
		def get_number()
			@number
		end
		def set_pos(row, col)
			@row=row
			@col=col
		end
		def dead ()
			if (@health == 0)
				return true
			else
				return false
			end
		end
		def move (direction, valid_moves)
			size=valid_moves.length()
			contained = valid_moves.include?(direction)
			if (size>0 && !contained)
				salida=valid_moves[0]
			else
				salida=direction
			end
			salida
		end
		def attack()
			@strength+sum_weapons()
		end
		def defend(received_attack)
			manage_hit(received_attack)
		end
		def receive_reward()
			w_reward= Dice.weapons_reward
			s_reward= Dice.shields_reward

			w_reward.times do
				receive_weapon (self.new_weapon)
			end
			s_reward.times do
				receive_shield(self.new_shield)
			end
			@health += Dice.health_reward
		end
		def to_s()
			w = ""		
			for i in 0...(@weapons.length) do
				w += @weapons[i].to_s
				w += ", " unless i == (@weapons.length() - 1)
			end

			s = ""
			for i in 0...(@shields.length) do
				s += @shields[i].to_s
				s += ", " unless i == (@shields.length() - 1)
			end

			# Redondeamos los floats para mejorar la legibilidad 
			intelligence = @intelligence.round(3)
			strength = @strength.round(3)
			
			output = "#{@name}: Intelligence: #{intelligence}, Strength: #{strength}, Health: #{@health}" + 
					", Consecutive Hits: #{@consecutive_hits}"
			
			output += "\n" +
					"Weapons: " + w + "\n" + 
					"Shields: " + s + "\n"
			
			return output
		end

		#METODOS PRIVADOS:

		private

		def receive_weapon(w)
			@weapons.delete_if{|wi| wi.discard()}
			if @weapons.length() < @@MAX_WEAPONS
				@weapons.push(w)
			end
		end
		def receive_shield(s)
			@shields.delete_if{|si| si.discard()}
			if @shields.length() < @@MAX_SHIELDS
				@shields.push(s)
			end
		end
		def new_weapon()
			Weapon.new(Dice.weapon_power(), Dice.uses_left())
			
		end
		def new_shield()
			Shield.new(Dice.shield_power(), Dice.uses_left())
		end
		def sum_weapons()
			salida=0.0
			for i in 0..@weapons.length()-1
				salida = salida + @weapons[i].attack
			end
			salida
		end
		def sum_shields()
			salida=0.0
			for i in 0..@shields.length()-1
				salida = salida + @shields[i].protect
			end
			salida
		end
		def defensive_energy()
			@intelligence+sum_shields()
		end
		def manage_hit (received_attack)
			if defensive_energy < received_attack
				got_wounded()
				inc_consecutive_hits()
			else
				reset_hits()
			end
			if ((@consecutive_hits == @@HITS2LOSE) || dead())
				reset_hits()
				lose=true
			else
				lose=false
			end
			return lose
		end
		def reset_hits()
			@consecutive_hits=0
		end
		def got_wounded()
			@health-=1
		end
		def inc_consecutive_hits()
			@consecutive_hits+=1
		end
	end
end