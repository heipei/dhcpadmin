class PoolController < ApplicationController

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
    pool = (Machine.find :all).select{|m| m.active?}
    rooms = Room.find :all
    @dhcpd = Room.find :all

    shorewall_config = String.new
    shorewall_config += "##################\n"
    shorewall_config += "## DYNAMIC POOL ##\n"
    shorewall_config += "##################\n"

    pool.each do |m|
      shorewall_config += "eth1\t#{m.mac}\t# (#{m.creator}) #{m.comment}\n"
    end

    dhcpd_config = "##########################################################\n"
    dhcpd_config += "# Alania DHCPD-Config, generated on #{Time.now}\n"
    dhcpd_config += "##########################################################\n"
    dhcpd_config += <<-eos
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

    shorewall_config += "################\n"
    shorewall_config += "## DHCPD MACS ##\n"
    shorewall_config += "################\n"

    rooms.each do |m|
      dhcpd_config += "\thost #{m.dns}\t{ hardware ethernet #{m.mac};\t fixed-address #{m.ip}; }\n"
      shorewall_config += "eth1\t#{m.mac}\t# Host #{m.dns}\n"
    end
    dhcpd_config += "}\n"
    headers["Content-Type"] = "text/plain; charset=utf-8"
    render :text => "<pre>" + shorewall_config + "\n\n" + dhcpd_config + "</pre>", :status => :ok
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
