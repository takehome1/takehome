require "mars_rover_simulator"

describe MarsRoverSimulator do
  it "moves rovers to their expected positions" do
    expect do
      MarsRoverSimulator.new.run_simulation(:success)
    end.to output(
      "Rover 1's ending position: 1 3 N\nRover 2's ending position: 5 1 E\n"
    ).to_stdout
  end

  describe "when a rover would run off the edge of the plateau" do
    it "raises an error" do
      expect do
        MarsRoverSimulator.new.run_simulation(:falls_off)
      end.to raise_error(
        "invalid position [6, 3]"
      )
    end
  end

  describe "when one rover would collide with the other" do
    it "raises an error" do
      expect do
        MarsRoverSimulator.new.run_simulation(:collision)
      end.to raise_error(
        "invalid position [1, 3]"
      )
    end
  end
end
