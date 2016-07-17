class CreateSocialAccounts < ActiveRecord::Migration
  def change
    create_table :social_accounts do |t|
      t.string :token
      t.string :secret
      t.string :uid
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
