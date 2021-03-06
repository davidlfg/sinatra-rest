require File.dirname(__FILE__) + '/helper'

describe 'routes' do

  before(:each) do
    Person.reset!
  end

  describe 'one by one' do

    before(:each) do
      mock_rest Person    
    end

    it 'should list all people on index by their id' do
      index('/people').should == [200, '<people><person><id>1</id></person><person><id>2</id></person><person><id>3</id></person></people>']
    end

    it 'should prepare an empty item on new' do
      new('/people/new').should == [200, '<person><id></id><name></name></person>']
    end

    it 'should create an item on post' do
      create('/people', :name => 'new resource').should == [302, 'person created']
    end

    it 'should show an item on get' do
      show('/people/1').should == [200, '<person><id>1</id><name>one</name></person>']
    end

    it 'should get the item for editing' do
      edit('/people/1/edit').should == [200, '<person><id>1</id><name>one</name></person>']
    end

    it 'should update an item on put' do
      update('/people/1', :name => 'another name').should == [302, 'person updated']
    end

    it 'should destroy an item on delete' do
      destroy('/people/1').should == [302, 'person destroyed']
    end

  end

  describe 'options' do

    it 'should add :all routes' do
      mock_rest Person

      index('/people').should                         == [200, '<people><person><id>1</id></person><person><id>2</id></person><person><id>3</id></person></people>']
      new('/people/new').should                       == [200, '<person><id></id><name></name></person>']
      create('/people', :name => 'new person').should == [302, "person created"]
      show('/people/1').should                        == [200, '<person><id>1</id><name>one</name></person>']
      edit('/people/1/edit').should                   == [200, "<person><id>1</id><name>one</name></person>"]
      update('/people/1', :name => 'new name').should == [302, "person updated"]
      destroy('/people/1').should                     == [302, "person destroyed"]
    end

    it 'should add :readable routes' do
      mock_rest Person, :routes => :readable

      index('/people').should                         == [200, '<people><person><id>1</id></person><person><id>2</id></person><person><id>3</id></person></people>']
      show('/people/1').should                        == [200, '<person><id>1</id><name>one</name></person>']
      
      new('/people/new').should                       == [404, "route not found"]
      create('/people', :name => 'new person').should == [404, "route not found"]
      edit('/people/1/edit').should                   == [404, "route not found"]
      update('/people/1', :name => 'new name').should == [404, "route not found"]
      destroy('/people/1').should                     == [404, "route not found"]
    end

    it 'should add :writeable routes' do
      mock_rest Person, :routes => :writeable

      index('/people').should                         == [200, '<people><person><id>1</id></person><person><id>2</id></person><person><id>3</id></person></people>']
      show('/people/1').should                        == [200, '<person><id>1</id><name>one</name></person>']
      create('/people', :name => 'new person').should == [302, "person created"]
      update('/people/1', :name => 'new name').should == [302, "person updated"]
      destroy('/people/1').should                     == [302, "person destroyed"]

      new('/people/new').should                       == [404, "route not found"]
      edit('/people/1/edit').should                   == [404, "route not found"]
    end

    it 'should add :editable routes' do
      mock_rest Person, :routes => :editable

      index('/people').should                         == [200, '<people><person><id>1</id></person><person><id>2</id></person><person><id>3</id></person></people>']
      new('/people/new').should                       == [200, '<person><id></id><name></name></person>']
      create('/people', :name => 'new person').should == [302, "person created"]
      show('/people/1').should                        == [200, '<person><id>1</id><name>one</name></person>']
      edit('/people/1/edit').should                   == [200, "<person><id>1</id><name>one</name></person>"]
      update('/people/1', :name => 'new name').should == [302, "person updated"]
      destroy('/people/1').should                     == [302, "person destroyed"]
    end

    it 'should add routes by name' do
      mock_rest Person, :routes => [:readable, :new, :create]

      index('/people').should                         == [200, '<people><person><id>1</id></person><person><id>2</id></person><person><id>3</id></person></people>']
      show('/people/1').should                        == [200, '<person><id>1</id><name>one</name></person>']
      new('/people/new').should                       == [200, '<person><id></id><name></name></person>']
      create('/people', :name => 'new person').should == [302, "person created"]
      
      edit('/people/1/edit').should                   == [404, "route not found"]
      update('/people/1', :name => 'new name').should == [404, "route not found"]
      destroy('/people/1').should                     == [404, "route not found"]
    end

  end

end
