#encoding:utf-8
require_relative 'Monster'

module Irrgarten
	class TestP2
		def self.prueba_monster
  			m=Monster.new("Myke", 3.2, 8.92)
			puts "M1 #{m.to_s}"
		end
		
		
		def self.main
			puts "PRUEBA DE LA CLASE MONSTER"
			prueba_monster
			
		end

	end


end

Irrgarten::TestP2.main if __FILE__== $0