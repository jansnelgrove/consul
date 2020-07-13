class AddTermsOfServiceToComments < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        add_column :comments, :terms_of_service, :boolean, default: false
      end

      dir.down do
        remove_column :comments, :terms_of_service, :boolean
      end
    end
  end
end
