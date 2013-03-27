class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :name, :password
  
  validates :password, presence: true, if: "hashed_password.blank?"
  
  validates :name, presence: true,
                      length: { minimum: 4, maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                        format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  
  has_many :micro_posts
  
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  before_save :encrypt_password
                
  def encrypt_password
    self.salt ||= Digest::SHA256.hexdigest("--#{Time.now.to_s}- -#{email}--")
    self.hashed_password = encrypt(password)
  end

  def encrypt(raw_password)
    Digest::SHA256.hexdigest("--#{salt}--#{raw_password}--")
  end
  
  def feed(paginate_options={page: 1})
    followed_user_ids = followed_users.map { |u| u.id }
    MicroPost.where('user_id = ? or user_id in (?)', id, followed_user_ids)
             .order('created_at DESC')
             .paginate(paginate_options)
  end
  
  def self.authenticate(email, plain_text_password)   
     user = find_by_email(email)
     return nil if user.nil?
     if user.hashed_password==user.encrypt(plain_text_password)
        return user
     else 
        return nil
     end
  end
  
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)    
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
            
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
end