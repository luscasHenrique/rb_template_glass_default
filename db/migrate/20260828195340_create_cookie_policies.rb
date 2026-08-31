class CreateCookiePolicies < ActiveRecord::Migration[7.1]
  def change
    create_table :cookie_policies do |t|
      t.string :version, null: false
      t.text :content, null: false
      t.boolean :active, default: false, null: false

      t.timestamps
    end

    # Índice essencial para performance, pois faremos queries constantes buscando a política ativa
    add_index :cookie_policies, :active
    add_index :cookie_policies, :version, unique: true
  end
end