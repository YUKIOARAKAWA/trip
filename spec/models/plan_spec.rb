require 'rails_helper'

RSpec.describe Plan, :type => :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe "バリデーション" do
    before do
      @plan = FactoryGirl.create(:plan) do |p|
      p.places.create(FactoryGirl.attributes_for(:place))
      end
      puts "@planの中身"
      puts @plan.name
      puts Plan.all.count
    end

    context "名称、開始日、終了日が全て入力されている場合OK" do
      it { expect(@plan).to be_valid }
    end

    context "名称は入力されていない場合NG" do
      before do
        @plan.name = nil
        puts @plan.name
        puts "いあm"
      end
      it { expect(@plan).to be_invalid }
    end

    context "開始日が入力されていない場合NG" do
      before do
        @plan.start_date = nil
        puts @plan.name
      end
      it { expect(@plan).to be_invalid }
    end

    context "終了日が入力されていない場合NG" do
      before do
        @plan.end_date = nil
      end
      it { expect(@plan).to be_invalid }
    end

  end
end
