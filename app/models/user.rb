class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :validatable, :recoverable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :tables_users, dependent: :destroy
  has_many :tables, through: :tables_users
  has_many :fields, through: :tables

  validates :name, :email, :password, :password_confirmation, presence:true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create	

end
