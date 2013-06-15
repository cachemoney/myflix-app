class AddFullNameToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :full_name, :string
  end
end
