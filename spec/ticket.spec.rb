require './spec/spec_helper'

describe Bingo::Ticket do
    describe '.check' do
      describe 'empty values' do
        it 'returns nil' do
          result = described_class.check([],[])
          expect(result).to eq(nil)
        end
      end

      describe '0 row matches' do
        it 'returns nil' do
          result = described_class.check([[1],[2],[3]],[6])
          expect(result).to eq(nil)
        end
      end

      describe '1 row matches' do
        it 'returns 1' do
          result = described_class.check([[1],[2],[3]],[1])
          expect(result).to eq(1)
        end
      end

      describe '2 rows match' do
        it 'returns 2' do
          result = described_class.check([[1],[2],[3]],[1,3])
          expect(result).to eq(2)
        end
      end

      describe '3 rows match' do
        it 'returns 3' do
          result = described_class.check([[1],[2],[3]],[1,3,2])
          expect(result).to eq(3)
        end
      end
    end
end
