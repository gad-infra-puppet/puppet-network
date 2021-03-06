#!/usr/bin/env rspec
require 'spec_helper'
require 'open-uri'
  describe 'network_facts' do
    describe 'network_public_ip fact' do
      before do
        Facter::Util::Resolution.any_instance.stubs(:open).returns(stub(:read => '1.1.1.1'))
      end
      it "should be our public ip" do
        Facter.fact(:network_public_ip).value.should == '1.1.1.1'
      end
    end
  end
  describe 'network_nexthop_ip' do
      before do
        Facter.fact(:kernel).stubs(:value).returns('linux')
      end
    context 'on a Linux host' do
      before do 
        Facter::Util::Resolution.stubs(:exec).with('/sbin/ip route show 0/0').returns('default via 1.2.3.4 dev eth0')
      end
      it 'should exec ip and determine the next hop' do
        Facter.fact(:network_nexthop_ip).value.should == '1.2.3.4'
      end
    end
  end
  describe 'network_primary_interface' do
      before do
        Facter.fact(:kernel).stubs(:value).returns('linux')
      end
    context 'on a Linux host' do
      before do 
        Facter::Util::Resolution.stubs(:exec).with('/sbin/ip route show 0/0').returns('default via 1.2.3.4 dev eth0')
        Facter::Util::Resolution.stubs(:exec).with('/sbin/ip route get 1.2.3.4').returns('1.2.3.4 dev eth0  src 1.2.3.99\n
    cache  mtu 1500 advmss 1460 hoplimit 64')
      end
      it 'should exec ip and determine the primary interface' do
        Facter.fact(:network_primary_interface).value.should == 'eth0'
      end
    end
  end
  describe 'network_primary_ip' do
      before do
        Facter.fact(:kernel).stubs(:value).returns('linux')
      end
    context 'on a Linux host' do
      before do 
        Facter::Util::Resolution.stubs(:exec).with('/sbin/ip route show 0/0').returns('default via 1.2.3.4 dev eth0')
        Facter::Util::Resolution.stubs(:exec).with('/sbin/ip route get 1.2.3.4').returns("1.2.3.4 dev eth0  src 1.2.3.99\n
    cache  mtu 1500 advmss 1460 hoplimit 64")
      end
      it 'should exec ip and determine the primary ip address' do
        Facter.fact(:network_primary_ip).value.should == '1.2.3.99'
      end
    end
  end