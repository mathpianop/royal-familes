require 'rails_helper'

RSpec.describe Person, type: :model do
  fixtures :people, :marriages

  describe "#confirm_no_children" do
    it "prevents destruction if person is a father" do
      people(:edward_iii).destroy
      expect(people(:edward_iii)).not_to be_destroyed
    end

    it "prevents destruction if person is a mother" do
      people(:philippa).destroy
      expect(people(:philippa)).not_to be_destroyed
    end

    it "allows destruction if person has no children" do
      people(:edward_v).destroy
      expect(people(:edward_v)).to be_destroyed
    end
  end

  
end