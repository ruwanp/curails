class MicroPost < ActiveRecord::Base
  attr_accessible :content, :user_id
  
  belongs_to:user
  
  validates :user_id, presence: true

  
  validates :content, presence: true,
                      length: { minimum: 5, maximum: 140 }
                      
  after_create :send_mentions_email
  
  def send_mentions_email
  
    mentions.each do |mentioned_user|
      UserMailer.mentioned(self, mentioned_user).deliver
    end
    
        
  end
                      
    def mentions
    results = []
    content.scan(/@[^@]+@/) do |match|
      name = match[1..match.length - 2]
      mentioned_user=User.find_by_name(name)
      
      if(mentioned_user && mentioned_user!=user)
        results<<mentioned_user
      end
      # Write some code to look up a user by name; if the result
      # is non-nil, then add them to the results array. You should also 
      # check that they aren't @mentioning themselves
      # (remember you can use the '<<' operator to add to an array)
      
    end

    results
  end

end
