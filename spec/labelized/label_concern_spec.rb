require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class Label < ActiveRecord::Base
  include Labelized::LabelConcern
  
  belongs_to :root
  labelized
end

class Root < ActiveRecord::Base
  has_many :things
end

class Thing < ActiveRecord::Base
  include Labelized::LabelizedConcern  
  belongs_to :root
  labelized [:tags]
end


describe Labelized::LabelConcern do
  let(:root){Root.create(:name => "Root One")}
  let(:thing){Thing.new(:root => root)}

  subject{Label.new(:root => root)}
  
  it{should_not be_nil}
   
  it 'should build from scope' do
    Label.label_scope(thing).build.root.should == root
  end
  
  it 'should create from scope' do
    Label.label_scope(thing).create.root.should == root
  end
  
  context 'when created' do
    before do
      subject.save!
    end
    
    
  end
  
end