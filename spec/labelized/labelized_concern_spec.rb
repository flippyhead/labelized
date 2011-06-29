require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class Labeling < ActiveRecord::Base
  include Labelized::LabelingConcern
end

class LabelSet < ActiveRecord::Base
  include Labelized::LabelSetConcern
  
  belongs_to :root
  labelized :scope => :root_id
end

class Label < ActiveRecord::Base
  include Labelized::LabelConcern
  
  belongs_to :root
  labelized :scope => :root_id
  validates_presence_of :root_id
end

class Root < ActiveRecord::Base
  has_many :things
end

class Thing < ActiveRecord::Base
  include Labelized::LabelizedConcern
  belongs_to :root
  labelized :tags
end

# thing.tags # [<label id=1>]
# label.label_set 
# thing.labels # [<label id=1>]
# thing.labelings 

describe Labelized::LabelizedConcern do  
  let!(:root){Root.create(:name => "Root One")}
  let!(:label_set){LabelSet.create(:name => 'tags', :root_id => root.id)}
  let(:thing){Thing.new(:root_id => root.id, :tags => ['tag one'])}
  subject{thing}
  
  it{should_not be_nil}
  it{should respond_to(:tags)}
  it{should respond_to(:tags=)}
  it{should have(1).tag}
  
  it{should respond_to(:labels)}
  it{should respond_to(:labelings)}
  
  its(:tags){should be_present}
  
  context 'the cached tags' do
    subject{thing.tags.first}
    
    it{should be_instance_of Label}
    its(:name){should == 'tag one'}
  end
    
  context 'setting labels dynamically' do
    before do
      thing.label('tag one', :tags)
    end
    
    its(:tags){should be_present}
    specify{subject.label_for(:tags).should be_present}
  end
    
  context 'the result of setting one label' do
    subject{thing.tags= ['tag one']}

    it{should be_instance_of Array}
    it{should include('tag one')}
    its(:size){should == 1}
  end
  
  context 'after saved' do
    before do
      thing.save
    end
    
    its(:tags){should respond_to(:each)} # collection-like thing
    
    context 'each label' do
      subject{thing.labels.first}
      
      it{should_not be_new_record}
      its(:name){should == 'tag one'}
      its(:root){should == root}
      its(:label_set){should == label_set}
    end

    context 'exiting labels' do
      it 'should re-use existing labels' do
        expect {
          thing.tags = ['tag one', 'tag two']
          thing.save
        }.to change{Label.count}.by(1)
      end
    end
  end

end