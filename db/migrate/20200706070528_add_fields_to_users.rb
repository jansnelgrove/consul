class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        add_column :users, :postcode, :string
        add_column :users, :country, :string
      end

      dir.down do
        remove_column :users, :postcode, :string
        remove_column :users, :country, :string
      end
    end
  end
end
