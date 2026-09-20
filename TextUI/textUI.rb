
require 'io/console'
require_relative '../directions'

module UI

  class TextUI

    #https://gist.github.com/acook/4190379
    def read_char
      STDIN.echo = false
      STDIN.raw!
    
      input = STDIN.getc.chr
      if input == "\e" 
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.echo = true
      STDIN.cooked!
    
      return input
    end

    def next_move
      print "Where? "
      got_input = false
      while (!got_input)
        c = read_char
        case c
          when "\e[A"
            puts "UP ARROW"
            output = Irrgarten::Directions::UP
            got_input = true
          when "\e[B"
            puts "DOWN ARROW"
            output = Irrgarten::Directions::DOWN
            got_input = true
          when "\e[C"
            puts "RIGHT ARROW"
            output = Irrgarten::Directions::RIGHT
            got_input = true
          when "\e[D"
            puts "LEFT ARROW"
            output = Irrgarten::Directions::LEFT
            got_input = true
          when "\u0003"
            puts "CONTROL-C"
            got_input = true
            exit(1)
          else
            #Error
        end
      end
      output
    end

	def show_game(game_state)
    	puts
      #Laberinto
      puts game_state.get_labyrinth
   		#Jugadores y Monstruos
    	puts "Jugadores: \n #{game_state.get_players}"
    	puts "Monstruos: \n #{game_state.get_monsters}"

      
		  if !game_state.is_winner
        puts "Log:\n" + game_state.get_log + "\n"
        puts "Current player: Player##{game_state.get_current_player}\n"
      else
      	puts "\n Champion Player ##{game_state.get_current_player}!"
      end

   		puts
 	end

  end # class   

end # module   


