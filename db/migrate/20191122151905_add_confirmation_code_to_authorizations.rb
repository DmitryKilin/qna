class AddConfirmationCodeToAuthorizations < ActiveRecord::Migration[5.2]
  def change
    add_column :authorizations, :confirmation_code, :integer, default: nil
  end
end
