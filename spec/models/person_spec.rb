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

  describe "#child_ids=" do
    it "sets the appropriate parent id attribute on each corresponsing child" do
      expect(people(:unconnected_male).father_id).to eq(nil)
      expect(people(:unconnected_female).father_id).to eq(nil)
      people(:thomas_of_woodstock).child_ids = [people(:unconnected_male).id, people(:unconnected_female).id]
      people(:unconnected_female).reload
      people(:unconnected_male).reload
      expect(people(:unconnected_male).father_id).to eq(people(:thomas_of_woodstock).id)
      expect(people(:unconnected_female).father_id).to eq(people(:thomas_of_woodstock).id)
    end

    it "removes existing parent connections for records not in ids list" do
      expect(people(:edward_v).father_id).to eq(people(:edward_iv).id)
      people(:edward_iv).child_ids = []
      people(:edward_v).reload
      expect(people(:edward_v).father_id).to eq(nil)
    end
  end

  
end