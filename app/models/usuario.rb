class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:facebook, :twitter]

  def email_required?
    false
  end

#=begin
  validates :username, presence: true, uniqueness: true, 
  					length: {in: 5..20, too_short: "Tiene que tener al menos 5 caracteres", too_long: "Máximo 20 caracteres"},
  					format: {with: /([A-Za-z0-9\-\_]+)/, message: "Username puede sólo contener letras, números y guiones"}
#=end

 #validate :validacion_personalizada, on: :create

  def self.find_or_create_by_omniauth(auth)
  	usuario = Usuario.where(provider: auth[:provider], uid: auth[:uid]).first

  	unless usuario
  		usuario = Usuario.create(
  			nombre: auth[:nombre],
  			apellido: auth[:apellido],
  			username: auth[:username],
  			email: "",
  			uid: auth[:uid],
  			provider: auth[:provider],
  			password: Devise.friendly_token[0,20]
  		)
  	end
    usuario  	
  end
=begin  
  private
  def validacion_personalizada
  	if true

  	else
  		errors.add(:username, "Tu username no es valido")
  	end
  end
=end
end

