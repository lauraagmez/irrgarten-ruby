#encoding:utf-8
require_relative 'dice'
require_relative 'directions'
require_relative 'enumerados'
module Irrgarten
	class Labyrinth
		@@BLOCK_CHAR='X'
		@@EMPTY_CHAR='-'
		@@MONSTER_CHAR='M'
		@@COMBAT_CHAR='C'
		@@EXIT_CHAR='E'
		@@ROW=0
		@@COL=1
		

		def initialize (n_rows, n_cols, exit_row, exit_col)
			@n_rows=n_rows
			@n_cols=n_cols
			@exit_row=exit_row
			@exit_col=exit_col
			@labyrinth=Array.new(n_rows){Array.new(n_cols){@@EMPTY_CHAR}}
			@players=Array.new(n_rows){Array.new(n_cols){nil}}
			@monsters=Array.new(n_rows){Array.new(n_cols){nil}}
			@labyrinth[exit_row][exit_col]=@@EXIT_CHAR
		end
		def spread_players(players)
			old_row=-1
			old_col=-1
			players.each do |p|
				pos = self.random_empty_pos()
				m= put_player_2D(old_row, old_col, pos[@@ROW], pos[@@COL], p)
			end
		end
		def have_winner()
			@players[@exit_row][@exit_col]!=nil
		end
		def to_s()
			
			cell_format = 4
			laby = ""
			laby += "".ljust(cell_format) 
			
			#Indices del laberinto
			@n_cols.times do |j|
				laby += j.to_s.ljust(cell_format) 
			end
			laby += "\n"

			#Contenido del Laberinto
			@n_rows.times do |i|
				laby += i.to_s.ljust(cell_format) 

				@n_cols.times do |j|
					cell = ""
					
					if @labyrinth[i][j] == @@BLOCK_CHAR
						cell = @@BLOCK_CHAR
					elsif empty_pos(i, j)
						cell = @@EMPTY_CHAR
					elsif monster_pos(i, j)
						cell = @@MONSTER_CHAR
					elsif exit_pos(i, j)
						cell = @@EXIT_CHAR
					elsif combat_pos(i, j)
						cell = @@COMBAT_CHAR
					else
						cell = "P#{@labyrinth[i][j]}"
					end

					laby += cell.ljust(cell_format)
				end
				laby += "\n"
			end
			
			return laby

		end
		def add_monster(row, col, monster)
			if (pos_OK(row, col)&&empty_pos(row, col))
				monster.set_pos(row, col)
				@labyrinth[row][col]=@@MONSTER_CHAR
				@monsters[row][col]=monster
				
			end
		end
		def put_player (direction, player)
			old_row=player.get_row()
			old_col=player.get_col()
			new_pos=dir_2_pos(old_row, old_col, direction)
			monster=put_player_2D(old_row, old_col, new_pos[@@ROW], new_pos[@@COL], player)
			return monster
		end
		def add_block (orientation, start_row, start_col, length)
			inc_row=0
			inc_col=0
			if (orientation==Orientation::VERTICAL)
				inc_row=1
			else
				inc_col=1
			end
			row=start_row
			col=start_col
			while(pos_OK(row, col) && empty_pos(row, col) &&length>0)
				@labyrinth[row][col]=@@BLOCK_CHAR
				length=-1
				row+=inc_row
				col+=inc_col
			end
		end
		def valid_moves (row, col)
			output= Array.new()
			if (can_step_on(row+1, col))
				output.push(Directions::DOWN)
			end
			if (can_step_on(row-1, col))
				output.push(Directions::UP)
			end
			if (can_step_on(row, col+1))
				output.push(Directions::RIGHT)
			end
			if (can_step_on(row, col-1))
				output.push(Directions::LEFT)
			end
			return output
			
		end

		private
		
		def pos_OK (row, col)
			return (row>=0 && row<@n_rows) && (col>=0 && col<@n_cols)
		end
		def empty_pos(row, col)
        		return @labyrinth[row][col]==@@EMPTY_CHAR
		end
    		def monster_pos(row, col)
        		return @labyrinth[row][col]==@@MONSTER_CHAR 
  		end
		def exit_pos (row, col)
			return @labyrinth[row][col]==@@EXIT_CHAR
		end
		def combat_pos (row, col)
			return @labyrinth[row][col]==@@COMBAT_CHAR
		end
		def can_step_on(row, col)
			return pos_OK(row, col) && 
			(empty_pos(row, col)|| monster_pos(row, col)||exit_pos(row, col))
		end
		def update_old_pos(row, col)
			if (pos_OK(row, col))
				if (combat_pos(row, col))
					@labyrinth[row][col]=@@MONSTER_CHAR
				else
					@labyrinth[row][col]=@@EMPTY_CHAR
				end
			end
		end
		def dir_2_pos (row, col, direction)
			pos=[row, col]
			case direction
				when Directions::RIGHT
					pos[1]+=1 #Columna++
				when Directions::LEFT
					pos[1]-=1 #Columna--
				when Directions::UP
					pos[0]-=1 #Fila--
				when Directions::DOWN
					pos[0]+=1 #Fila++
			end

			return pos
		end
		def random_empty_pos
			begin
				row = Dice.random_pos(@n_rows);
				col = Dice.random_pos(@n_cols);
			end while (!empty_pos(row, col));
			pos = [row, col]

			return pos;
		end
		def put_player_2D (old_row, old_col, row, col, player)	
			output =nil
			if (can_step_on(row, col))
				if (pos_OK(old_row, old_col))
					p=@players[old_row][old_col]
					if (p==player)
						update_old_pos(old_row, old_col)
						@players[old_row][old_col]=nil
					end
				end
				if (monster_pos(row, col))
					@labyrinth[row][col]=@@COMBAT_CHAR
					output=@monsters[row][col]
				else
					number = player.get_number()
					@labyrinth[row][col]=number
				end
				@players[row][col]=player
				player.set_pos(row, col)
			end
			return output
		end
		
	end
end