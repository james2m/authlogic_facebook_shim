class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.datetime  :created_at      
      t.datetime  :updated_at
      t.integer   :lock_version, :default => 0
      t.integer   :company_id
      t.string    :login
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :persistence_token
      t.string    :single_access_token
      t.string    :perishable_token
      t.string    :email
      t.string    :first_name
      t.string    :last_name
      t.integer   :login_count, :default => 0, :null => false
      t.integer   :failed_login_count, :default => 0, :null => false
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
      t.boolean   :active, :default => true
      t.boolean   :approved, :default => true
      t.boolean   :confirmed, :default => true
      t.string    :facebook_uid
    end
    
  end

  def self.down
    drop_table :users
  end
  
end
