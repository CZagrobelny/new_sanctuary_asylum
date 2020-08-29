require 'rails_helper'

RSpec.describe Community, type: :model do

  describe 'validations' do
    describe 'slug_format' do
      context 'with a slug that contains spaces' do
        let(:community) { build :community, slug: 'test with spaces', region: create(:region) }
        it 'is NOT valid' do
          community.save
          expect(community.errors.full_messages).to include('Slug must be all lowercase letters with no spaces. Dashes may be used to separate words, like "a-slug-with-dashes"')
        end
      end

      context 'with a slug that contains capital letters' do
        let(:community) { build :community, slug: 'TestWithCapitals', region: create(:region) }
        it 'is NOT valid' do
          community.save
          expect(community.errors.full_messages).to include('Slug must be all lowercase letters with no spaces. Dashes may be used to separate words, like "a-slug-with-dashes"')
        end
      end

      context 'with a slug that contains only lowercase letters and dashes' do
        let(:community) { build :community, slug: 'test-with-dashes', region: create(:region) }
        it 'is valid' do
          expect(community.save).to eq true
        end
      end
    end
  end
end
