#encoding:utf-8
module Irrgarten
	class Shield
		#Atributos de instancia accesibles desde cualquier metodo
		def initialize (protection, uses) #float, int
			@protection=protection
			@uses=uses
		end
		#Devuelve la intesidad (float) de la defensa
		def protect()
			salida=0.0
			if @uses >0 then
				@uses -= 1
				salida = @protection
			end
			salida 
		end
		def to_s ()
			protection = @protection.round(3)
			"S[#{protection}, #{@uses}]"
		end
		def discard()
			Dice.discard_element(@uses)
		end
	end

end