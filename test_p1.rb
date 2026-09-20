#encoding:utf-8
require_relative 'Enumerados'
require_relative 'Weapon'
require_relative 'Dice'
require_relative 'Shield'
module Irrgarten
	class TestP1
		def self.prueba_enumerados
  			puts "El personaje es: #{ GameCharacter::PLAYER}"
			puts "El personaje es: #{ GameCharacter::MONSTER}"
			puts "La dirección es: #{ Directions::UP}"
			puts "La dirección es: #{ Directions::DOWN}"
			puts "La dirección es: #{ Directions::LEFT}"
			puts "La dirección es: #{ Directions::RIGHT}"
			puts "La orientación es: #{ Orientation::VERTICAL}"
			puts "La orientación es: #{ Orientation::HORIZONTAL}"
		end
		
		def self.prueba_weapon
			w=Weapon.new(10, 3)
			puts "Instancia de la clase Weapon #{w.to_s}"
			for i in 0...5
				puts "Método: attack → Resultado: #{w.to_s}, #{w.attack}"
				if w.discard
  					puts "Método discard: Se descarta"
				else
  					puts "Método discard: No se descarta"
				end	
			end
			
		end
		
		def self.prueba_shield
			s= Shield.new(5.3, 5)
			puts "Instancia de la clase Shield #{s.to_s}"
			for i in 0...5
				puts "Método: protect → Resultado:  #{s.to_s}, #{s.protect}"
				if s.discard
  					puts "Método discard: Se descarta"
				else
  					puts "Método discard: No se descarta"
				end	
			end
		end
		
		#En la Clase Dice tengo atributos de clase @@variable y metodos de instancia
		#No hay problemas de acceso a las variables desde los metodos
		def self.prueba_dice
			puts "Método: random_pos(max) → Resultado: #{Dice.random_pos(10)}"
			puts "Método: who_starts(nplayer) → Resultado: #{Dice.who_starts(30)}"
			puts "Método: random_intelligence → Resultado: #{Dice.random_intelligence}"
			puts "Método: random_strength → Resultado: #{Dice.random_strength}"
			puts "Método: resurrect_player → Resultado: #{Dice.resurrect_player}"
			puts "Método: weapons_reward → Resultado: #{Dice.weapons_reward}"
			puts "Método: shields_reward → Resultado: #{Dice.shields_reward}"
			puts "Método: health_reward → Resultado: #{Dice.health_reward}"
			puts "Método: weapon_power → Resultado: #{Dice.weapon_power}"
			puts "Método: shield_power → Resultado: #{Dice.shield_power}"
			puts "Método: uses_left → Resultado: #{Dice.uses_left}"
			puts "Método: intensity(20) → Resultado: #{Dice.intensity(20)}"
			puts


			for  i in 0...100
				if Dice.discard_element(i)
                			puts "Metodo discard_element: Se descarta"
            			else 
               				puts "Metodo discard_element: No se descarta"
				end
			end
		end
		
		def self.main
			puts "PRUEBA DE LOS ENUMERADOS"
			prueba_enumerados
			puts
			puts "PRUEBA DE LA CLASE WEAPON"
			prueba_weapon
			puts
			puts "PRUEBA DE LA CLASE SHIELD"
			prueba_shield
			puts
			puts "PRUEBA DE LA CLASE DICE"
			prueba_dice
			puts
			
		end

	end


end

Irrgarten::TestP1.main if __FILE__== $0