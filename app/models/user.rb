class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :places
  has_many :pins
  has_many :plan_users
  has_many :plans, through: :plan_users


  #FaceBook用
def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  user = User.where(provider: auth.provider, uid: auth.uid).first

  unless user
    exist_email_user =  User.where(email: auth.info.email).first
    if exist_email_user
      exist_email_user.provider = auth.provider
      exist_email_user.uid = auth.uid
      exist_email_user.save
      return exist_email_user
    else

      if auth.info.email.nil?
        user = User.new(name: auth.extra.raw_info.name, provider: auth.provider, uid: auth.uid, email: User.create_unique_email, password: Devise.friendly_token[0,20])
        #user.skip_confirmation!
        user.save(validate: false)
      else
        user = User.new(name: auth.extra.raw_info.name, provider: auth.provider, uid: auth.uid, email: auth.info.email, password: Devise.friendly_token[0,20])
        #user.skip_confirmation!
        user.save(validate: false)
      end
    end
  end
  user
end


  private

  #ランダムな文字列を生成
  def self.create_unique_string
    SecureRandom.uuid
  end

  # eamilaが拒否された用にランダムなEmailアドレス生成
  def self.create_unique_email
    User.create_unique_string + "@example.com"
  end


end
