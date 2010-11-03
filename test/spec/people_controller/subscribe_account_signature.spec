require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe AcmScW::Controllers::PeopleController do

  describe "subscribe_account signature" do
    
    let(:valid_params){{ 
      :mail             => "testuser@acm-sc.be",
      :last_name        => "LastName",
      :first_name       => "FirstName",
      :set_password     => true,
      :password         => "testtesttest",
      :password_confirm => "testtesttest"
    }}
    subject{ AcmScW::Controllers::PeopleController.subscribe_account.signature }

    it { should_not be_nil }
    
    it 'should allow typical valid parameters' do
      subject.allows?(valid_params).should be_true
    end
    
    it 'should not allow missing mail' do
      subject.allows?(valid_params.merge(:mail => nil)).should be_false
    end
    
    it 'should reject set_password to false' do
      subject.allows?(valid_params.merge(:set_password => nil)).should be_false
      subject.allows?(valid_params.merge(:set_password => false)).should be_false
    end

    it 'should reject missing passwords' do
      subject.allows?(valid_params.merge(:password => nil, :password_confirm => nil)).should be_false
    end

    it 'should reject invalid passwords' do
      subject.allows?(valid_params.merge(:password => "HelloTest", :password_confirm => "HelloTast")).should be_false
    end

  end
  
end