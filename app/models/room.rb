class Room < ActiveRecord::Base

  HUMANIZED_ATTRIBUTES = {
    :mac => "MAC-Adresse",
    :ip => "IP-Adresse",
    :dns => "Hostname",
    :comment => "Kommentar",
    :created_at => "Angelegt",
    :updated_at => "Geaendert"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  before_save :downcase_fields
  before_update :downcase_fields

  MAC_FORMAT = /\A([0-9a-fA-F]{1,2}:){5}[0-9a-fA-F]{1,2}\z/
  IP_FORMAT = /\A134.130.78.([1-9]){1}([0-9]{0,2})\z/
  DNS_FORMAT = /\A[a-zA-Z]{2,}-*[a-zA-Z0-9]{1,}(-[0-9]{1,}){0,}\z/

  validates_presence_of :mac, :message => "darf nicht leer sein"
  validates_format_of :mac, :with => MAC_FORMAT, :on => :create
  validates_format_of :mac, :with => MAC_FORMAT, :on => :update

  validates_presence_of :ip, :message => "darf nicht leer sein"
  validates_uniqueness_of :ip, :message => "ist bereits vergeben"
  validates_format_of :ip, :with => IP_FORMAT, :on => :create
  validates_format_of :ip, :with => IP_FORMAT, :on => :update
  validate :our_subnet

  def our_subnet
    errors.add(:ip, "nicht im Alanen-Subnetz (134.130.78.0/25)") unless [*1..128].include? self.ip.split(".").last.to_i
  end

  validates_presence_of :dns, :message => "darf nicht leer sein"
  validates_uniqueness_of :dns, :message => "ist bereits vergeben"
  validates_length_of :dns, :minimum => 3
  validates_format_of :dns, :with => DNS_FORMAT, :on => :create
  validates_format_of :dns, :with => DNS_FORMAT, :on => :update

private
  def downcase_fields
    self.mac = self.mac.downcase
    self.dns = self.dns.downcase
  end

end
