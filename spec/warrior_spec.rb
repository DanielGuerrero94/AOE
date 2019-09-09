require "rspec"
require_relative "../models/warrior"

RSpec.describe Warrior, "#energy" do
	context "take damage" do
		it "takes damaga" do
			warrior = Warrior.new(10, 20, 20)
			expect(warrior.energy).to eq 10
		end
	end
end
