require 'spec_helper'

describe AreaCopier do
  describe 'Copying areas to new companies' do
    let(:company_1) { find_or_factory(:company, name: 'lter')}
    let(:company_2) { find_or_factory(:company, name: 'glbrc')}
    context 'a single area' do
      before(:each) do
        @area = FactoryGirl.build_stubbed(:area, name: 'test', company: company_1)
        @other_area = AreaCopier.copy_area_to_company(@area,company_2)
      end
      it 'should be valid' do
        expect(@other_area).to be_valid
      end
      it 'should not be the same object' do
        expect(@other_area).to_not be @area
      end
      it 'should keep the same name' do
        expect(@other_area.name).to eq @area.name
      end
      it 'should belong to the other company' do
        expect(@other_area.company).to be company_2
      end
    end
    context 'as a tree of areas' do
      before(:each) do
        @area =   find_or_factory(:area, :name=>'Test1', :company => company_1)
        @child1 = find_or_factory(:area, :name=>'Test1R1', :company => company_1)
        @child2 = find_or_factory(:area, :name=>'Test1R2', :company => company_1)
        @child3 = find_or_factory(:area, :name=>'Test1R3', :company => company_1)
        @child1.move_to_child_of(@area)
        @child2.move_to_child_of(@area)
        @child3.move_to_child_of(@child2)
        @other_area = AreaCopier.copy_area_to_company(@area, company_2)
      end

      it 'should not be the same object' do
        expect(@other_area).to_not be @area
      end

      it 'should keep the same name' do
        expect(@other_area.name).to eq @area.name
      end

      it 'should belong to the other company' do
        expect(@other_area.company).to eq company_2
      end

      it 'should have children with the same name' do
        expect(@other_area.children.map(&:name)).to eq [@child1.name, @child2.name]
      end

      it 'should keep childrens children with the same name' do
        expect(@other_area.children.last.children.map(&:name)).to eq [@child3.name]
      end

      it 'should move the children to the other company' do
        expect(@other_area.descendants.first.company).to eq company_2
      end
    end
  end
end
