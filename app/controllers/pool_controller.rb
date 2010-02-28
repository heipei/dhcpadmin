class PoolController < ApplicationController
  verify :method => :post, :only => :delete, :redirect_to => { :action => :index }

  in_place_edit_for :machine, :mac
  in_place_edit_for :machine, :comment

  def index
    @machines = (Machine.find :all)
  end

  def new
    @machine = Machine.new
  end

  def create
    @machine = Machine.new(params[:machine])
    if @machine.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
    @machine = Machine.find(params[:id])
  end

  def deactivate
    machine = Machine.find(params[:id])
    machine.active = false
    machine.save
    redirect_to :action => :index
  end

  def activate
    machine = Machine.find(params[:id])
    machine.active = true
    machine.save
    redirect_to :action => :index
  end

  def delete
    machine = Machine.find(params[:id])
    machine.destroy
    redirect_to :action => :index
  end

  def export
    shorewall = generate_shorewall
    dhcpd = generate_dhcpd

    f = File.new("#{RAILS_ROOT}/tools/generated/dhcpd.conf", "w+")
    f.write(dhcpd)
    f.close

    f = File.new("#{RAILS_ROOT}/tools/generated/shorewall/dynamic_maclist", "w+")
    f.write(shorewall)
    f.close

    dhcpd_ok = system("dhcpd -t -cf #{RAILS_ROOT}/tools/generated/dhcpd.conf 2> #{RAILS_ROOT}/tools/generated/dhcpd.log")
    if not dhcpd_ok
      dhcpd_error = File.open("#{RAILS_ROOT}/tools/generated/dhcpd.log", "r") {|f| f.read}
    end

    summary = "<h1>Summary</h1>"
    summary += "<h2 class=\"green\">dynamic_maclist OK (probably)</h2>"
    summary += (dhcpd_ok ? "<h2 class=\"green\">DHCPD.conf OK</h2>" : "<h2 class=\"red\">dhcpd.conf syntax errors</h2><pre>#{dhcpd_error}</pre>")

    headers["Content-Type"] = "text/plain; charset=utf-8"
    render :text => summary + "<h3>dynamic_maclist</h3><pre>" + shorewall + "</pre>" + "<h3>dhcpd.conf</h3><pre>" + dhcpd + "</pre>", :status => :ok
  end

  def generate_shorewall
    pool = (Machine.find :all, :order => :category).select{|m| m.active?}
    rooms = Room.find :all

    shorewall_config = String.new
    shorewall_config += "##################\n"
    shorewall_config += "## DYNAMIC POOL ##\n"
    shorewall_config += "##################\n"

    pool.each do |m|
      shorewall_config += "eth1\t#{m.mac}\t# (#{m.creator}) [#{m.category}] #{m.comment}\n"
    end

    shorewall_config += "\n"
    shorewall_config += "################\n"
    shorewall_config += "## DHCPD MACS ##\n"
    shorewall_config += "################\n"

    rooms.each do |m|
      shorewall_config += "eth1\t#{m.mac}\t# Host #{m.dns}\n"
    end

    return shorewall_config
  end

  def generate_dhcpd
    rooms = Room.find :all

    dhcpd_config = "##########################################################\n"
    dhcpd_config += "# Alania DHCPD-Config, generated on #{Time.now}\n"
    dhcpd_config += "##########################################################\n"
    dhcpd_config += <<-eos
ddns-update-style ad-hoc;
update-static-leases true;
default-lease-time 86400;
max-lease-time 86400;
authoritative;
log-facility daemon;

subnet 134.130.78.0 netmask 255.255.255.128 
{
	range 134.130.78.55 134.130.78.115;

	option domain-name "alania.rwth-aachen.de";
	option domain-name-servers 134.130.78.126;
	option routers 134.130.78.126;
	option broadcast-address 134.130.78.127;

eos

    rooms.each do |m|
      dhcpd_config += "\thost #{m.dns}\t{ hardware ethernet #{m.mac};\t fixed-address #{m.ip}; }\n"
    end
    dhcpd_config += "}\n"
    
    return dhcpd_config
  end

  def update
    @machine = Machine.find(params[:machine][:id])

    if @machine.update_attributes(params[:machine])
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
end
