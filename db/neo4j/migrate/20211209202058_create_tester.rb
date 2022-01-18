class CreateTester < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Tester, :uuid
  end

  def down
    drop_constraint :Tester, :uuid
  end
end
