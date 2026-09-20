#encoding:utf-8
require_relative 'player'
require_relative 'monster'
require_relative 'game_state'
require_relative 'enumerados'
require_relative 'dice'
require_relative 'labyrinth'

module Irrgarten
	class Game
		@@MAX_ROUNDS=10
		
		#ATRIBUTOS PARA LA CONFIGURACION DEL LABERINTO
		@@NUM_COLS=5
		@@NUM_ROWS=5
		@@NUM_MONSTERS=4

        def initialize (n_players)
			
			#Player (char number, float intelligence, float strength)
			@players= Array.new
			for i in 0..(n_players-1)
				number = ('0'.ord + i).chr 
				@players << Player.new(number, Dice.random_intelligence, Dice.random_strength)
			end
			#Creamos los monstruos en la configuracion
			@monsters=Array.new
			
			#Jugador con el turno
			@current_player_index=Dice.who_starts(n_players)
			@current_player=@players[@current_player_index]
			
			
			#Labyrinth(int nRows, int nCols, int exitRow, int exitCol)
			exit_row=Dice.random_pos(@@NUM_ROWS)
			exit_col=Dice.random_pos(@@NUM_COLS)
			@labyrinth = Labyrinth.new(@@NUM_ROWS, @@NUM_COLS, exit_row, exit_col)
			@log=""
			configure_labyrinth()
			@labyrinth.spread_players(@players)
				
        	end
		def finished()
			return @labyrinth.have_winner()
		end
		def next_step(preferred_direction)
			@log=""
			if (!@current_player.dead())
				direction=actual_direction(preferred_direction)
				if (direction!=preferred_direction)
					log_player_no_orders()
				end
				monster=@labyrinth.put_player(direction, @current_player)
				if (monster==nil)
					log_no_monster()
				else
					winner=combat(monster)
					manage_reward(winner)
				end
			else
				manage_resurrection()
			end
	
			end_game=finished()
			if (!end_game)
				next_player()
			end
			
			return end_game
		end
		def get_game_state()
			
			lab=@labyrinth.to_s()
			play=""
			@players.each do |player|
				play += player.to_s + "\n"
			end
			mons=""
			@monsters.take(@@NUM_MONSTERS).each do |monster|
				mons += monster.to_s + "\n"
			end
			return GameState.new(lab, play, mons, @current_player_index, finished(), @log)
		end

		#METODOS PRIVADOS!!!
		private 
		def configure_labyrinth
			#Creamos monstruos
			(0..@@NUM_MONSTERS).each do |i|
				letter = ('A'.ord + i).chr
				name = "Monster#{letter}"
				@monsters<<Monster.new(name, Dice.random_intelligence, Dice.random_strength)
			end
			#Creamos bloques
			@labyrinth.add_block(Orientation::HORIZONTAL, 2, 2, 3)
			@labyrinth.add_block(Orientation::VERTICAL, 2, 4, 2)

			#Metemos los monstruso en el laberinto
			@labyrinth.add_monster(1, 3, @monsters[0])
			@labyrinth.add_monster(3, 2, @monsters[1])
			@labyrinth.add_monster(0, 4, @monsters[2])
			@labyrinth.add_monster(4, 0, @monsters[3])
		end
		def next_player()
			@current_player_index = (@current_player_index+1) % @players.size()
			@current_player = @players[@current_player_index]
		end
		def actual_direction(preferred_direction)
			current_row=@current_player.get_row()
			current_col=@current_player.get_col()
			valid_moves=@labyrinth.valid_moves(current_row, current_col)
			salida= @current_player.move(preferred_direction, valid_moves)
			return salida
		end
		def combat (monster)
			rounds=0
			winner=GameCharacter::PLAYER
			
			#1.Jugador ataca y monstruo se defiende
			lose=monster.defend(@current_player.attack())
			
			while !lose && (rounds<@@MAX_ROUNDS)
				winner=GameCharacter::MONSTER
				rounds+=1
				#2. Monstruo ataca y jugador se defiende
				lose=@current_player.defend(monster.attack())
				if (!lose) #Si el jugadro no ha perdido vuelve a atacar
					winner=GameCharacter::PLAYER
					lose=monster.defend(@current_player.attack())
				end
			end
			log_rounds(rounds, @@MAX_ROUNDS)
			return winner
		end
		def manage_reward(winner)
			if (winner==GameCharacter::PLAYER)
				@current_player.receive_reward()
				log_player_won()
			else
				log_monster_won()
			end
		end
		def manage_resurrection
			if (Dice.resurrect_player())
				@current_player.resurrect()
				log_resurrected()
			else
				log_player_skip_turn()
			end
		end
		def log_player_won
  			@log += "Player #{@current_player.get_number} won the combat!\n"
		end

		def log_monster_won
  			@log += "The monster won the combat\n"
		end

		def log_resurrected
  			@log += "Player #{@current_player.get_number} resurrected\n"
		end

		def log_player_skip_turn
 			@log += "Turn skipped! Player #{@current_player.get_number} is dead\n"
		end

		def log_player_no_orders
 			@log += "Player #{@current_player.get_number} did not follow the human instructions (action failed)\n"
		end

		def log_no_monster
  			@log += "Player #{@current_player.get_number} has moved to an empty cell or could not move)\n"
		end

		def log_rounds(rounds, max)
  			@log += "There has been #{rounds} out of #{max} combat rounds\n"
		end
							
	end
    

end