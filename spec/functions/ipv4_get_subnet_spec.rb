require 'spec_helper'

describe 'ipv4_get_subnet' do
  it { is_expected.to run.with_params('8.8.8.8/30').and_return('255.255.255.252') }
  it { is_expected.to run.with_params('8.8.8.8/28').and_return('255.255.255.240') }
  it { is_expected.to run.with_params('8.8.8.8/24').and_return('255.255.255.0') }
  it { is_expected.to run.with_params('8.8.8.8/16').and_return('255.255.0.0') }
  it { is_expected.to run.with_params('8.8.8.8/8').and_return('255.0.0.0') }
  it { is_expected.to run.with_params('8.8.8.8/4').and_return('240.0.0.0') }
  it { is_expected.to run.with_params('8.8.8.8/0').and_return('0.0.0.0') }

  it { is_expected.to run.with_params('8.8.8.8/255.255.0.0').and_return('255.255.0.0') }
end
