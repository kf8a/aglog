require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../init'

class PaginationTest < ActiveRecordTestCase
  fixtures :topics, :replies, :developers, :projects, :developers_projects
  
  class PaginationController < ActionController::Base
    # self.view_paths = [ "#{File.dirname(__FILE__)}/../fixtures/" ]
    
    def simple_paginate
      @topic_pages, @topics = paginate(:topics)
      render :nothing => true
    end
    
    def paginate_with_class_name
      @developer_pages, @developers = paginate(:developers, :class_name => "DeVeLoPeR")
      render :nothing => true
    end
    
    def paginate_with_singular_name
      @developer_pages, @developers = paginate(:ninjas, :singular_name => 'developer')
      render :nothing => true
    end
    
    def paginate_with_join
      @developer_pages, @developers = paginate(:developers, 
                                             :joins => 'LEFT JOIN developers_projects ON developers.id = developers_projects.developer_id',
                                             :conditions => 'project_id=1')        
      render :nothing => true
    end
    
    def paginate_with_join_and_count
      @developer_pages, @developers = paginate(:developers, 
                                             :joins => 'd LEFT JOIN developers_projects ON d.id = developers_projects.developer_id',
                                             :conditions => 'project_id=1',
                                             :count => "d.id")        
      render :nothing => true
    end
    
    def rescue_errors(e) raise e end
    def rescue_action(e) raise e end
  end
  
  def setup
    @controller = PaginationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    super
  end

  # Single Action Pagination Tests

  def test_simple_paginate
    get :simple_paginate
    assert_equal 1, assigns(:topic_pages).page_count
    assert_equal 3, assigns(:topics).size
  end
  
  def test_paginate_with_explicit_names
    get :paginate_with_class_name
    expected = assigns(:developers)
    assert expected.size > 0
    assert_equal DeVeLoPeR, expected.first.class

    get :paginate_with_singular_name
    assert_equal expected.size, assigns(:developers).size
  end
      
  def test_paginate_with_join_and_count
    get :paginate_with_join
    expected = assigns(:developers)
    get :paginate_with_join_and_count
    assert_equal expected, assigns(:developers)
  end
end
