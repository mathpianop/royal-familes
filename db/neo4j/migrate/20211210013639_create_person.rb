class CreatePerson < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Person, :uuid
  end

  def down
    drop_constraint :Person, :uuid
  end
end
