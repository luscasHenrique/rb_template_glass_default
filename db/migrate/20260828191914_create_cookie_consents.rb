class CreateCookieConsents < ActiveRecord::Migration[7.1]
  def change
    create_table :cookie_consents do |t|
      # Null: true porque visitantes anônimos (deslogados) também precisam consentir
      t.references :user, null: true, foreign_key: true
      
      t.string :session_hash, null: false, index: true
      t.string :ip_address, null: false
      
      # Granularidade exigida pela LGPD/GDPR
      t.boolean :analytics_accepted, default: false
      t.boolean :marketing_accepted, default: false
      t.boolean :necessary_accepted, default: true, null: false # Necessários não podem ser recusados
      
      t.timestamps
    end

    # Evita que a mesma sessão de visitante anônimo crie milhares de registros
    add_index :cookie_consents, [:session_hash, :user_id], unique: true
  end
end