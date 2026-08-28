class CreateUserAgreements < ActiveRecord::Migration[8.1]
  def change
    create_table :user_agreements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :policy_term, null: false, foreign_key: true
      t.string :ip_address
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
