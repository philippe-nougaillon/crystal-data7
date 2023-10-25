class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :validatable, :recoverable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :tables_users, dependent: :destroy
  has_many :tables, through: :tables_users
  has_many :fields, through: :tables
  has_many :filters

  validates :name, :email, :password, :password_confirmation, presence:true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create	

  after_create :new_user_notification

  def favorite_table
    if self.tables.where(show_on_startup_screen: true).present?
      self.tables.where(show_on_startup_screen: true).first
    else
      self.tables.last
    end
  end

  def compte_démo?
    self.id == 1
  end

  private

  def new_user_notification
    UserMailer.with(user: self).new_user_notification.deliver_now
  end

end
