class User < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  # :validatable, :recoverable
  devise  :database_authenticatable,
          :registerable,
          :rememberable,
          :trackable,
          :omniauthable,
          omniauth_providers: [:google_oauth2]

  has_many :tables_users, dependent: :destroy
  has_many :tables, through: :tables_users
  has_many :fields, through: :tables
  has_many :filters, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :mail_logs, dependent: :destroy
  has_many :prompts, dependent: :destroy

  validates :name, :email, presence:true
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

  # Retourne les emails des utilisateurs qui ont des tables en commun avec l'utilisateur, mais qui ne sont pas dans la table envoyée en paramètre
  def others(table)
    User.where.not(id: table.users.pluck(:id)).where(id: self.tables.map { |t| t.users.pluck(:id)}.flatten.uniq).pluck(:email)
  end

  def self.from_omniauth(auth)
    require "open-uri"

    if user = User.find_by(email: auth.info.email)
      user
    else
      find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.password_confirmation = user.password
        user.name = auth.info.name   # assuming the user model has a name
        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!

        user.save

        user
      end
    end
  end

  private

  def new_user_notification
    UserMailer.with(user: self).new_user_notification.deliver_now
  end

  def slug_candidates
    [SecureRandom.uuid]
  end

end
