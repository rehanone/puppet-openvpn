require 'spec_helper'

describe 'ipv4_cidr_to_subnet' do
  it { is_expected.to run.with_params(30).and_return('255.255.255.252') }
  it { is_expected.to run.with_params(28).and_return('255.255.255.240') }
  it { is_expected.to run.with_params(24).and_return('255.255.255.0') }
  it { is_expected.to run.with_params(16).and_return('255.255.0.0') }
  it { is_expected.to run.with_params(8).and_return('255.0.0.0') }
  it { is_expected.to run.with_params(4).and_return('240.0.0.0') }
  it { is_expected.to run.with_params(0).and_return('0.0.0.0') }
end
