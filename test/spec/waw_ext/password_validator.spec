require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe AcmScW::PasswordValidator do
  
  subject{ AcmScW::PasswordValidator.new }
  
  it 'should correctly valid empty password when not required' do
    subject.validate(false, "", "").should be_true
  end

  it 'should reject non empty passwords when not required but passwords set' do
    subject.validate(false, "aaa", "abs").should be_false
    subject.validate(false, "HelloPass", "HelloPass").should be_false
  end

  it 'should reject invalid passwords when required' do
    subject.validate(true, nil, nil).should be_false
  end

  it 'should reject invalid passwords when required' do
    subject.validate(true, "", "").should be_false
  end

end