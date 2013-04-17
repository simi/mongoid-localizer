require 'spec_helper'

describe Mongoid::Localizer do
  describe "#locale" do
    it "default to I18n.locale" do
      expect(Mongoid::Localizer.locale).to eq(I18n.locale)
    end

    it "can be overwritten" do
      Mongoid::Localizer.locale = :cs
      expect(Mongoid::Localizer.locale).to eq(:cs)
    end
  end

  describe "with default language" do
    before(:each) do
      I18n.locale = Mongoid::Localizer.locale = :en
    end

    describe "fallback" do
      before(:each) do
        I18n.should_receive(:respond_to?).twice.with(:fallbacks).and_return(true)
        I18n.stub(:fallbacks).and_return({})
        I18n.fallbacks[:de] = [:de, :en]
        I18n.fallbacks[:en] = [:en, :de]

        Dictionary.create(name: "Otto", description: "English", slug: "otto")
      end

      let(:d) { Dictionary.last }

      it "resolve fallback" do
        expect(d.description).to eq("English")
        I18n.locale = Mongoid::Localizer.locale = :de
        expect(d.description).to eq("English")
      end

      it "will skip fallback when prevet_fallback is true" do
        expect(d.slug).to eq("otto")
        I18n.locale = Mongoid::Localizer.locale = :de
        expect(d.slug).to eq(nil)
      end
    end

    describe "switch locale and save" do
      let!(:dictionary) do
        d = Dictionary.create(name: "Otto", description: "English")
        Mongoid::Localizer.locale = :de
        d.description = "Deutsch"
        d.save
        Mongoid::Localizer.locale = :en
        d
      end

      it "loads correct translated fields" do
        Mongoid::Localizer.locale = :en
        expect(dictionary.description).to eq("English")
        Mongoid::Localizer.locale = :de
        expect(dictionary.description).to eq("Deutsch")
      end

      it "finds proper document by localized fields in" do
        Mongoid::Localizer.locale = :de
        expect(Dictionary.in(description: "Deutsch").entries).to eq([dictionary])
      end
    end

    describe "#with_locale" do
      let(:dictionary) do
        d = Dictionary.new(name: "Otto", description: "English")
        Mongoid::Localizer.locale = :de
        d.description = "Deutsch"
        d.save
        Mongoid::Localizer.locale = :en
        d
      end

      it "switch mongoid locale for block and reset back" do
        expect(dictionary.description).to eq("English")
        Mongoid::Localizer.with_locale(:de) do
          expect(dictionary.description).to eq("Deutsch")
        end
        expect(dictionary.description).to eq("English")
      end
    end
  end
end
