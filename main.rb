

require_relative 'directions'
require_relative 'game'
require_relative 'TextUI/textUI'
require_relative 'Controller/controller'



module Main

  class Main
	# 1. Incluir el modulo Irrgarten para acceder a Game sin prefijo.
    include Irrgarten
    
    # 2. Incluir el modulo Control (asumido) para acceder a Controller sin prefijo.
    include Control
    
    # 3. Incluir el modulo UI (asumido) para acceder a TextUI sin prefijo.
    include UI

		def self.main ()
			game = Game.new(2)
			view = TextUI.new
			controller = Controller.new(game, view)
			controller.play()
		end

  	end # class   

end # module   

Main::Main.main
