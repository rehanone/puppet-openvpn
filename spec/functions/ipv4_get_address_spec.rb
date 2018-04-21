require 'spec_helper'

describe 'ipv4_get_address' do
  it { is_expected.to run.with_params('0.0.0.0').and_return('0.0.0.0') }
  it { is_expected.to run.with_params('8.8.8.8/0').and_return('8.8.8.8') }
  it { is_expected.to run.with_params('8.8.8.8/255.255.0.0').and_return('8.8.8.8') }
end
