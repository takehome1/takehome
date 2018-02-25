require_relative "plateau.rb"
require_relative "rover.rb"

class MarsRoverSimulator
  ROVER_COUNT = 2

  def initialize
    @rovers = []
  end

  def run_simulation(scenario=nil)
    setup_rovers(scenario)
    place_all_rovers
    move_all_rovers
  end

  private

  attr_reader :plateau, :rovers

  def setup_rovers(scenario)
    if scenario
      setup_test_rovers(scenario)
    else
      get_user_input
    end
  end

  def get_user_input
    puts "Welcome to Sam's Mars Rover Simulator!"

    puts "Please enter the dimensions of the plateau (e.g. Enter \"5 3\" for a 5x3 plateau):"
    current_user_input = STDIN.gets.chomp
    @plateau = Plateau.new(*current_user_input.split.map(&:to_i))

    ROVER_COUNT.times do |rover_number|
      rover_no = rover_number + 1
      puts "Please enter the position of Rover \##{rover_no} (e.g. Enter \"1 2 N\" to place the rover at position [1, 2], facing north):"
      current_user_input = STDIN.gets.chomp
      rover_position = current_user_input.split(" ").take(2).map(&:to_i)
      rover_direction = current_user_input.split(" ").last

      puts "Please enter movement instructions for Rover \##{rover_no} (e.g. Enter \"LMRM\" for the rover to turn left, move forward, turn right, and move forward):"
      current_user_input = STDIN.gets.chomp
      rover_instructions = current_user_input.split("")

      new_rover = Rover.new(
        position: rover_position,
        direction: rover_direction,
        instructions: rover_instructions,
      )

      @rovers << new_rover
    end
  end

  def setup_test_rovers(scenario)
    case scenario
    when :success
      instructions_2 = %w(M M R M M R M R R M)
    when :falls_off
      instructions_2 = %w(M M M)
    when :collision
      instructions_2 = %w(L L M M)
    end

    @plateau = Plateau.new(5, 5)

    rover_1 = Rover.new(
      position: [1, 2],
      direction: "N",
      instructions: %w(L M L M L M L M M),
    )
    @rovers << rover_1

    rover_2 = Rover.new(
      position: [3, 3],
      direction: "E",
      instructions: instructions_2,
    )
    @rovers << rover_2
  end

  def place_all_rovers
    rovers.each do |rover|
      plateau.set_occupied(rover.position)
    end
  end

  def move_all_rovers
    rovers.each_with_index do |rover, i|
      final_position = move_rover(rover.position, rover.direction, rover.instructions)
      puts "Rover #{i+1}'s ending position: #{final_position}"
    end
  end

  def move_rover(start_position, start_direction, instructions)
    old_x, old_y = start_position
    new_x, new_y = start_position
    current_direction = start_direction

    instructions.each do |instruction|
      changed_position = false

      if instruction == "M"
        changed_position = true

        case current_direction
        when "N"
          new_y += 1
        when "S"
          new_y -= 1
        when "E"
          new_x += 1
        when "W"
          new_x -= 1
        end
      elsif instruction == "L"
        case current_direction
        when "N"
          current_direction = "W"
        when "S"
          current_direction = "E"
        when "E"
          current_direction = "N"
        when "W"
          current_direction = "S"
        end
      elsif instruction == "R"
        case current_direction
        when "N"
          current_direction = "E"
        when "S"
          current_direction = "W"
        when "E"
          current_direction = "S"
        when "W"
          current_direction = "N"
        end
      end

      if changed_position
        plateau.unset_occupied([old_x, old_y])
        raise "invalid position #{[new_x, new_y]}" unless plateau.valid_position?([new_x, new_y])
        plateau.set_occupied([new_x, new_y])
        old_x, old_y = new_x, new_y
      end
    end

    "#{new_x} #{new_y} #{current_direction}"
  end
end
