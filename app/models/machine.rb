class Machine < ActiveRecord::Base
 
  validates_presence_of :mac, :message => "darf nicht leer sein"

  HUMANIZED_ATTRIBUTES = {
    :mac => "MAC-Adresse",
    :comment => "Kommentar",
    :creator => "Verantwortlicher",
    :created_at => "Angelegt",
    :updated_at => "Geaendert"
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  MAC_FORMAT = /\A([0-9a-fA-F]{1,2}:){5}[0-9a-fA-F]{1,2}\z/

  #validates_presence_of :mac, :message => "darf nicht leer sein"
  validates_uniqueness_of :mac, :message => "ist schon eingetragen", :case_sensitive => false
  validates_format_of :mac, :with => MAC_FORMAT, :on => :create
  validates_format_of :mac, :with => MAC_FORMAT, :on => :update

  #validates_presence_of :comment, :message => "darf nicht leer sein"
  validates_length_of :comment, :minimum => 10
  #validates_presence_of :creator, :message => "darf nicht leer sein"
  validates_length_of :creator, :minimum => 4

  before_save :downcase_fields
  before_update :downcase_fields

  def downcase_fields
    self.mac = self.mac.downcase
    self.creator = self.creator.capitalize
  end

end
