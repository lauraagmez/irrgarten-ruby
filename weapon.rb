#encoding:utf-8
module Irrgarten
	class Weapon
		def initialize (power, uses) #float, int
			@power=power
			@uses=uses
		end
		def attack()
			salida=0.0
			if @uses >0 then
				@uses -= 1
				salida = @power
			end
			salida #No podemos ahorrarnos esta linea porque puede que no entre en el then y devuelva null
		end
		def to_s ()
			power=@power.round(3)
			"W[#{power}, #{@uses}]"
		end
		def discard()
			Dice.discard_element(@uses) 
		end
	end

end